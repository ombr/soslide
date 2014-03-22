require 'spec_helper'

describe Site do
  subject { create :site }

  it { should allow_value('luc@boissaye.fr', 'contact@soslide.com').for(:email) }
  it { should_not allow_value('luc@boissaye.f', 'contact@soslide').for(:email) }
  it { should allow_value('studiocuicui', 'ombr', 'super-site53').for(:name) }
  it { should_not allow_value('12studiocuicui', '12', 'sup').for(:name) }
  it { should have_many(:operations) }

  describe '#heroku' do
    it 'execute an heroku command' do
      Heroku::Command.stub(:load)
      Heroku::Command.should_receive(:run) do
        puts 'DATABASE_URL lalala'
      end.with('addons:add', ['heroku-postgresql', '-a', 'my_app'])
      expect(subject.heroku('addons:add heroku-postgresql -a', 'my_app')).to eq "DATABASE_URL lalala\n"
      expect(subject.operations.first.command).to eq 'heroku addons:add heroku-postgresql -a'
      expect(subject.operations.first.args).to eq ['my_app']
    end
  end

  describe '#progress' do
    context 'when not created' do
      it { expect(subject.progress).to eq 10 }
    end
    context 'when everything is done' do
      subject { create :site, status_dns: true, status_monitoring: true, status_domain: true, status_app: true, status_database: true}
      it { expect(subject.progress).to eq 100 }
    end

  end

  describe '#heroku_name' do
    it { expect(subject.heroku_name).to eq "#{ENV['APP_PREFIX']}-#{subject.name}" }
  end
end
