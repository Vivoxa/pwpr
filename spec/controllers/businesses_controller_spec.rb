require 'rails_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

RSpec.describe BusinessesController, type: :controller do
  # This should return the minimal set of attributes required to create a valid
  # Business. As you add validations to Business, be sure to
  # adjust the attributes here as well.
  context 'when scheme operator is signed in' do
    let(:co_marti) { SchemeOperator.new }
    before do
      co_marti.email = 'jennifer@back_to_the_future.com'
      co_marti.first_name = 'Jennifer'
      co_marti.password = 'mypassword'
      co_marti.confirmed_at = DateTime.now
      co_marti.schemes = [Scheme.create(name: 'test scheme', active: true)]
      co_marti.save
      co_marti.add_role('sc_director')
      co_marti.approved = true
      co_marti.save
      sign_in co_marti
    end
    let(:valid_attributes) do
      {scheme_id: co_marti.schemes.last.id, NPWD: 'kgkgk', sic_code_id: SicCode.first.id, name: 'business 1', membership_id: 'mem-1', company_no: '123456789'}
    end

    let(:invalid_attributes) do
      {scheme_id: 1, NPWD: nil, sic_code_id: nil, name: 'business 1', membership_id: 'mem-1', company_no: '123456789'}
    end

    # This should return the minimal set of values that should be in the session
    # in order to pass any filters (e.g. authentication) defined in
    # BusinessesController. Be sure to keep this updated too.
    let(:valid_session) { {} }

    describe 'GET #index' do
      it 'assigns all businesses as @businesses' do
        business = Business.create! valid_attributes
        get :index, scheme_id: co_marti.schemes.last.id, session: valid_session
        business_ids = assigns(:businesses).map(&:id)
        expect(business_ids).to include(business.id)
      end
    end

    describe 'GET #show' do
      it 'assigns the requested business as @business' do
        business = Business.create! valid_attributes
        get :show, {id: business.to_param}, session: valid_session
        expect(response.status).to eq 200
      end
    end

    describe 'GET #new' do
      it 'assigns a new business as @business' do
        get :new, {}, session: valid_session
        expect(response.status).to eq 200
      end
    end

    describe 'GET #edit' do
      it 'assigns the requested business as @business' do
        business = Business.create! valid_attributes
        get :edit, {id: business.to_param}, session: valid_session
        expect(response.status).to eq 200
      end
    end

    describe 'POST #create' do
      context 'with valid params' do
        it 'creates a new Business' do
          expect do
            post :create, {business: valid_attributes}, session: valid_session
          end.to change(Business, :count).by(1)
        end

        it 'assigns a newly created business as @business' do
          post :create, {business: valid_attributes}, session: valid_session
          created_business = assigns(:business)
          expect(created_business).to be_a(Business)
          expect(created_business).to be_persisted
        end

        it 'redirects to the created business' do
          post :create, {business: valid_attributes}, session: valid_session
          expect(response).to redirect_to(Business.last)
        end
      end

      context 'with invalid params' do
        it 'assigns a newly created but unsaved business as @business' do
          post :create, {business: invalid_attributes}, session: valid_session
          expect(assigns(:business)).to be_a(Business)
        end

        it "re-renders the 'new' template" do
          post :create, {business: invalid_attributes}, session: valid_session
          expect(response).to render_template('new')
        end
      end
    end

    describe 'PUT #update' do
      context 'with valid params' do
        let(:new_attributes) do
          {name: 'business 2', membership_id: 'mem-2', company_no: '987654321'}
        end

        it 'updates the requested business' do
          business = Business.create! valid_attributes
          put :update, {id: business.to_param, business: new_attributes}, session: valid_session
          business.reload
          expect(assigns(:business).name).to eq 'business 2'
        end

        it 'assigns the requested business as @business' do
          business = Business.create! valid_attributes
          put :update, {id: business.to_param, business: valid_attributes}, session: valid_session
          expect(assigns(:business)).to eq(business)
        end

        it 'redirects to the business' do
          business = Business.create! valid_attributes
          put :update, {id: business.to_param, business: valid_attributes}, session: valid_session
          expect(response).to redirect_to(businesses_url)
        end
      end

      context 'with invalid params' do
        it 'assigns the business as @business' do
          business = Business.create! valid_attributes
          put :update, {id: business.to_param, business: invalid_attributes}, session: valid_session
          expect(assigns(:business)).to eq(business)
        end

        it "re-renders the 'edit' template" do
          business = Business.create! valid_attributes
          put :update, {id: business.to_param, business: invalid_attributes}, session: valid_session
          expect(response).to render_template('edit')
        end
      end
    end

    describe 'DELETE #destroy' do
      it 'destroys the requested business' do
        business = Business.create! valid_attributes
        expect do
          delete :destroy, {id: business.to_param}, session: valid_session
        end.to change(Business, :count).by(-1)
      end

      it 'redirects to the businesses list' do
        business = Business.create! valid_attributes
        delete :destroy, {id: business.to_param}, session: valid_session
        expect(response).to redirect_to(businesses_url)
      end
    end
  end
end
