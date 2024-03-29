require 'rails_helper'

RSpec.describe SchemeOperatorsController, type: :controller do
  context 'when SchemeOperator has sc_director role' do
    let(:sc_marti) { SchemeOperator.new }
    before do
      sc_marti.email = 'jennifer@back_to_the_future.com'
      sc_marti.first_name = 'Jennifer'
      sc_marti.last_name = 'Smith'
      sc_marti.password = 'mypassword'
      sc_marti.confirmed_at = DateTime.now
      sc_marti.schemes = [Scheme.create(name: 'test scheme', active: true, scheme_country_code_id: 1)]
      sc_marti.add_role :sc_director
      sc_marti.add_role :sc_users_r
      sc_marti.approved = true
      sc_marti.save
      sign_in sc_marti
    end

    after do
      sc_marti.remove_role :sc_users_r
      sc_marti.remove_role :sc_director
      sign_out sc_marti
    end

    context 'when an invitation has not been accepted' do
      it 'expects a scheme operator' do
        scheme_operator = SchemeOperator.create(first_name: 'rspec owner',
                                                last_name: 'last',
                                                approved: true,
                                                email: 'invited@pwpr.com',
                                                password: 'my_password',
                                                schemes: sc_marti.schemes,
                                                invitation_sent_at: DateTime.now)
        get 'invited_not_accepted'
        object = assigns(:scheme_operators).where(id: scheme_operator.id).first
        expect(object).to be_a SchemeOperator
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
      sc_marti.first_name = 'Jennifer'
      sc_marti.last_name = 'Smith'
      sc_marti.password = 'mypassword'
      sc_marti.confirmed_at = DateTime.now
      sc_marti.schemes = [Scheme.create(name: 'test scheme', active: true, scheme_country_code_id: 1)]
      sc_marti.save
      sc_marti.approved = true
      sc_marti.save
    end

    after do
      sign_out sc_marti
    end

    describe '#approve' do
      before do
        sc_marti.add_role :sc_director
        PermissionsForRole::SchemeOperatorDefinitions.new.permissions_for_role(:sc_director).each do |permission, has|
          sc_marti.add_role permission if has[:checked]
        end
        sign_in sc_marti
      end

      after do
        sign_out sc_marti
      end
      let(:scheme_operator) do
        SchemeOperator.create(first_name: 'rspec owner',
                              last_name: 'last',
                              email: 'invited@pwpr.com',
                              password: 'my_password',
                              scheme_ids: [sc_marti.schemes.first.id],
                              invitation_sent_at: DateTime.now - 5.days,
                              invitation_accepted_at: DateTime.now,
                              confirmation_sent_at: DateTime.now - 5.days,
                              confirmed_at: DateTime.now,
                              approved: false)
      end
      it 'expects the scheme operator to be approved' do
        get :approve, scheme_operator_id: scheme_operator.id
        expect(response.status).to eq 302
        expect(flash['notice']).to eq('SchemeOperator was successfully approved.')
        scheme_operator.reload
        expect(scheme_operator.approved).to eq true
      end
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
      let!(:scheme_operator) do
        SchemeOperator.create!(first_name: 'rspec owner',
                              last_name: 'last',
                              email: 'invited@pwpr.com',
                              password: 'my_password',
                              scheme_ids: [sc_marti.schemes.first.id],
                              invitation_sent_at: DateTime.now - 5.days,
                              invitation_accepted_at: DateTime.now,
                              confirmation_sent_at: DateTime.now - 5.days,
                              confirmed_at: DateTime.now,
                              approved: false)
      end

      before do
        sign_out sc_marti
        sc_marti.sc_director!
        sc_marti.remove_role :sc_user

        PermissionsForRole::SchemeOperatorDefinitions.new.permissions_for_role(:sc_director).each do |permission, has|
          sc_marti.add_role permission if has[:checked]
        end
        sc_marti.save
        sign_in sc_marti
      end

      after do
        sign_out sc_marti
      end

      context 'when an invitation HAS been accepted but not approved' do
        it 'expects a scheme operator' do
          get :pending
          object = assigns(:scheme_operators).where(id: scheme_operator.id).first
          expect(object).to be_a SchemeOperator
        end
      end

      context 'when calling update_permissions' do
        context 'when trying to update own permissions' do
          it 'expects the permissions to be updated' do
            put :update_permissions, scheme_operator_id: scheme_operator.id
            expect(flash[:notice]).to eq 'Permissions updated successfully!'
            expect(response.status).to eq 302
          end
        end
        context 'when trying to update own permissions' do
          it 'expects the permissions NOT to be updated' do
            expect(put(:update_permissions, scheme_operator_id: sc_marti.id)).to redirect_to 'http://test.host/'
            expect(flash[:alert]).to eq 'You are not authorized to access this page.'
            expect(response.status).to eq 302
          end
        end
      end

      describe '#index' do
        it 'expects the sc_director to have access to the index action' do
          get 'index'
          expect(response.status).to eq 200
        end

        it 'sets @scheme_operators to correct value' do
          get 'index'
          assigns(:schemes).each do |_s, h|
            expect(h[:users]).not_to include(sc_marti)
          end
        end
      end

      it 'expects the sc_director NOT to have access to the show page' do
        expect(get(:show, id: sc_marti.id)).to redirect_to 'http://test.host/'
        expect(response.status).to eq 302
      end

      context 'when calling update' do
        it 'expects the scheme operator to be updated' do
          get :update, id: scheme_operator.id, scheme_operator: {first_name: 'nigel_first'}
          expect(response.status).to eq 302
          scheme_operator.reload
          expect(scheme_operator.first_name).to eq 'nigel_first'
        end
      end

      it 'expects the sc_director to have access to the show page' do
        get :show, id: scheme_operator.id
        expect(response.status).to eq 200
      end

      context 'when calling destroy' do
        it 'expects the scheme operator to be destroyed' do
          get :destroy, id: scheme_operator
          expect(response.status).to eq 302

          sc = SchemeOperator.where(id: scheme_operator.id)
          expect(sc).to be_empty
        end
      end

      context 'when calling permissions' do
        it 'expects the sc_director to have access to the permissions action' do
          get :permissions, scheme_operator_id: scheme_operator
          expect(response.status).to eq 200
        end

        it 'sets the correct user instance' do
          get :permissions, scheme_operator_id: scheme_operator.id
          expect(assigns(:user)).to eq(SchemeOperator.last)
        end

        it 'sets the correct available_roles' do
          get :permissions, scheme_operator_id: scheme_operator.id
          expect(assigns(:available_roles)).to eq(PermissionsForRole::SchemeOperatorDefinitions::ROLES)
        end

        it 'sets the correct available_permissions' do
          get :permissions, scheme_operator_id: scheme_operator.id
          expect(assigns(:available_permissions)).to eq(PermissionsForRole::SchemeOperatorDefinitions::PERMISSIONS)
        end

        it 'sets the correct permissions_definitions' do
          get :permissions, scheme_operator_id: scheme_operator.id
          expect(assigns(:permissions_definitions)).to be_a(PermissionsForRole::SchemeOperatorDefinitions)
        end

        it 'sets the allowed_permissions' do
          get :permissions, scheme_operator_id: scheme_operator.id
          expect(assigns(:allowed_permissions)).not_to be_nil
        end
      end

      context 'when calling update_permissions' do
        let(:params) { {scheme_operator_id: scheme_operator.id, role: 'sc_director', permissions: ['sc_user_e']} }

        it 'expects the scheme operator permissions to be updated' do
          put :update_permissions, params
          expect(response.status).to eq 302
        end

        context 'when assigning allowed role/permissions' do
          let(:no_role) { scheme_operator }
          let(:definitions) do
            {
                schemes_r: {checked: false, locked: true},
                schemes_w: {checked: false, locked: true},
                schemes_e: {checked: false, locked: true},
                schemes_d: {checked: false, locked: true},

                sc_users_r: {checked: false, locked: true},
                sc_users_w: {checked: false, locked: true},
                sc_users_e: {checked: false, locked: true},
                sc_users_d: {checked: false, locked: true},

                co_users_r: {checked: true, locked: true},
                co_users_w: {checked: false, locked: false},
                co_users_e: {checked: false, locked: false},
                co_users_d: {checked: false, locked: false},

                businesses_r: {checked: true, locked: true},
                businesses_e: {checked: false, locked: false},
                businesses_w: {checked: false, locked: true},
                businesses_d: {checked: false, locked: true}
            }
          end

          before do
            controller.instance_variable_set(:@available_roles, PermissionsForRole::SchemeOperatorDefinitions::ROLES)
            controller.instance_variable_set(:@available_permissions, PermissionsForRole::SchemeOperatorDefinitions::PERMISSIONS)
            controller.instance_variable_set(:@permissions_definitions, PermissionsForRole::SchemeOperatorDefinitions.new)
            allow_any_instance_of(PermissionsForRole::SchemeOperatorDefinitions).to receive(:permissions_for_role).and_return(definitions)

            no_role.role_list.each { |r| no_role.remove_role r }
            no_role.add_role :sc_director
            no_role.add_role :sc_users_e
            no_role.add_role :sc_users_w
          end

          describe 'all permissions are allowed' do
            let(:params) { {scheme_operator_id: no_role.id, role: 'sc_user', permissions: %w(co_users_r businesses_e businesses_r)} }

            it 'sets all the passed in permissions' do
              put :update_permissions, params
              expect(no_role.role_list).to eq %w(sc_user businesses_e co_users_r businesses_r)
            end
          end

          describe 'no permissions selected' do
            let(:params) { {scheme_operator_id: no_role.id, role: 'sc_user', permissions: %w()} }

            it 'sets mandatory permissions' do
              put :update_permissions, params
              expect(no_role.role_list).to eq %w(sc_user co_users_r businesses_r)
            end
          end

          describe 'NOT all permissions are allowed' do
            let(:params) { {scheme_operator_id: no_role.id, role: 'sc_user', permissions: %w(co_users_r businesses_e businesses_d businesses_r)} }

            it 'sets ONLY the correct permissions' do
              get :permissions, scheme_operator_id: no_role.id
              put :update_permissions, params
              expect(no_role.role_list).to eq %w(sc_user businesses_e co_users_r businesses_r)
            end
          end

          it 'redirects to correct page after save' do
            put :update_permissions, params
            expect(response.body).to include('scheme_operators/')
          end
        end
      end
    end
  end
end
