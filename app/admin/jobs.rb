ActiveAdmin.register Delayed::Job do
  menu priority: 100, label: 'Jobs'
  index do
    selectable_column
    id_column
    column :object do |job|
      object = job.payload_object.object
      link_to [:admin, object] do
        "#{object.class} : #{object.try(:name)}"
      end
    end
    column :method do |job|
      job.payload_object.method_name
    end
    column :attempts
    column :last_error do |job|
      job.last_error.split("\n").first if job.last_error
    end
    actions
  end

  filter :email
  filter :current_sign_in_at
  filter :sign_in_count
  filter :created_at

end
