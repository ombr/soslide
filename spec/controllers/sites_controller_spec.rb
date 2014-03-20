require 'spec_helper'

describe SitesController do
  render_views
  describe 'GET #new' do
    before :each do
      get :new
    end
    it_responds_200
  end

end
