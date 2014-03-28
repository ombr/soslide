class Site < ActiveRecord::Base
  validates :name, length: { minimum: 1, maximum: 21 }, format: { with: /\A[a-z][a-z0-9-]{0,20}\z/, message: ' Name must start with a letter and can only contain lowercase letters, numbers, and dashes. Name must be between 3 to 21 characters.' }
  validates :name, :uniqueness => true
  validates :email, :email => {:strict_mode => true}

  has_many :operations

  def create_site
    heroku('fork', heroku_name, '-a', ENV['APP_PREFIX'])
    update(status_app: true)
    delay.setup_domain
    delay.init_database
    delay.uptimerobot_create
  end

  def uptimerobot_create
    operations.create!(
      command: 'UpTimeRobot#Create',
      args: [domain]
    ).execute do
      if ENV['UPTIMEROBOT']
        UptimeRobot::Monitor.create(
          name: domain,
          url: "http://#{domain}"
        )
        puts 'OK'
      else
        puts 'NO ENV.'
      end
    end
  end

  def heroku_name
    "#{ENV['APP_PREFIX']}-#{name}"
  end

  def init_database
    add_database
    heroku('run rake db:schema:load -a', heroku_name)
    heroku('restart -a', heroku_name)
    update(status_database: true)
  end

  def add_database
    res=heroku('addons:add heroku-postgresql', '-a', heroku_name)
    res.match(/.*(HEROKU_.*URL).*/)
    database_url = $1
    heroku("pg:promote #{database_url} -a #{heroku_name}")
  end

  def setup_domain
    delay.set_domain
    create_domain
  end

  def create_domain
    operations.create!(
      command: 'AWS::Route53#Create',
      args: [domain]
    ).execute do
      r53 = AWS::Route53.new
      resp = r53.client.change_resource_record_sets({ :hosted_zone_id => ENV['AWS_ZONE_ID'], :change_batch => {
        :comment => "Creating new subdomain: #{domain}", :changes => [{
          :action => "CREATE", :resource_record_set => {
            :name => domain,
            :type => "CNAME",
            :ttl => 300,
            :resource_records => [{
              :value => "#{heroku_name}.herokuapp.com"
            }]
          }
        }]
      }})
      update(status_dns: true)
      puts 'OK'
    end
  end

  def set_domain
    heroku 'domains:add', domain, '-a', heroku_name
    heroku 'config:set', "DOMAIN=#{domain}", '-a', heroku_name
    update(status_domain: true)
  end

  def domain
    domain = "#{name}.#{ENV['SITES_DOMAINS']}"
  end

  def uptimerobot_create
    if ENV['UPTIMEROBOT']
      UptimeRobot::Monitor.create(
        name: domain,
        url: "http://#{domain}"
      )
      update(status_monitoring: true)
    else
      update(status_monitoring: false)
    end
  end

  def destroy_site
    heroku 'apps:destroy', '-a', heroku_name, '--confirm', heroku_name
  end

  def heroku command, *arguments
    operations.create!(
      command: "heroku #{command}",
      args: arguments
    ).execute do
      self.class.heroku_exec(command, *arguments)
    end
  end

  def self.import_sites
    exeption, logs = Operation.safe_execution do
      heroku_exec('apps')
    end
    logs.split("\n").each do |line|
      if line.match(/^([^ ]*-[^ ]*) .*$/)
        puts "===>#{$1}"
      end
    end
    ''
  end

  def self.heroku_exec *arguments
    args = arguments.map {|a| a.split(' ') }.flatten
    cmd = args.shift
    Heroku::Command.load
    Heroku::Command.run(cmd, args)
  end

  def progress
    progress = 10
    progress += 25 if status_app
    progress += 12 if status_dns
    progress += 13 if status_domain
    progress += 30 if status_database
    progress += 10 if status_monitoring
    progress
  end

  def url
    "http://#{domain}/"
  end
  def admin_url
    "#{url}admin"
  end

  def config_get var
    heroku('config:get', var, '-a', heroku_name)
  end

  def connection
    connection = ActiveRecord::Base
      .establish_connection(config_get('DATABASE_URL'))
      .connection
    begin
      yield connection
    ensure
      ActiveRecord::Base.establish_connection
    end
  end

  def update_stats
    connection do |connection|
      puts connection.execute('SELECT COUNT(*) AS pages FROM pages').to_a.inspect
      puts connection.execute('SELECT COUNT(*) AS images FROM images').to_a.inspect
      puts connection.execute('SELECT * FROM sites').to_a.inspect
      puts connection.execute('SELECT * FROM users').to_a.inspect
    end
  end


  after_update do
    Pusher[id.to_s].trigger('update', progress: "#{progress}%")
  end

   #ActiveRecord::Base.establish_connection('postgres://qzbhblrwdhpskg:qCL5zol8nF1ahOHIF2xuJPgaSW@ec2-54-220-0-117.eu-west-1.compute.amazonaws.com:5432/dbsd9jh2birjn5').connection.execute('SELECT * FROM users').to_active re
end
