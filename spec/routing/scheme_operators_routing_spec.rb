require 'rails_helper'

RSpec.describe SchemeOperatorsController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get('/scheme_operators')).to route_to('scheme_operators#index')
    end

    it 'routes to #new' do
      expect(get('/scheme_operators/new')).to route_to('scheme_operators#new')
    end

    it 'routes to #show' do
      expect(get('/scheme_operators/1')).to route_to('scheme_operators#show', id: '1')
    end

    it 'routes to #edit' do
      expect(get('/scheme_operators/1/edit')).to route_to('scheme_operators#edit', id: '1')
    end

    it 'routes to #update via PUT' do
      expect(put('/scheme_operators/1')).to route_to('scheme_operators#update', id: '1')
    end

    it 'routes to #update via PATCH' do
      expect(patch('/scheme_operators/1')).to route_to('scheme_operators#update', id: '1')
    end

    it 'routes to #destroy' do
      expect(delete('/scheme_operators/1')).to route_to('scheme_operators#destroy', id: '1')
    end

    it 'routes to #permissions via GET' do
      expect(get('/scheme_operators/1/permissions')).to route_to('scheme_operators#permissions', scheme_operator_id: '1')
    end

    it 'routes to #update_permissions via PUT' do
      expect(put('/scheme_operators/1/update_permissions')).to route_to('scheme_operators#update_permissions', scheme_operator_id: '1')
    end
  end
end
