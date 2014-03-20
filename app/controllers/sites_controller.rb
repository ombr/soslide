class SitesController < ApplicationController
  def new
    @site = Site.new
  end

  def create
    @site = Site.new site_params
    if @site.save
      redirect_to site_path(id: @site)
    else
      render :new
    end
  end

  def show
    @site = Site.find(params[:id])
  end

  private
    def site_params
      params.require(:site).permit(:name, :email)
    end
end
