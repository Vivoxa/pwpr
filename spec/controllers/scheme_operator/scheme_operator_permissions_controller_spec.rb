require 'rails_helper'

RSpec.describe SchemeOperatorPermissionsController, type: :controller do
  context 'when scheme operator is NOT signed in' do
    context 'when calling show' do
      it 'expects to be redirected to sign in' do
        get :show, id: SchemeOperator.last.id
        expect(response.status).to eq 302
        expect(response.body).to include('scheme_operators/sign_in')
      end
    end

    context 'when calling update' do
      it 'expects to be redirected to sign in' do
        put :update, id: SchemeOperator.last.id
        expect(response.status).to eq 302
        expect(response.body).to include('scheme_operators/sign_in')
      end
    end
  end

  context 'when scheme operator is signed in' do
    let(:co_marti) { SchemeOperator.new }

    before do
      co_marti.email = 'jennifer@back_to_the_future.com'
      co_marti.name = 'Jennifer'
      co_marti.password = 'mypassword'
      co_marti.confirmed_at = DateTime.now
      co_marti.schemes = [Scheme.create(name: 'test scheme', active: true)]
      co_marti.save
    end

    context 'when SchemeOperator does NOT have the director role' do
      before do
        sign_in co_marti
      end

      context 'when calling show' do
        it 'expects a CanCan AccessDenied error to be raised' do
          get :show, id: co_marti.id
          expect(flash[:alert]).to be_present
          expect(flash[:alert]).to eq 'You are not authorized to access this page.'
        end
      end

      context 'when calling update' do
        it 'expects a CanCan AccessDenied error to be raised' do
          put :update, id: co_marti.id
          expect(flash[:alert]).to be_present
          expect(flash[:alert]).to eq 'You are not authorized to access this page.'
        end
      end
    end

    context 'when SchemeOperator has sc_director role' do
      before do
        sign_out co_marti
        co_marti.add_role('sc_director')
        co_marti.save
        sign_in co_marti
      end

      it 'expects the admin to have access to the show action' do
        get :show, id: co_marti.id
        expect(response.status).to eq 200
      end

      context 'when calling update' do
        it 'expects the company operator to be updated' do
          get :update, id: co_marti.id, scheme_operator: {id: co_marti.id}
          expect(response.status).to eq 200
        end
      end
    end
  end
end
