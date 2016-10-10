
require 'rails_helper'

RSpec.describe SchemesController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get('/schemes')).to route_to('schemes#index')
    end

    it 'routes to #new' do
      expect(get('/schemes/new')).to route_to('schemes#new')
    end

    it 'routes to #show' do
      expect(get('/schemes/1')).to route_to('schemes#show', id: '1')
    end

    it 'routes to #edit' do
      expect(get('/schemes/1/edit')).to route_to('schemes#edit', id: '1')
    end

    it 'routes to #create' do
      expect(post('/schemes')).to route_to('schemes#create')
    end

    it 'routes to #update via PUT' do
      expect(put('/schemes/1')).to route_to('schemes#update', id: '1')
    end

    it 'routes to #update via PATCH' do
      expect(patch('/schemes/1')).to route_to('schemes#update', id: '1')
    end

    it 'routes to #destroy' do
      expect(delete('/schemes/1')).to route_to('schemes#destroy', id: '1')
    end
  end
end
