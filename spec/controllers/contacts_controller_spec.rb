require 'rails_helper'

RSpec.describe ContactsController, type: :controller do
  # This should return the minimal set of attributes required to create a valid
  # Contact. As you add validations to Contact, be sure to
  # adjust the attributes here as well.
  let(:scheme_operator_with_director) { FactoryGirl.create(:scheme_operator_with_director) }
  let(:business_id) { scheme_operator_with_director.schemes.first.businesses.first.id }
  before do
    scheme_operator_with_director.contacts_d!
    sign_in scheme_operator_with_director
  end

  after do
    sign_out scheme_operator_with_director
  end

  let(:valid_attributes) do
    {
      address_type_id: 2,
      business_id:     business_id,
      first_name:      'nigel',
      last_name:       'surtees',
      title:           'Mr',
      email:           'somebody@emai.com',
      telephone_1:     '09876543212',
      telephone_2:     '09876543233',
      fax:             '987864357389485'
    }
  end

  let(:invalid_attributes) do
    {
      address_type_id: 2,
      business_id:     business_id,
      first_name:      nil,
      last_name:       'surtees',
      title:           'Mr',
      email:           'somebody@emai.com',
      telephone_1:     '09876543212',
      telephone_2:     '09876543233',
      fax:             '987864357389485'
    }
  end

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # ContactsController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe 'GET #index' do
    it 'assigns all contacts as @contacts' do
      contact = Contact.create! valid_attributes
      get :index, business_id: business_id, session: valid_session
      contacts = assigns(:contacts)
      retrieved_contact = contacts.where(id: contact.id)
      expect(retrieved_contact).to eq([contact])
    end

    it 'assigns business as @business' do
      get :index, business_id: business_id, session: valid_session

      business = assigns(:business)
      expect(business.id).to eq(business_id)
    end
  end

  describe 'GET #show' do
    it 'assigns the requested contact as @contact' do
      contact = Contact.create! valid_attributes
      get :show, id: contact.to_param, business_id: business_id, session: valid_session
      expect(assigns(:contact)).to eq(contact)
    end
  end

  describe 'GET #new' do
    it 'assigns a new contact as @contact' do
      get :new, business_id: business_id, session: valid_session
      expect(assigns(:contact)).to be_a_new(Contact)
    end
  end

  describe 'GET #edit' do
    it 'assigns the requested contact as @contact' do
      contact = Contact.create! valid_attributes
      get :edit, id: contact.to_param, business_id: business_id, session: valid_session
      expect(assigns(:contact)).to eq(contact)
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new Contact' do
        expect do
          post :create, contact: valid_attributes, business_id: business_id, session: valid_session
        end.to change(Contact, :count).by(1)
      end

      it 'assigns a newly created contact as @contact' do
        post :create, contact: valid_attributes, business_id: business_id, session: valid_session
        expect(assigns(:contact)).to be_a(Contact)
        expect(assigns(:contact)).to be_persisted
      end

      it 'redirects to the created contact' do
        post :create, contact: valid_attributes, business_id: business_id, session: valid_session
        expect(response).to redirect_to(business_contact_path(id: Contact.last.id))
      end
    end

    context 'with invalid params' do
      it 'assigns a newly created but unsaved contact as @contact' do
        post :create, contact: invalid_attributes, business_id: business_id, session: valid_session
        expect(assigns(:contact)).to be_a_new(Contact)
      end

      it "re-renders the 'new' template" do
        post :create, contact: invalid_attributes, business_id: business_id, session: valid_session
        expect(response).to render_template('new')
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      let(:new_attributes) do
        skip('Add a hash of attributes valid for your model')
      end

      it 'updates the requested contact' do
        contact = Contact.create! valid_attributes
        put :update, id: contact.to_param, contact: new_attributes, business_id: business_id, session: valid_session
        contact.reload
        skip('Add assertions for updated state')
      end

      it 'assigns the requested contact as @contact' do
        contact = Contact.create! valid_attributes
        put :update, id: contact.to_param, contact: valid_attributes, business_id: business_id, session: valid_session
        expect(assigns(:contact)).to eq(contact)
      end

      it 'redirects to the contact' do
        contact = Contact.create! valid_attributes
        put :update, id: contact.to_param, contact: valid_attributes, business_id: business_id, session: valid_session
        expect(response).to redirect_to(business_contact_path(id: contact.id))
      end
    end

    context 'with invalid params' do
      it 'assigns the contact as @contact' do
        contact = Contact.create! valid_attributes
        put :update, id: contact.to_param, contact: invalid_attributes, business_id: business_id, session: valid_session
        expect(assigns(:contact)).to eq(contact)
      end

      it "re-renders the 'edit' template" do
        contact = Contact.create! valid_attributes
        put :update, id: contact.to_param, contact: invalid_attributes, business_id: business_id, session: valid_session
        expect(response).to render_template('edit')
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested contact' do
      contact = Contact.create! valid_attributes
      expect do
        delete :destroy, id: contact.to_param, business_id: business_id, session: valid_session
      end.to change(Contact, :count).by(-1)
    end

    it 'redirects to the contacts list' do
      contact = Contact.create! valid_attributes
      delete :destroy, id: contact.to_param, business_id: business_id, session: valid_session
      expect(response).to redirect_to(business_contacts_path(business_id: business_id))
    end
  end
end
