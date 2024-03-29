require 'rails_helper'
RSpec.describe SchemesController, type: :controller do
  context 'when scheme operator is signed in' do
    let(:admin) { Admin.new }
    let(:co_marti) { SchemeOperator.first }
    before do
      admin.email = 'jennifer@back_to_the_future.com'
      admin.name = 'Smith'
      admin.password = 'mypassword'
      admin.save
      PermissionsForRole::AdminDefinitions.new.permissions_for_role(:super_admin).each do |permission, has|
        admin.add_role permission if has[:checked]
      end
      admin.save!

      co_marti.schemes = [Scheme.create(name: 'test scheme', active: true, scheme_country_code_id: 1)]
      co_marti.save!

      sign_in admin
    end

    after do
      PermissionsForRole::AdminDefinitions.new.permissions_for_role(:super_admin).each do |permission, _has|
        admin.remove_role permission
      end
      sign_out admin
    end

    # This should return the minimal set of attributes required to create a valid
    # Scheme. As you add validations to Scheme, be sure to
    # adjust the attributes here as well.
    let(:valid_attributes) do
      {name: 'MyScheme', active: true, scheme_country_code_id: 1}
    end

    let(:invalid_attributes) do
      {name: 'MyScheme', active: true, scheme_country_code_id: 1}
    end

    # This should return the minimal set of values that should be in the session
    # in order to pass any filters (e.g. authentication) defined in
    # SchemesController. Be sure to keep this updated too.
    let(:valid_session) { {} }

    describe 'GET #index' do
      it 'assigns all schemes as @schemes' do
        scheme = Scheme.create! valid_attributes
        co_marti.schemes << scheme
        get :index, {}, session: valid_session
        scheme_ids = assigns(:schemes).map(&:id)

        expect(scheme_ids).to include(scheme.id)
      end
    end

    describe 'GET #show' do
      it 'assigns the requested scheme as @scheme' do
        scheme = Scheme.create! valid_attributes
        get :show, {id: scheme.to_param}, session: valid_session
        expect(assigns(:scheme)).to eq(scheme)
      end
    end

    describe 'GET #new' do
      it 'assigns a new scheme as @scheme' do
        get :new, {}, session: valid_session
        expect(assigns(:scheme)).to be_a_new(Scheme)
      end
    end

    describe 'GET #edit' do
      it 'assigns the requested scheme as @scheme' do
        scheme = Scheme.create! valid_attributes
        get :edit, {id: scheme.to_param}, session: valid_session
        expect(assigns(:scheme)).to eq(scheme)
      end
    end

    describe 'POST #create' do
      context 'with valid params' do
        it 'creates a new Scheme' do
          expect do
            post :create, {scheme: valid_attributes}, session: valid_session
          end.to change(Scheme, :count).by(1)
        end

        it 'assigns a newly created scheme as @scheme' do
          post :create, {scheme: valid_attributes}, session: valid_session
          expect(assigns(:scheme)).to be_a(Scheme)
          expect(assigns(:scheme)).to be_persisted
        end

        it 'redirects to the created scheme' do
          post :create, {scheme: valid_attributes}, session: valid_session
          expect(response).to redirect_to(Scheme.last)
        end
      end
    end

    describe 'PUT #update' do
      context 'with valid params' do
        let(:new_attributes) do
          {name: 'updated scheme name', active: false}
        end

        it 'updates the requested scheme' do
          scheme = Scheme.create! valid_attributes
          co_marti.scheme_ids << scheme.id
          co_marti.save
          put :update, {id: scheme.to_param, scheme: new_attributes}, session: valid_session
          scheme.reload
          skip('Add assertions for updated state')
        end

        it 'assigns the requested scheme as @scheme' do
          scheme = Scheme.create! valid_attributes
          co_marti.scheme_ids << scheme.id
          co_marti.save
          put :update, {id: scheme.to_param, scheme: valid_attributes}, session: valid_session
          expect(assigns(:scheme)).to eq(scheme)
        end

        it 'redirects to the scheme' do
          scheme = Scheme.create! valid_attributes
          co_marti.schemes << scheme
          co_marti.save
          put :update, {id: scheme.to_param, scheme: valid_attributes}, session: valid_session
          expect(response).to redirect_to(schemes_url)
        end
      end

      context 'with invalid params' do
        it 'assigns the scheme as @scheme' do
          scheme = Scheme.create! valid_attributes
          co_marti.schemes << scheme
          co_marti.save
          put :update, {id: scheme.to_param, scheme: invalid_attributes}, session: valid_session
          expect(assigns(:scheme)).to eq(scheme)
        end
      end
    end

    describe 'DELETE #destroy' do
      it 'destroys the requested scheme' do
        scheme = Scheme.create! valid_attributes
        co_marti.schemes << scheme
        co_marti.save
        expect do
          delete :destroy, {id: scheme.to_param}, session: valid_session
        end.to change(Scheme, :count).by(-1)
      end

      it 'redirects to the schemes list' do
        scheme = Scheme.create! valid_attributes
        co_marti.schemes << scheme
        co_marti.save
        delete :destroy, {id: scheme.to_param}, session: valid_session
        expect(response).to redirect_to(schemes_url)
      end
    end

    context 'when SchemeOperator does NOT have a role' do
      before do
        sign_out admin
        sign_out co_marti
        co_marti.roles.each do |role|
          co_marti.remove_role role.name
        end
        co_marti.save
        sign_in co_marti
      end

      after do
        sign_out co_marti
      end

      context 'when calling index' do
        it 'expects a CanCan AccessDenied error to be raised' do
          get :index
          expect(flash[:alert]).to be_present
          expect(flash[:alert]).to eq 'You are not authorized to access this page.'
        end
      end

      context 'when calling show' do
        it 'expects a CanCan AccessDenied error to be raised' do
          get :show, id: Scheme.last.id
          expect(flash[:alert]).to be_present
          expect(flash[:alert]).to eq 'You are not authorized to access this page.'
        end
      end

      context 'when calling update' do
        it 'expects a CanCan AccessDenied error to be raised' do
          get :update, id: Scheme.last.id
          expect(flash[:alert]).to be_present
          expect(flash[:alert]).to eq 'You are not authorized to access this page.'
        end
      end

      context 'when calling destroy' do
        it 'expects a CanCan AccessDenied error to be raised' do
          get :update, id: Scheme.last.id
          expect(flash[:alert]).to be_present
          expect(flash[:alert]).to eq 'You are not authorized to access this page.'
        end
      end
    end

    context 'when SchemeOperator has co_director role' do
      before do
        sign_out co_marti
        co_marti.add_role('sc_director')
        co_marti.save
        sign_in co_marti
      end

      after do
        co_marti.remove_role :sc_director
        sign_out co_marti
      end

      it 'expects the admin to have access to the index action' do
        get 'index'
        expect(response.status).to eq 200
      end

      it 'expects the admin to have access to the show action' do
        get :show, id: Scheme.last.id
        expect(response.status).to eq 200
      end
    end
  end
  context 'when scheme operator is NOT signed in' do
    context 'when calling index' do
      it 'expects to be redirected to sign in' do
        get :index
        expect(response.status).to eq 302
        expect(response.body).to include('scheme_operators/sign_in')
      end
    end

    context 'when calling show' do
      it 'expects to be redirected to sign in' do
        get :show, id: SchemeOperator.last.id
        expect(response.status).to eq 302
        expect(response.body).to include('scheme_operators/sign_in')
      end
    end

    context 'when calling update' do
      it 'expects to be redirected to sign in' do
        get :update, id: SchemeOperator.last.id
        expect(response.status).to eq 302
        expect(response.body).to include('scheme_operators/sign_in')
      end
    end

    context 'when calling destroy' do
      it 'expects to be redirected to sign in' do
        get :destroy, id: SchemeOperator.last.id
        expect(response.status).to eq 302
        expect(response.body).to include('scheme_operators/sign_in')
      end
    end
  end
end
