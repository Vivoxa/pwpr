require 'rails_helper'

RSpec.describe EmailNamesController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/email_names').to route_to('email_names#index')
    end

    it 'routes to #new' do
      expect(get: '/email_names/new').to route_to('email_names#new')
    end

    it 'routes to #show' do
      expect(get: '/email_names/1').to route_to('email_names#show', id: '1')
    end

    it 'routes to #edit' do
      expect(get: '/email_names/1/edit').to route_to('email_names#edit', id: '1')
    end

    it 'routes to #create' do
      expect(post: '/email_names').to route_to('email_names#create')
    end

    it 'routes to #update via PUT' do
      expect(put: '/email_names/1').to route_to('email_names#update', id: '1')
    end

    it 'routes to #update via PATCH' do
      expect(patch: '/email_names/1').to route_to('email_names#update', id: '1')
    end

    it 'routes to #destroy' do
      expect(delete: '/email_names/1').to route_to('email_names#destroy', id: '1')
    end
  end
end
