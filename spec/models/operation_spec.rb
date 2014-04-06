require 'spec_helper'

describe Operation do
  let(:site) { create :site }
  subject { create :operation }

  it { should belong_to(:site) }

  describe 'self.safe_execution' do
    it 'capture and return stdout' do
      exception, logs = Operation.safe_execution do
        puts 'Hello'
      end
      expect(logs).to eq "Hello\n"
      expect(exception).to be_nil
    end
    it 'puts the error in the log and in the exception' do
      exception, logs = Operation.safe_execution do
        fail 'Hello'
      end
      expect(logs).to match(/Hello/)
      expect(exception.message).to eq 'Hello'
    end
  end

  describe '#execute' do
    context 'when log is nil' do
      it 'capture stdout and put it to the log' do
        subject.execute do
          puts 'TEST !'
        end
        expect(subject.reload.logs).to eq "TEST !\n"
      end
    end
    context 'when log is not nil' do
      it 'capture stdout and put it to the log' do
        subject.logs = "lala\n"
        subject.execute do
          puts 'TEST !'
        end
        expect(subject.reload.logs).to eq "lala\nTEST !\n"
      end
    end

    it 'Send the exception to sentry' do
      Raven.should_receive(:capture_exception)
      begin
        subject.execute do
          fail 'SoSlide'
        end
      rescue
      end
    end

    it 'log exception and add it to the log' do
      begin
        subject.execute do
          fail 'SoSlide'
        end
      rescue
        expect(subject.reload.logs).to match(/SoSlide/)
      end
    end
  end
end
