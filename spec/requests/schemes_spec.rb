require 'rails_helper'

RSpec.describe 'Schemes', type: :request do
  describe 'GET /schemes' do
    xit 'works! (now write some real specs)' do
      get schemes_path
      expect(response).to have_http_status(200)
    end

    context 'when not signed in' do
      it 'redirects with 302' do
        get schemes_path
        expect(response).to have_http_status(302)
      end
    end
  end
end
