class Site < ActiveRecord::Base
  validates :name, length: { minimum: 1, maximum: 21 }, format: { with: /\A[a-z][a-z0-9-]{0,20}\z/, message: ' Name must start with a letter and can only contain lowercase letters, numbers, and dashes. Name must be between 3 to 21 characters.' }
  validates :email, :email => {:strict_mode => true}

  has_many :operations


  def create_app
    heroku('fork', heroku_name, '-a', ENV['APP_PREFIX'])
    delay.setup_domain
    delay.init_database
  end

  def heroku_name
    "#{ENV['APP_PREFIX']}-#{name}"
  end

  def init_database
    add_database
    heroku('run rake db:schema:load -a', heroku_name)
    heroku('restart -a', heroku_name)
  end

  def add_database
    res=heroku('addons:add heroku-postgresql', '-a', heroku_name)
    res.match(/.*(HEROKU_.*URL).*/)
    database_url = $1
    heroku("pg:promote #{database_url} -a #{heroku_name}")
  end

  def setup_domain
    create_domain
    set_domain
  end

  def create_domain
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
  end

  def set_domain
    heroku 'domains:add', domain, '-a', heroku_name
    heroku 'config:set', "DOMAIN=#{domain}", '-a', heroku_name
  end

  def domain
    domain = "#{name}.#{ENV['SITES_DOMAINS']}"
  end

  def heroku command, *arguments
    operations.create!(
      command: command,
      args: arguments
    ).execute do
      args = command.split(' ') + arguments
      cmd = args.shift
      Heroku::Command.load
      Heroku::Command.run(cmd, args)
    end
  end
end
