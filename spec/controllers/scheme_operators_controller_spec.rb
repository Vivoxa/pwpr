require 'rails_helper'

RSpec.describe SchemeOperatorsController, type: :controller do
  context 'when SchemeOperator has co_director role' do
    let(:sc_marti) { SchemeOperator.new }
    before do
      sc_marti.email = 'jennifer@back_to_the_future.com'
      sc_marti.name = 'Jennifer'
      sc_marti.password = 'mypassword'
      sc_marti.confirmed_at = DateTime.now
      sc_marti.schemes = [Scheme.create(name: 'test scheme', active: true)]
      sc_marti.add_role :sc_director
      sc_marti.add_role :sc_users_r
      sc_marti.save
      sign_in sc_marti
    end

    after do
      sc_marti.remove_role :sc_users_r
      sc_marti.remove_role :sc_director
      sign_out sc_marti
    end

    context 'when an invitation has not been accepted' do
      it 'expects a collection of scheme operators' do
        scheme_operator = SchemeOperator.create(email: 'invited@pwpr.com', password: 'my_password', schemes: sc_marti.schemes, invitation_sent_at: DateTime.now)
        get 'invited_not_accepted'
        object = assigns(:scheme_operators).first
        expect(object).to be_a SchemeOperator
        expect(object.id).to eq scheme_operator.id
      end
    end

    it 'expects the admin to have access to the index action' do
      get 'index'
      expect(response.status).to eq 200
    end
  end

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
    let(:sc_marti) { SchemeOperator.new }
    before do
      sc_marti.email = 'jennifer@back_to_the_future.com'
      sc_marti.name = 'Jennifer'
      sc_marti.password = 'mypassword'
      sc_marti.confirmed_at = DateTime.now
      sc_marti.schemes = [Scheme.create(name: 'test scheme', active: true)]
      sc_marti.save
      sc_marti.save
    end

    after do
      sign_out sc_marti
    end

    context 'when SchemeOperator does NOT have a role' do
      before do
        sc_marti.roles.each do |role|
          sc_marti.remove_role role
        end
        sign_in sc_marti
      end

      after do
        sign_out sc_marti
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
          get :show, id: sc_marti.id
          expect(flash[:alert]).to be_present
          expect(flash[:alert]).to eq 'You are not authorized to access this page.'
        end
      end

      context 'when calling update' do
        it 'expects a CanCan AccessDenied error to be raised' do
          put :update, id: sc_marti.id
          expect(flash[:alert]).to be_present
          expect(flash[:alert]).to eq 'You are not authorized to access this page.'
        end
      end

      context 'when calling destroy' do
        it 'expects a CanCan AccessDenied error to be raised' do
          put :update, id: sc_marti.id
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
        sign_out sc_marti
        sc_marti.add_role :sc_director
        sc_marti.add_role :sc_users_r
        sc_marti.add_role :sc_users_w
        sc_marti.add_role :sc_users_e
        sc_marti.add_role :sc_users_d
        sc_marti.save
        sign_in sc_marti
      end

      after do
        sign_out sc_marti
      end

      context 'when calling update_permissions' do
        it 'expects a CanCan AccessDenied error to be raised' do
          put :update_permissions, scheme_operator_id: SchemeOperator.last.id
          expect(flash[:notice]).to eq 'Permissions updated successfully!'
          expect(response.status).to eq 302
        end
      end

      it 'expects the sc_director to have access to the index action' do
        get 'index'
        expect(response.status).to eq 200
      end

      it 'expects the sc_director to have access to the show action' do
        get :show, id: sc_marti.id
        expect(response.status).to eq 200
      end

      context 'when calling update' do
        it 'expects the scheme operator to be updated' do
          get :update, id: sc_marti.id, scheme_operator: {id: sc_marti.id}
          expect(response.status).to eq 302
        end
      end

      context 'when calling destroy' do
        it 'expects the scheme operator to be destroyed' do
          get :destroy, id: sc_marti.id
          expect(response.status).to eq 302
          co = SchemeOperator.where(id: sc_marti.id)
          expect(co).to be_empty
        end
      end

      context 'when calling permissions' do
        it 'expects the sc_director to have access to the permissions action' do
          get :permissions, scheme_operator_id: sc_marti.id
          expect(response.status).to eq 200
        end

        it 'sets the correct user instance' do
          get :permissions, scheme_operator_id: sc_marti.id
          expect(assigns(:user)).to eq(SchemeOperator.last)
        end

        it 'sets the correct available_roles' do
          get :permissions, scheme_operator_id: sc_marti.id
          expect(assigns(:available_roles)).to eq(PermissionsForRole::SchemeOperatorDefinitions::ROLES)
        end

        it 'sets the correct available_permissions' do
          get :permissions, scheme_operator_id: sc_marti.id
          expect(assigns(:available_permissions)).to eq(PermissionsForRole::SchemeOperatorDefinitions::PERMISSIONS)
        end

        it 'sets the correct permissions_definitions' do
          get :permissions, scheme_operator_id: SchemeOperator.last.id
          expect(assigns(:permissions_definitions)).to be_a(PermissionsForRole::SchemeOperatorDefinitions)
        end

        it 'sets the allowed_permissions' do
          get :permissions, scheme_operator_id: SchemeOperator.last.id
          expect(assigns(:allowed_permissions)).not_to be_nil
        end
      end

      context 'when calling update_permissions' do
        let(:params) { {scheme_operator_id: sc_marti.id, role: 'sc_director', permissions: ['sc_user_e']} }

        it 'expects the scheme operator permissions to be updated' do
          put :update_permissions, params
          expect(response.status).to eq 302
        end
      end
    end
  end
end
