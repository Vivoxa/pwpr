require 'rails_helper'

RSpec.describe AdminsController, type: :controller do
  subject(:admin_controller) { described_class.new }

  context 'when admin operator is NOT signed in' do
    before do
      allow(subject).to receive(:current_user).and_return(Visitor.new)
    end

    context 'when calling index' do
      it_behaves_like 'a NOT signed in user', 'get', :index
    end

    context 'when calling show' do
      it_behaves_like 'a NOT signed in user', 'get', :show, id: Admin.last.id
    end

    context 'when calling permissions' do
      it_behaves_like 'a NOT signed in user', 'get', :permissions, admin_id: Admin.last.id
    end

    context 'when calling update_permissions' do
      it 'expects to be redirected to sign in' do
        put :update_permissions, admin_id: Admin.last.id
        expect(response.status).to eq 302
        expect(response.body).to include('admins/sign_in')
      end
    end
  end

  context 'when admin does NOT have super_admin role' do
    let(:admin_marti) { FactoryGirl.create(:admin) }

    before do
      Admin.available_roles.each do |role|
        admin_marti.remove_role role
      end
      sign_in admin_marti
    end

    after do
      sign_out admin_marti
    end

    context 'viewing the index page' do
      it_behaves_like 'a NOT authorised user', 'get', :index
    end

    context 'when viewing the show page' do
      it_behaves_like 'a NOT authorised user', 'get', :show, id: Admin.last.id
    end

    context 'when calling permissions' do
      it_behaves_like 'a NOT authorised user', 'get', :permissions, admin_id: Admin.last.id
    end

    context 'when calling update_permissions' do
      it_behaves_like 'a NOT authorised user', 'put', :update_permissions, admin_id: Admin.last.id
    end
  end

  context 'when admin has super_admin role' do
    let(:admin_doc) { FactoryGirl.create(:super_admin) }
    before do
      sign_in admin_doc
    end

    after do
      sign_out admin_doc
    end

    describe '#index' do
      it 'expects the admin to have access to the index action' do
        get 'index'
        expect(response.status).to eq 200
      end

      it 'sets @admins to correct value' do
        get 'index'
        expect(assigns(:admins)).to eq(Admin.all - [admin_doc])
      end

      it 'sets @scheme_operators to correct value' do
        get 'index'
        expect(assigns(:scheme_operators)).to eq(SchemeOperator.all)
      end

      it 'sets @company_operators to correct value' do
        get 'index'
        expect(assigns(:company_operators)).to eq(CompanyOperator.all)
      end
    end

    it 'expects the admin to have access to the show action' do
      get :show, id: admin_doc.id
      expect(response.status).to eq 200
    end

    context 'when calling update' do
      it 'expects the admin to be updated' do
        get :update, id: admin_doc.id, admin: {id: admin_doc.id}
        expect(flash[:notice]).to eq('Admin was successfully updated.')
        expect(response.status).to eq 302
      end
    end

    context 'when calling permissions' do
      it 'expects the admin to have access to the permissions action' do
        get :permissions, admin_id: Admin.last.id
        expect(response.status).to eq 200
      end

      it 'sets the correct user instance' do
        get :permissions, admin_id: Admin.last.id
        expect(assigns(:user)).to eq(Admin.last)
      end

      it 'sets the correct available_roles' do
        get :permissions, admin_id: Admin.last.id
        expect(assigns(:available_roles)).to eq(PermissionsForRole::AdminDefinitions::ROLES)
      end

      it 'sets the correct available_permissions' do
        get :permissions, admin_id: Admin.last.id
        expect(assigns(:available_permissions)).to eq(PermissionsForRole::AdminDefinitions::PERMISSIONS)
      end

      it 'sets the correct permissions_definitions' do
        get :permissions, admin_id: Admin.last.id
        expect(assigns(:permissions_definitions)).to be_a(PermissionsForRole::AdminDefinitions)
      end

      it 'sets the allowed_permissions' do
        get :permissions, admin_id: Admin.last.id
        expect(assigns(:allowed_permissions)).not_to be_nil
      end
    end

    context 'when calling update_permissions' do
      let(:params) { {admin_id: Admin.last.id, role: 'full', permissions: []} }

      it 'expects the admin to have access to the update_permissions action' do
        put :update_permissions, params
        expect(response.status).to eq 302
      end

      context 'when an error is raised' do
        let(:params) { {admin_id: Admin.last.id, role: 'full', permissions: []} }

        it 'expects permission changes to be rolled back' do
          allow_any_instance_of(CommonHelpers::PermissionsHelper).to receive(:remove_unselected_permissions!).and_raise(StandardError)
          put :update_permissions, params
          expect(response.status).to eq 302
        end

        it 'expects flash message to be displyed' do
          allow_any_instance_of(CommonHelpers::PermissionsHelper).to receive(:remove_unselected_permissions!).and_raise(StandardError)
          expect_any_instance_of(CommonHelpers::PermissionsHelper).to receive(:roll_back_roles!)
          put :update_permissions, params
          expect(flash[:error]).to eq "An error occured! User #{Admin.last.email}'s permissions were not updated."
        end
      end

      context 'when assinging role/permissions' do
        let(:no_role) { FactoryGirl.create(:no_role) }
        let(:definitions) do
          {
            schemes_r:    {checked: true, locked: true},
            schemes_w:    {checked: false, locked: true},
            schemes_e:    {checked: false, locked: false},
            schemes_d:    {checked: false, locked: true},

            sc_users_r:   {checked: true, locked: true},
            sc_users_w:   {checked: false, locked: false},
            sc_users_e:   {checked: false, locked: false},
            sc_users_d:   {checked: false, locked: true},

            co_users_r:   {checked: true, locked: true},
            co_users_w:   {checked: false, locked: false},
            co_users_e:   {checked: false, locked: false},
            co_users_d:   {checked: false, locked: false},

            businesses_r: {checked: true, locked: true},
            businesses_e: {checked: false, locked: false},
            businesses_w: {checked: false, locked: true},
            businesses_d: {checked: false, locked: true}
          }
        end

        before do
          controller.instance_variable_set(:@available_roles, PermissionsForRole::AdminDefinitions::ROLES)
          controller.instance_variable_set(:@available_permissions, PermissionsForRole::AdminDefinitions::PERMISSIONS)
          controller.instance_variable_set(:@permissions_definitions, PermissionsForRole::AdminDefinitions.new)
          allow_any_instance_of(PermissionsForRole::AdminDefinitions).to receive(:permissions_for_role).and_return(definitions)

          no_role.role_list.each { |r| no_role.remove_role r }
        end

        describe 'all permissions are allowed' do
          let(:params) { {admin_id: no_role.id, role: 'restricted_admin', permissions: %w(co_users_r sc_users_r restricted_admin co_users_r sc_users_r schemes_r businesses_r)} }

          it 'sets all the passed in permissions' do
            put :update_permissions, params
            expect(no_role.role_list).to eq %w(restricted_admin schemes_r sc_users_r co_users_r businesses_r)
          end
        end

        describe 'no permissions selected' do
          let(:params) { {admin_id: no_role.id, role: 'restricted_admin', permissions: %w()} }

          it 'sets mandatory permissions' do
            put :update_permissions, params
            expect(no_role.role_list).to eq %w(restricted_admin schemes_r sc_users_r co_users_r businesses_r)
          end
        end

        describe 'NOT all permissions are allowed' do
          let(:params) { {admin_id: no_role.id, role: 'restricted_admin', permissions: %w(co_users_r sc_users_r co_users_d sc_users_d)} }

          it 'sets ONLY the correct permissions' do
            get :permissions, admin_id: no_role.id
            put :update_permissions, params
            expect(no_role.role_list).to eq %w(restricted_admin co_users_d schemes_r sc_users_r co_users_r businesses_r)
          end
        end

        it 'redirects to correct page after save' do
          put :update_permissions, params
          expect(response.body).to include('admins/')
        end
      end
    end
  end
end
