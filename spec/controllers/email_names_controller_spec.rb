require 'rails_helper'

RSpec.describe EmailNamesController, type: :controller do
  # This should return the minimal set of attributes required to create a valid
  # EmailName. As you add validations to EmailName, be sure to
  # adjust the attributes here as well.

  let(:super_admin) { FactoryGirl.create(:super_admin) }
  before do
    sign_in super_admin
  end

  after do
    sign_out super_admin
  end

  let(:valid_attributes) do
    {name: 'test_email'}
  end

  let(:invalid_attributes) do
    {name: nil}
  end

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # EmailNamesController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe 'GET #index' do
    it 'assigns all email_names as @email_names' do
      email_name = EmailName.create! valid_attributes
      get :index, params: {}, session: valid_session
      expect(assigns(:email_names).map(&:id)).to include(email_name.id)
    end
  end

  describe 'GET #show' do
    it 'assigns the requested email_name as @email_name' do
      email_name = EmailName.create! valid_attributes
      get :show, {id: email_name.to_param}, session: valid_session
      expect(assigns(:email_name)).to eq(email_name)
    end
  end

  describe 'GET #new' do
    it 'assigns a new email_name as @email_name' do
      get :new, {}, session: valid_session
      expect(assigns(:email_name)).to be_a_new(EmailName)
    end
  end

  describe 'GET #edit' do
    it 'assigns the requested email_name as @email_name' do
      email_name = EmailName.create! valid_attributes
      get :edit, {id: email_name.to_param}, session: valid_session
      expect(assigns(:email_name)).to eq(email_name)
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new EmailName' do
        expect do
          post :create, email_name: valid_attributes, session: valid_session
        end.to change(EmailName, :count).by(1)
      end

      it 'assigns a newly created email_name as @email_name' do
        post :create, email_name: valid_attributes, session: valid_session
        expect(assigns(:email_name)).to be_a(EmailName)
        expect(assigns(:email_name)).to be_persisted
      end

      it 'redirects to the created email_name' do
        post :create, email_name: valid_attributes, session: valid_session
        expect(response).to redirect_to(EmailName.last)
      end
    end

    context 'with invalid params' do
      it 'assigns a newly created but unsaved email_name as @email_name' do
        post :create, email_name: invalid_attributes, session: valid_session
        expect(assigns(:email_name)).to be_a_new(EmailName)
      end

      it "re-renders the 'new' template" do
        post :create, email_name: invalid_attributes, session: valid_session
        expect(response).to render_template('new')
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      let(:new_attributes) do
        skip('Add a hash of attributes valid for your model')
      end

      it 'updates the requested email_name' do
        email_name = EmailName.create! valid_attributes
        put :update, {id: email_name.to_param, email_name: new_attributes}, session: valid_session
        email_name.reload
        skip('Add assertions for updated state')
      end

      it 'assigns the requested email_name as @email_name' do
        email_name = EmailName.create! valid_attributes
        put :update, {id: email_name.to_param, email_name: valid_attributes}, session: valid_session
        expect(assigns(:email_name)).to eq(email_name)
      end

      it 'redirects to the email_name' do
        email_name = EmailName.create! valid_attributes
        put :update, {id: email_name.to_param, email_name: valid_attributes}, session: valid_session
        expect(response).to redirect_to(email_name)
      end
    end

    context 'with invalid params' do
      it 'assigns the email_name as @email_name' do
        email_name = EmailName.create! valid_attributes
        put :update, {id: email_name.to_param, email_name: invalid_attributes}, session: valid_session
        expect(assigns(:email_name)).to eq(email_name)
      end

      it "re-renders the 'edit' template" do
        email_name = EmailName.create! valid_attributes
        put :update, {id: email_name.to_param, email_name: invalid_attributes}, session: valid_session
        expect(response).to render_template('edit')
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested email_name' do
      email_name = EmailName.create! valid_attributes
      expect do
        delete :destroy, {id: email_name.to_param}, session: valid_session
      end.to change(EmailName, :count).by(-1)
    end

    it 'redirects to the email_names list' do
      email_name = EmailName.create! valid_attributes
      delete :destroy, {id: email_name.to_param}, session: valid_session
      expect(response).to redirect_to(email_names_url)
    end
  end
end
