require 'rails_helper'

RSpec.describe 'SchemeOperatorsSchemes', type: :request do
  describe 'GET /scheme_operators_schemes' do
    it 'works! (now write some real specs)' do
      get scheme_scheme_operators_schemes_path(scheme_id: 1)
      expect(response).to have_http_status(200)
    end
  end
end
