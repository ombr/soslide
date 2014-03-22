class PagesController < ApplicationController
  include HighVoltage::StaticPage
  layout :layout_for_page

  private

  def layout_for_page
    case params[:id]
    when '500'
      'standalone'
    when '404'
      'standalone'
    when '503'
      'standalone'
    else
      'application'
    end
  end
end
