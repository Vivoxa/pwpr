require 'rails_helper'

RSpec.describe SchemeOperatorInvitationsController, type: :controller do
  context 'when scheme operator is NOT signed in' do
    context 'when calling index' do
      it 'expects to be redirected to sign in' do
        get :index
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
      context 'when calling index' do
        it 'expects a CanCan AccessDenied error to be raised' do
          get :index
          expect(flash[:alert]).to be_present
          expect(flash[:alert]).to eq 'You are not authorized to access this page.'
        end
      end
    end

    context 'when SchemeOperator has co_director role' do
      before do
        sign_out co_marti
        co_marti.add_role('sc_director')
        co_marti.save
        sign_in co_marti
      end

      context 'when an invitation is pending' do
        it 'expects a collection of scheme operators' do
          scheme_operator = SchemeOperator.create(email: 'invited@pwpr.com', password: 'my_password', schemes: co_marti.schemes, invitation_sent_at: DateTime.now)
          get 'index'
          object = assigns(:scheme_operator_invitations).first
          expect(object).to be_a SchemeOperator
          expect(object.id).to eq scheme_operator.id
        end
      end

      it 'expects the admin to have access to the index action' do
        get 'index'
        expect(response.status).to eq 200
      end
    end
  end
end