require 'rails_helper'

RSpec.describe EmailContentTypesController, type: :controller do
  context 'when super_admin is signed in' do
    let(:super_admin) { FactoryGirl.create(:super_admin) }
    before do
      sign_in super_admin
    end

    after do
      sign_out super_admin
    end
    # This should return the minimal set of attributes required to create a valid
    # EmailContentType. As you add validations to EmailContentType, be sure to
    # adjust the attributes here as well.
    let(:valid_attributes) do
      {name: 'test_email'}
    end

    let(:invalid_attributes) do
      {name: nil}
    end

    # This should return the minimal set of values that should be in the session
    # in order to pass any filters (e.g. authentication) defined in
    # EmailContentTypesController. Be sure to keep this updated too.
    let(:valid_session) { {} }

    describe 'GET #index' do
      it 'assigns all email_content_types as @email_content_types' do
        email_content_type = EmailContentType.create! valid_attributes
        get :index, {}, session: valid_session
        expect(assigns(:email_content_types).map(&:id)).to include(email_content_type.id)
      end
    end

    describe 'GET #show' do
      it 'assigns the requested email_content_type as @email_content_type' do
        email_content_type = EmailContentType.create! valid_attributes
        get :show, id: email_content_type.to_param, session: valid_session
        expect(assigns(:email_content_type)).to eq(email_content_type)
      end
    end

    describe 'GET #new' do
      it 'assigns a new email_content_type as @email_content_type' do
        get :new, {}, session: valid_session
        expect(assigns(:email_content_type)).to be_a_new(EmailContentType)
      end
    end

    describe 'GET #edit' do
      it 'assigns the requested email_content_type as @email_content_type' do
        email_content_type = EmailContentType.create! valid_attributes
        get :edit, id: email_content_type.to_param, session: valid_session
        expect(assigns(:email_content_type)).to eq(email_content_type)
      end
    end

    describe 'POST #create' do
      context 'with valid params' do
        it 'creates a new EmailContentType' do
          expect do
            post :create, email_content_type: valid_attributes, session: valid_session
          end.to change(EmailContentType, :count).by(1)
        end

        it 'assigns a newly created email_content_type as @email_content_type' do
          post :create, email_content_type: valid_attributes, session: valid_session
          expect(assigns(:email_content_type)).to be_a(EmailContentType)
          expect(assigns(:email_content_type)).to be_persisted
        end

        it 'redirects to the created email_content_type' do
          post :create, email_content_type: valid_attributes, session: valid_session
          expect(response).to redirect_to(EmailContentType.last)
        end
      end

      context 'with invalid params' do
        it 'assigns a newly created but unsaved email_content_type as @email_content_type' do
          post :create, email_content_type: invalid_attributes, session: valid_session
          expect(assigns(:email_content_type)).to be_a_new(EmailContentType)
        end

        it "re-renders the 'new' template" do
          post :create, email_content_type: invalid_attributes, session: valid_session
          expect(response).to render_template('new')
        end
      end
    end

    describe 'PUT #update' do
      context 'with valid params' do
        let(:new_attributes) do
          skip('Add a hash of attributes valid for your model')
        end

        it 'updates the requested email_content_type' do
          email_content_type = EmailContentType.create! valid_attributes
          put :update, {id: email_content_type.to_param, email_content_type: new_attributes}, session: valid_session
          email_content_type.reload
          skip('Add assertions for updated state')
        end

        it 'assigns the requested email_content_type as @email_content_type' do
          email_content_type = EmailContentType.create! valid_attributes
          put :update, id: email_content_type.to_param, email_content_type: valid_attributes, session: valid_session
          expect(assigns(:email_content_type)).to eq(email_content_type)
        end

        it 'redirects to the email_content_type' do
          email_content_type = EmailContentType.create! valid_attributes
          put :update, {id: email_content_type.to_param, email_content_type: valid_attributes}, session: valid_session
          expect(response).to redirect_to(email_content_type)
        end
      end

      context 'with invalid params' do
        it 'assigns the email_content_type as @email_content_type' do
          email_content_type = EmailContentType.create! valid_attributes
          put :update, {id: email_content_type.to_param, email_content_type: invalid_attributes}, session: valid_session
          expect(assigns(:email_content_type)).to eq(email_content_type)
        end

        it "re-renders the 'edit' template" do
          email_content_type = EmailContentType.create! valid_attributes
          put :update, {id: email_content_type.to_param, email_content_type: invalid_attributes}, session: valid_session
          expect(response).to render_template('edit')
        end
      end
    end

    describe 'DELETE #destroy' do
      it 'destroys the requested email_content_type' do
        email_content_type = EmailContentType.create! valid_attributes
        expect do
          delete :destroy, {id: email_content_type.to_param}, session: valid_session
        end.to change(EmailContentType, :count).by(-1)
      end

      it 'redirects to the email_content_types list' do
        email_content_type = EmailContentType.create! valid_attributes
        delete :destroy, {id: email_content_type.to_param}, session: valid_session
        expect(response).to redirect_to(email_content_types_url)
      end
    end
  end
end
