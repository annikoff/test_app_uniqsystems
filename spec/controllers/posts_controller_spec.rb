require 'rails_helper'

RSpec.feature PostsController, :type => :controller do
  describe 'GET' do
    render_views
    let!(:category) { create(:category) }
    let!(:post) { create(:post, category: category) }

    it 'renders the index template' do
      get :index
      expect(response).to render_template('index')
    end

    it 'renders the show template' do
      get :show, params: { id: post.id }
      expect(response).to render_template('show')
    end
  end
end
