class Operation < ActiveRecord::Base
  serialize :args
  belongs_to :site


  def execute
    self.logs ||= ''
    exception, new_logs = self.class.safe_execution do
      yield
    end
    self.logs += new_logs
    self.save!
    raise exception if exception
    new_logs
  end

  def self.safe_execution
    exception = nil
    logs = capture(:stdout) do
      begin
        yield
      rescue Exception => e
        Raven.capture_exception(e)
        exception = e
        puts e.inspect
        puts e.backtrace.join("\n")
      end
    end
    [exception, logs]
  end
end
