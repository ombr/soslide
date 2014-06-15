ActiveAdmin.register Site do
  index do
    selectable_column
    id_column
    column :name
    column :created_at
    column :updated_at
    actions
  end

  show do |site|
    attributes_table do
      site.class.columns.each { |col| row col.name }
    end
    active_admin_comments
    panel 'Operations' do
      table_for site.operations do
        column :id
        column :command
        column :logs
        column :exec_time do |op|
          distance_of_time_in_words(op.updated_at - op.created_at)
        end
      end
    end
  end
  filter :name
end
