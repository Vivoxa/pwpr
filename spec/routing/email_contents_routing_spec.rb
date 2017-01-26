require 'rails_helper'

RSpec.describe EmailContentsController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/email_contents').to route_to('email_contents#index')
    end

    it 'routes to #new' do
      expect(get: '/email_contents/new').to route_to('email_contents#new')
    end

    it 'routes to #show' do
      expect(get: '/email_contents/1').to route_to('email_contents#show', id: '1')
    end

    it 'routes to #edit' do
      expect(get: '/email_contents/1/edit').to route_to('email_contents#edit', id: '1')
    end

    it 'routes to #create' do
      expect(post: '/email_contents').to route_to('email_contents#create')
    end

    it 'routes to #update via PUT' do
      expect(put: '/email_contents/1').to route_to('email_contents#update', id: '1')
    end

    it 'routes to #update via PATCH' do
      expect(patch: '/email_contents/1').to route_to('email_contents#update', id: '1')
    end

    it 'routes to #destroy' do
      expect(delete: '/email_contents/1').to route_to('email_contents#destroy', id: '1')
    end
  end
end
