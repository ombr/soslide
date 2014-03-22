module ApplicationHelper
  def tab_link(url, html_options: {})
    content_tag :li, class: ('active' if current_page?(url)) do
      link_to url, html_options do
        yield
      end
    end
  end
end
