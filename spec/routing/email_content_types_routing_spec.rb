require 'rails_helper'

RSpec.describe EmailContentTypesController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/email_content_types').to route_to('email_content_types#index')
    end

    it 'routes to #new' do
      expect(get: '/email_content_types/new').to route_to('email_content_types#new')
    end

    it 'routes to #show' do
      expect(get: '/email_content_types/1').to route_to('email_content_types#show', id: '1')
    end

    it 'routes to #edit' do
      expect(get: '/email_content_types/1/edit').to route_to('email_content_types#edit', id: '1')
    end

    it 'routes to #create' do
      expect(post: '/email_content_types').to route_to('email_content_types#create')
    end

    it 'routes to #update via PUT' do
      expect(put: '/email_content_types/1').to route_to('email_content_types#update', id: '1')
    end

    it 'routes to #update via PATCH' do
      expect(patch: '/email_content_types/1').to route_to('email_content_types#update', id: '1')
    end

    it 'routes to #destroy' do
      expect(delete: '/email_content_types/1').to route_to('email_content_types#destroy', id: '1')
    end
  end
end
