# SitesController
class SitesController < ApplicationController
  before_filter :authenticate, only: :index

  def new
    @site = Site.new
  end

  def create
    @site = Site.new site_params
    if @site.save
      @site.delay.create_site
      redirect_to site_path(id: @site)
    else
      site = exact_site
      return redirect_to site_path(id: site) if site
      render :new
    end
  end

  def show
    @site = matching_site
    respond_to do |format|
      format.html
      format.json { render json: @site.as_json(only: [:name]) }
    end
  end

  def index
    # @sites = Site.order('images DESC').where('images = 0 AND pages = 0')
    @sites = Site.order('images DESC')
  end

  def login
    @site = Site.new
  end

  def search
    @sites = Site.where('email = ?', params[:site][:email])
    redirect_to @sites.first.admin_url if @sites.count == 1
  end

  private

  def site_params
    params.require(:site).permit(:name, :email)
  end

  def authenticate
    authenticate_or_request_with_http_basic do |username, password|
      username == ENV['AUTH_USER'] && password == ENV['AUTH_PASSWORD']
    end
  end

  def exact_site
    Site.where('name=? and email=?',
               site_params[:name],
               site_params[:email]).first
  end

  def matching_site
    Site.where('id = ? OR name = ?', params[:id].to_i, params[:id]).first
  end
end
