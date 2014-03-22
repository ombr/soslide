class Operation < ActiveRecord::Base
  serialize :args
  belongs_to :site

  def execute
    self.logs ||= ''
    exception = nil
    new_logs = capture(:stdout) do
      begin
        yield
      rescue Exception => e
        Raven.capture_exception(e)
        exception = e
        puts e.inspect
        puts e.backtrace.join("\n")
      end
    end
    self.logs += new_logs
    self.save!
    raise exception if exception
    new_logs
  end
end
