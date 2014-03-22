class SitesController < ApplicationController
  def new
    @site = Site.new
  end

  def create
    @site = Site.new site_params
    if @site.save
      @site.delay.create_site
      redirect_to site_path(id: @site)
    else
      site = Site.where('name=? and email=?', site_params[:name], site_params[:email]).first
      return redirect_to site_path(id: site) if site
      render :new
    end
  end

  def show
    @site = Site.where("id = ? OR name = ?", params[:id].to_i, params[:id]).first
    respond_to do |format|
      format.html
      format.json { render json: @site.as_json(only: [:name]) }
    end
  end

  private
    def site_params
      params.require(:site).permit(:name, :email)
    end
end
