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
    it 'expects the admin to have access to the index action' do
      get 'index'
      expect(response.status).to eq 200
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
      end
      context 'when an error is raised' do
        let(:params) { {admin_id: Admin.last.id, role: 'full', permissions: []} }
        it 'expects flash message to be displyed' do
          allow_any_instance_of(CommonHelpers::PermissionsHelper).to receive(:remove_unselected_permissions!).and_raise(StandardError)
          expect_any_instance_of(CommonHelpers::PermissionsHelper).to receive(:roll_back_roles!)
          put :update_permissions, params
          expect(flash[:error]).to eq "An error occured! User #{Admin.last.email}'s permissions were not updated."
        end
      end
    end
  end
end
