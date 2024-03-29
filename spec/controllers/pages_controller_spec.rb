require 'spec_helper'

describe PagesController, '#show' do
  render_views
  %w(en fr).each do |lang|
    %w(pricing features about terms privacy legal 500 503 404 ).each do |page|
      context 'on GET to /pages/#{page}' do
        before do
          get :show, id: page, locale: lang
        end

        it { should respond_with(:success) }
        it { should render_template("#{page}-#{lang}") }
      end
    end
  end
end
