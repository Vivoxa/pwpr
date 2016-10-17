require 'rails_helper'

RSpec.describe AdminsController, type: :controller do
  context 'when admin operator is NOT signed in' do
    context 'when calling index' do
      it 'expects to be redirected to sign in' do
        get :index
        expect(response.status).to eq 302
        expect(response.body).to include('admins/sign_in')
      end
    end

    context 'when calling show' do
      it 'expects to be redirected to sign in' do
        get :show, id: Admin.last.id
        expect(response.status).to eq 302
        expect(response.body).to include('admins/sign_in')
      end
    end

    context 'when calling permissions' do
      it 'expects to be redirected to sign in' do
        get :permissions, admin_id: Admin.last.id
        expect(response.status).to eq 302
        expect(response.body).to include('admins/sign_in')
      end
    end

    context 'when calling update_permissions' do
      it 'expects to be redirected to sign in' do
        put :update_permissions, admin_id: Admin.last.id
        expect(response.status).to eq 302
        expect(response.body).to include('admins/sign_in')
      end
    end
  end

  context 'when admin does NOT have full_access role' do
    let(:admin_marti) { FactoryGirl.create(:admin) }

    before do
      sign_in admin_marti
    end

    it 'expects a CanCan AccessDenied error to be raised' do
      get :index
      expect(flash[:alert]).to be_present
      expect(flash[:alert]).to eq 'You are not authorized to access this page.'
    end

    it 'expects a CanCan AccessDenied error to be raised' do
      get :show, id: admin_marti.id
      expect(flash[:alert]).to be_present
      expect(flash[:alert]).to eq 'You are not authorized to access this page.'
    end

    context 'when calling permissions' do
      it 'expects a CanCan AccessDenied error to be raised' do
        get :permissions, admin_id: Admin.last.id
        expect(flash[:alert]).to be_present
        expect(flash[:alert]).to eq 'You are not authorized to access this page.'
      end
    end

    context 'when calling update_permissions' do
      it 'expects a CanCan AccessDenied error to be raised' do
        put :update_permissions, admin_id: Admin.last.id
        expect(flash[:alert]).to be_present
        expect(flash[:alert]).to eq 'You are not authorized to access this page.'
      end
    end
  end

  context 'when admin has full_access role' do
    let(:admin_doc) { FactoryGirl.create(:admin_full_access) }
    before do
      sign_in admin_doc
    end

    it 'expects the admin to have access to the index action' do
      get 'index'
      expect(response.status).to eq 200
    end

    it 'expects the admin to have access to the show action' do
      get :show, id: admin_doc.id
      expect(response.status).to eq 200
    end

    it 'expects the admin to have access to the permissions action' do
      get :permissions, admin_id: Admin.last.id
      expect(response.status).to eq 200
    end

    it 'expects the admin to have access to the update_permissions action' do
      put :update_permissions, admin_id: Admin.last.id
      expect(response.status).to eq 302
    end
  end
end
