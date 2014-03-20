require 'spec_helper'

describe SitesController do
  render_views

  let(:site) { create :site }

  describe 'GET #new' do
    before :each do
      get :new
    end
    it_responds_200

    it 'assigns @site' do
      expect(assigns(:site).class).to eq Site
    end
  end

  describe 'GET #show' do
    before :each do
      get :show, id: site
    end
    it_responds_200

    it 'assigns @site' do
      expect(assigns(:site)).to eq site
    end
  end

  describe 'POST #create' do
    it 'render new with wrond email' do
      post :create, {
        site: {
          name: 'studiocuicui',
          email: 'luc@boissaye'
        }
      }
      expect(response).to render_template(:new)
    end

    it 'redirect to show' do
      post :create, {
        site: {
          name: 'studiocuicui',
          email: 'luc@boissaye.fr'
        }
      }
      expect(response).to redirect_to site_path(Site.first)
    end
  end

end
