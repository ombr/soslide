ActiveAdmin.register_page 'Dashboard' do

  content do
    columns do
      column do
        panel 'Info' do
          para 'Welcome to ActiveAdmin.'
        end
      end
      column do
        panel 'Recent Sites' do
          ul do
            Site.limit(5).map do |site|
              li link_to(site.name, admin_site_path(site))
            end
          end
        end
      end
    end
  end # content
end
