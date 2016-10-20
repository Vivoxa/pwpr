require 'rails_helper'

RSpec.describe SchemeOperatorsController, type: :controller do
  context 'when scheme operator is NOT signed in' do
    context 'when calling index' do
      it 'expects to be redirected to sign in' do
        get :index
        expect(response.status).to eq 302
        expect(response.body).to include('scheme_operators/sign_in')
      end
    end

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

    context 'when calling destroy' do
      it 'expects to be redirected to sign in' do
        get :destroy, id: SchemeOperator.last.id
        expect(response.status).to eq 302
        expect(response.body).to include('scheme_operators/sign_in')
      end
    end

    context 'when calling permissions' do
      it 'expects to be redirected to sign in' do
        get :permissions, scheme_operator_id: SchemeOperator.last.id
        expect(response.status).to eq 302
        expect(response.body).to include('scheme_operators/sign_in')
      end
    end

    context 'when calling update_permissions' do
      it 'expects to be redirected to sign in' do
        put :update_permissions, scheme_operator_id: SchemeOperator.last.id
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

      context 'when calling destroy' do
        it 'expects a CanCan AccessDenied error to be raised' do
          put :update, id: co_marti.id
          expect(flash[:alert]).to be_present
          expect(flash[:alert]).to eq 'You are not authorized to access this page.'
        end
      end

      context 'when calling permissions' do
        it 'expects a CanCan AccessDenied error to be raised' do
          get :permissions, scheme_operator_id: SchemeOperator.last.id
          expect(flash[:alert]).to be_present
          expect(flash[:alert]).to eq 'You are not authorized to access this page.'
        end
      end

      context 'when calling update_permissions' do
        it 'expects a CanCan AccessDenied error to be raised' do
          put :update_permissions, scheme_operator_id: SchemeOperator.last.id
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

      it 'expects the sc_director to have access to the index action' do
        get 'index'
        expect(response.status).to eq 200
      end

      it 'expects the sc_director to have access to the show action' do
        get :show, id: co_marti.id
        expect(response.status).to eq 200
      end

      context 'when calling update' do
        it 'expects the scheme operator to be updated' do
          get :update, id: co_marti.id, scheme_operator: {id: co_marti.id}
          expect(response.status).to eq 200
        end
      end

      context 'when calling destroy' do
        it 'expects the company operator to be destroyed' do
          get :destroy, id: co_marti.id
          expect(response.status).to eq 200
        end
      end

      context 'when calling permissions' do
        it 'expects the sc_director to have access to the permissions action' do
          get :permissions, scheme_operator_id: SchemeOperator.last.id
          expect(response.status).to eq 200
        end

        it 'sets the correct user instance' do
          get :permissions, scheme_operator_id: SchemeOperator.last.id
          expect(assigns(:user)).to eq(SchemeOperator.last)
        end

        it 'sets the correct available_roles' do
          get :permissions, scheme_operator_id: SchemeOperator.last.id
          expect(assigns(:available_roles)).to eq(SchemeOperator::ROLES)
        end

        it 'sets the correct available_permissions' do
          get :permissions, scheme_operator_id: SchemeOperator.last.id
          expect(assigns(:available_permissions)).to eq(SchemeOperator::PERMISSIONS)
        end
      end

      context 'when calling update_permissions' do
        let(:params) { {scheme_operator_id: SchemeOperator.last.id, role: 'sc_director', permissions: ['sc_user_rwe']} }

        it 'expects the scheme operator permissions to be updated' do
          put :update_permissions, params
          expect(response.status).to eq 302
        end
      end
    end
  end
end
