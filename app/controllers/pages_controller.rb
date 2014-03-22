class PagesController < ApplicationController
  include HighVoltage::StaticPage
  layout :layout_for_page

  private

  def layout_for_page
    if %w[500 404 503].include?(params[:id])
      'standalone'
    else
      'application'
    end
  end
end
