require 'rails_helper'

RSpec.describe CompanyOperatorsController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get('/company_operators')).to route_to('company_operators#index')
    end

    it 'routes to #new' do
      expect(get('/company_operators/new')).to route_to('company_operators#new')
    end

    it 'routes to #show' do
      expect(get('/company_operators/1')).to route_to('company_operators#show', id: '1')
    end

    it 'routes to #edit' do
      expect(get('/company_operators/1/edit')).to route_to('company_operators#edit', id: '1')
    end

    it 'routes to #update via PUT' do
      expect(put('/company_operators/1')).to route_to('company_operators#update', id: '1')
    end

    it 'routes to #update via PATCH' do
      expect(patch('/company_operators/1')).to route_to('company_operators#update', id: '1')
    end

    it 'routes to #destroy' do
      expect(delete('/company_operators/1')).to route_to('company_operators#destroy', id: '1')
    end

    it 'routes to #permissions via GET' do
      expect(get('/company_operators/1/permissions')).to route_to('company_operators#permissions', company_operator_id: '1')
    end

    it 'routes to #update_permissions via PUT' do
      expect(put('/company_operators/1/update_permissions')).to route_to('company_operators#update_permissions', company_operator_id: '1')
    end
  end
end
