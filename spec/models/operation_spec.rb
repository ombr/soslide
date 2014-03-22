require 'spec_helper'

describe Operation do
  let(:site) { create :site }
  subject { create :operation }

  it { should belong_to(:site) }

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
          raise 'SoSlide'
        end
      rescue
      end
    end

    it 'log exception and add it to the log' do
      begin
        subject.execute do
          raise 'SoSlide'
        end
      rescue
        expect(subject.reload.logs).to match(/SoSlide/)
      end
    end
  end
end
