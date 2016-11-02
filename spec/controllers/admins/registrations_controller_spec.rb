RSpec.describe Admins::RegistrationsController, type: :controller do
  before do
    @request.env['devise.mapping'] = Devise.mappings[:admin]
  end

  context 'when admin is NOT signed in' do
    context 'when calling create' do
      it 'expects an error when trying to access the sign_up page' do
        post :create, params: {}
        expect(response.status).to eq 302
        expect(flash[:alert]).to eq('You are not authorized to access this page.')
      end
    end
  end

  context 'when super_admin is signed in' do
    let(:super_admin) { FactoryGirl.create(:super_admin) }
    before do
      sign_in super_admin
    end

    after do
      sign_out super_admin
    end

    it 'expects to be able to access the sign up page' do
      get :new
      expect(response.status).to eq 200
      expect(flash[:alert]).to be_nil
    end
  end

  context 'when normal_admin is signed in' do
    let(:normal_admin) { FactoryGirl.create(:normal_admin) }
    before do
      sign_in normal_admin
    end

    after do
      sign_out normal_admin
    end

    it 'expects to be able to access the sign up page' do
      get :new
      expect(response.status).to eq 302
      expect(flash[:alert]).to eq('You are not authorized to access this page.')
    end
  end
end
