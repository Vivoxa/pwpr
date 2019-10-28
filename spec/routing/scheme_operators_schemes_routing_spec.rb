require 'rails_helper'

RSpec.describe SchemeOperatorsSchemesController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/schemes/1/scheme_operators_schemes').to route_to('scheme_operators_schemes#index', scheme_id: '1')
    end

    it 'routes to #new' do
      expect(get: '/schemes/1/scheme_operators_schemes/new').to route_to('scheme_operators_schemes#new', scheme_id: '1')
    end

    it 'routes to #create' do
      expect(post: '/schemes/1/scheme_operators_schemes').to route_to('scheme_operators_schemes#create', scheme_id: '1')
    end

    it 'routes to #destroy' do
      expect(delete: '/schemes/1/scheme_operators_schemes/1').to route_to('scheme_operators_schemes#destroy', scheme_id: '1', id: '1')
    end
  end
end
