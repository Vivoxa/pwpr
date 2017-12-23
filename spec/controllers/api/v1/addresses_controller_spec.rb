require 'rails_helper'

RSpec.describe Api::V1::AddressesController, type: :controller do
  let(:address) { Address.first }

  context 'when authorised' do
    # login to http basic auth
    include AuthHelper
    before do
      http_login
    end

    describe '#show' do
      context 'when the address exists' do
        it 'expects a json serialised address' do
          get :show, id: address.id
          expect(response.status).to eq 200
          expect(response.body).to eq address.to_json
        end
      end

      context 'when the address DOES NOT exist' do
        it 'expects a json serialised address' do
          get :show, id: 100_000_585
          expect(response.status).to eq 404
          expect(response.body).to eq ''
        end
      end
    end
  end

  context 'when not authorised' do
    describe '#show' do
      context 'when the address exists' do
        it 'expects a json serialised address' do
          get :show, id: address.id
          expect(response.status).to eq 401
        end
      end

      context 'when the address DOES NOT exist' do
        it 'expects a json serialised address' do
          get :show, id: 100_000_585
          expect(response.status).to eq 401
        end
      end
    end
  end
end
