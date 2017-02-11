require 'rails_helper'
require 'spec_helper'

RSpec.describe EmailContentsController, type: :controller do
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
    sc_marti.add_role :sc_director
    PermissionsForRole::SchemeOperatorDefinitions.new.permissions_for_role(:sc_director).each do |permission, has|
      sc_marti.add_role permission if has[:checked]
    end
    sign_in sc_marti
  end

  after do
    sign_out sc_marti
  end

  # This should return the minimal set of attributes required to create a valid
  # EmailContent. As you add validations to EmailContent, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) do
    {title:                 'TITLE',
     body:                  'BODY',
     email_content_type_id: 1,
     email_name_id:         1,
     scheme_id:             1,
     intro:                 'INTRO',
     footer:                'FOOTER'}
  end

  let(:invalid_attributes) do
    {title:                 'TITLE',
     body:                  'BODY',
     email_content_type_id: nil,
     email_name_id:         nil,
     scheme_id:             nil,
     intro:                 'INTRO',
     footer:                'FOOTER'}
  end

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # EmailContentsController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe 'GET #index' do
    it 'assigns all email_contents as @email_contents' do
      email_content = EmailContent.create! valid_attributes
      get :index, {}, session: valid_session
      expect(assigns(:email_contents)).to eq([email_content])
    end
  end

  describe 'GET #show' do
    it 'assigns the requested email_content as @email_content' do
      email_content = EmailContent.create! valid_attributes
      get :show, {id: email_content.to_param}, session: valid_session
      expect(assigns(:email_content)).to eq(email_content)
    end
  end

  describe 'GET #new' do
    it 'assigns a new email_content as @email_content' do
      get :new, {}, session: valid_session
      expect(assigns(:email_content)).to be_a_new(EmailContent)
    end
  end

  describe 'GET #edit' do
    it 'assigns the requested email_content as @email_content' do
      email_content = EmailContent.create! valid_attributes
      get :edit, {id: email_content.to_param}, session: valid_session
      expect(assigns(:email_content)).to eq(email_content)
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new EmailContent' do
        expect do
          post :create, email_content: valid_attributes, session: valid_session
        end.to change(EmailContent, :count).by(1)
      end

      it 'assigns a newly created email_content as @email_content' do
        post :create, email_content: valid_attributes, session: valid_session
        expect(assigns(:email_content)).to be_a(EmailContent)
        expect(assigns(:email_content)).to be_persisted
      end

      it 'redirects to the created email_content' do
        post :create, email_content: valid_attributes, session: valid_session
        expect(response).to redirect_to(EmailContent.last)
      end
    end

    context 'with invalid params' do
      it 'assigns a newly created but unsaved email_content as @email_content' do
        post :create, email_content: invalid_attributes, session: valid_session
        expect(assigns(:email_content)).to be_a_new(EmailContent)
      end

      it "re-renders the 'new' template" do
        post :create, email_content: invalid_attributes, session: valid_session
        expect(response).to render_template('new')
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      let(:new_attributes) do
        {title:                 'NEW TITLE',
         body:                  'NEW BODY',
         email_content_type_id: 2,
         email_name_id:         2,
         scheme_id:             2,
         intro:                 'NEW INTRO',
         footer:                'NEW FOOTER'}
      end

      it 'updates the requested email_content' do
        email_content = EmailContent.create! valid_attributes
        put :update, {id: email_content.to_param, email_content: new_attributes}, session: valid_session
        email_content.reload
        skip('Add assertions for updated state')
      end

      it 'assigns the requested email_content as @email_content' do
        email_content = EmailContent.create! valid_attributes
        put :update, {id: email_content.to_param, email_content: valid_attributes}, session: valid_session
        expect(assigns(:email_content)).to eq(email_content)
      end

      it 'redirects to the email_content' do
        email_content = EmailContent.create! valid_attributes
        put :update, {id: email_content.to_param, email_content: valid_attributes}, session: valid_session
        expect(response).to redirect_to(email_content)
      end
    end

    context 'with invalid params' do
      it 'assigns the email_content as @email_content' do
        email_content = EmailContent.create! valid_attributes
        put :update, {id: email_content.to_param, email_content: invalid_attributes}, session: valid_session
        expect(assigns(:email_content)).to eq(email_content)
      end

      it "re-renders the 'edit' template" do
        email_content = EmailContent.create! valid_attributes
        put :update, {id: email_content.to_param, email_content: invalid_attributes}, session: valid_session
        expect(response).to render_template('edit')
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested email_content' do
      email_content = EmailContent.create! valid_attributes
      expect do
        delete :destroy, {id: email_content.to_param}, session: valid_session
      end.to change(EmailContent, :count).by(-1)
    end

    it 'redirects to the email_contents list' do
      email_content = EmailContent.create! valid_attributes
      delete :destroy, {id: email_content.to_param}, session: valid_session
      expect(response).to redirect_to(email_contents_url)
    end
  end
end
