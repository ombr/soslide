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
        exception = e
        puts e.inspect
      end
    end
    self.logs += new_logs
    self.save!
    raise exception if exception
    new_logs
  end
end
