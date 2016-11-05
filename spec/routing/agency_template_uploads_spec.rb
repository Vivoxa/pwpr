require 'rails_helper'

RSpec.describe AgencyTemplateUploadsController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get('/schemes/1/agency_template_uploads')).to route_to('agency_template_uploads#index', scheme_id: '1')
    end

    it 'routes to #show' do
      expect(get('/schemes/1/agency_template_uploads/1')).to route_to('agency_template_uploads#show', scheme_id: '1', id: '1')
    end

    it 'routes to #new' do
      expect(get('/schemes/1/agency_template_uploads/new')).to route_to('agency_template_uploads#new', scheme_id: '1')
    end
  end
end
