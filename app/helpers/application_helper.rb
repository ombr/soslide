module ApplicationHelper
  def bootstrap_class_for(flash_type)
    bootstrap = { success: 'success',
                  error: 'danger',
                  alert: 'warning',
                  notice: 'info'
    }
    if bootstrap[flash_type]
      "alert-#{bootstrap[flash_type]}"
    else
      'alert-notice'
    end
  end

  def preview_link
    return s_image_path(page_id: @image.page, id: @image) if @image && @image.id
    return s_page_path(id: @page) if @page && @page.id
    root_path
  end

  def tab_link(url, html_options: {})
    content_tag :li, class: ('active' if current_page?(url)) do
      link_to url, html_options do
        yield
      end
    end
  end
end
