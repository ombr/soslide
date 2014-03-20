def it_responds_200
  context 'renders views' do
    render_views
    it { expect(response.code).to eq '200' }
  end
end
