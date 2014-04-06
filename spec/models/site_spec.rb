require 'spec_helper'

describe Site do
  subject { create :site }

  it do
    should allow_value('luc@boissaye.fr', 'contact@soslide.com').for(:email)
  end
  it do
    should_not allow_value('luc@boissaye.f', 'contact@soslide').for(:email)
  end
  it do
    should allow_value('studiocuicui', 'ombr', 'super-site53').for(:name)
  end
  it do
    should_not allow_value('12studiocuicui', '12', 'sup').for(:name)
  end
  it { should have_many(:operations) }

  describe '#heroku' do
    it 'execute an heroku command' do
      Heroku::Command.stub(:load)
      Heroku::Command.should_receive(:run) do
        puts 'DATABASE_URL lalala'
      end.with('addons:add', %w(heroku-postgresql -a my_app))
      expect(
        subject.heroku('addons:add heroku-postgresql -a', 'my_app')
      ).to eq "DATABASE_URL lalala\n"
      expect(
        subject.operations.first.command
      ).to eq 'heroku addons:add heroku-postgresql -a'
      expect(subject.operations.first.args).to eq ['my_app']
    end
  end

  describe '#progress' do
    context 'when not created' do
      it { expect(subject.progress).to eq 10 }
    end
    context 'when everything is done' do
      subject do
        create :site,
          status_dns: true,
          status_monitoring: true,
          status_domain: true,
          status_app: true,
          status_database: true
      end
      it { expect(subject.progress).to eq 100 }
    end

  end

  describe '#heroku_name' do
    it do
      expect(subject.heroku_name).to eq "#{ENV['APP_PREFIX']}-#{subject.name}"
    end
  end

  describe '#url' do
    it { expect(subject.url).to eq "http://#{subject.domain}/" }
  end

  describe '#admin_url' do
    it { expect(subject.admin_url).to eq "http://#{subject.domain}/admin" }
  end

  describe '#heroku_connection' do
    it 'connects to DATABASE_URL' do
      pending 'Need to find a proper way to test this...'
      subject.should_receive(:heroku_config).and_return('super_secret')
      Database
        .should_receive(:establish_connection)
        .with('super_secret')
      Database
        .should_receive(:connection)
      Database.should_receive(:establish_connection)
        .with(no_args)
      subject.heroku_connection do |connection|
        expect(connection).to be_true
      end
    end
  end

  describe '#heroku_config' do
    it 'uses heroku to retreive the config' do
      Heroku::Command
        .should_receive(:run)
        .with('config:get', ['DATABASE_URL', '-a', subject.heroku_name]) do
        puts 'super_secret'
      end
      expect(subject.heroku_config('DATABASE_URL')).to eq "super_secret\n"
    end
    it 'raise the exception on exception' do
      Heroku::Command
        .should_receive(:run)
        .with('config:get', ['DATABASE_URL', '-a', subject.heroku_name]) do
        fail 'Error !'
      end
      expect do
        subject.heroku_config('DATABASE_URL')
      end.to raise_error('Error !')
    end

  end

  describe 'self.heroku_exec' do
    it 'serialize arguments'  do
      Heroku::Command
        .should_receive(:run)
        .with('apps:info', %w(-i -a test -b -c ))
      Site.heroku_exec('apps:info -i', '-a test', '-b', '-c')
    end
  end

  describe 'self.heroku_apps' do
    it 'returns the list of application' do
      Heroku::Command.should_receive(:run).with('apps', []) do
        puts File.read(Rails.root.join('spec', 'fixtures', 'heroku_apps'))
      end
      expect(Site.heroku_apps).to eq ['prtfl-cuicui']
    end
  end
end
