require 'rails_helper'

RSpec.describe Api::V1::BusinessesController, type: :controller do
  let(:business) { Business.first }

  context 'when authorised' do
    # login to http basic auth
    include AuthHelper
    before do
      allow(ENV).to receive(:fetch).with('API_KEY').and_return('api_key')
      http_login
    end

    describe '#show' do
      context 'when the business exists' do
        it 'expects a json serialised business' do
          get :show, id: business.id
          expect(response.status).to eq 200
          expect(response.body).to eq business.to_json
        end
      end

      context 'when the business DOES NOT exist' do
        it 'expects a json serialised business' do
          get :show, id: 100_000_585
          expect(response.status).to eq 404
          expect(response.body).to eq ''
        end
      end
    end
  end
  context 'when not authorised' do
    describe '#show' do
      context 'when the business exists' do
        it 'expects a json serialised business' do
          get :show, id: business.id
          expect(response.status).to eq 401
        end
      end

      context 'when the business DOES NOT exist' do
        it 'expects a json serialised business' do
          get :show, id: 100_000_585
          expect(response.status).to eq 401
        end
      end
    end
  end
end
