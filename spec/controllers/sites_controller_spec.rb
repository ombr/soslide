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
    context 'with an id' do
      before :each do
        get :show, id: site
      end
      it_responds_200

      it 'assigns @site' do
        expect(assigns(:site)).to eq site
      end
    end

    context 'with a name in json' do
      it 'it returns app information' do
        get :show, {
          id: site.name,
          format: :json
        }
        expect(JSON.parse(response.body)['name']).to eq site.name
        expect(JSON.parse(response.body)['email']).to be_nil
      end
    end
  end

  describe 'POST #create' do
    context 'when success' do
      before :each do
        Site.any_instance.should_receive(:create_site).and_return(true)
      end

      it 'redirect to show' do
        post :create, {
          site: {
            name: 'studiocuicui',
            email: 'luc@boissaye.fr'
          }
        }
        expect(response).to redirect_to site_path(id: Site.first)
      end
    end
    it 'render new with wrong email' do
      post :create, {
        site: {
          name: 'studiocuicui',
          email: 'luc@boissaye'
        }
      }
      expect(response).to render_template(:new)
    end

    it 'redirects to show if we are using the same email' do
      post :create, {
        site: {
          name: site.name,
          email: site.email
        }
      }
      expect(response).to redirect_to site_path(id: site)
    end
  end

end
