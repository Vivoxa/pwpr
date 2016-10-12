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
  end

  context 'when admin does NOT have full_access role' do
    let(:admin_marti) { FactoryGirl.create(:admin) }

    before do
      sign_in admin_marti
    end

    it 'expects a CanCan AccessDenied error to be raised' do
      expect { get 'index' }.to raise_error(CanCan::AccessDenied)
    end

    it 'expects a CanCan AccessDenied error to be raised' do
      expect { get :show, id: admin_marti.id }.to raise_error(CanCan::AccessDenied)
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
  end
end
