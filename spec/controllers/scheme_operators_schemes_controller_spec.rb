require 'rails_helper'

RSpec.describe SchemeOperatorsSchemesController, type: :controller do
  let(:scheme_operator_with_director) { FactoryGirl.create(:scheme_operator_with_director) }
  let(:scheme_id) { scheme_operator_with_director.schemes.first.id }
  before do
    sign_in scheme_operator_with_director
  end

  after do
    sign_out scheme_operator_with_director
  end
  # This should return the minimal set of attributes required to create a valid
  # SchemeOperatorsScheme. As you add validations to SchemeOperatorsScheme, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) do
    {scheme_id: scheme_id, scheme_operator_id: 3}
  end

  let(:invalid_attributes) do
    {scheme_id: 'invalid', scheme_operator_id: 'invalid'}
  end

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # SchemeOperatorsSchemesController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe 'GET #index' do
    it 'assigns all scheme_operators_schemes as @scheme_operators_schemes' do
      scheme_operators_scheme = SchemeOperatorsScheme.create! valid_attributes
      get :index, scheme_id: scheme_id, session: valid_session
      listed = assigns(:scheme_operators_schemes).where(scheme_id: scheme_id, scheme_operator_id: scheme_operators_scheme.scheme_operator_id)
      expect(listed.first.scheme_id).to eq(scheme_operators_scheme.scheme_id)
      expect(listed.first.scheme_operator_id).to eq(scheme_operators_scheme.scheme_operator_id)
    end
  end

  describe 'GET #new' do
    it 'assigns a new scheme_operators_scheme as @scheme_operators_scheme' do
      get :new, {scheme_id: scheme_id, scheme_operator_id: 1}, session: valid_session
      expect(assigns(:scheme_operators_scheme)).to be_a_new(SchemeOperatorsScheme)
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new SchemeOperatorsScheme' do
        expect do
          post :create, scheme_operators_scheme: valid_attributes, scheme_id: scheme_id
        end.to change(SchemeOperatorsScheme, :count).by(1)
      end

      it 'assigns a newly created scheme_operators_scheme as @scheme_operators_scheme' do
        post :create, scheme_operators_scheme: valid_attributes, scheme_id: 1
        expect(assigns(:scheme_operators_scheme)).to be_a(SchemeOperatorsScheme)
        expect(assigns(:scheme_operators_scheme)).to be_persisted
      end

      it 'redirects to the created scheme_operators_scheme' do
        post :create, scheme_operators_scheme: valid_attributes, scheme_id: scheme_id
        expect(response).to redirect_to(scheme_scheme_operators_schemes_path)
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested scheme_operators_scheme' do
      scheme_operators_scheme = SchemeOperatorsScheme.create! valid_attributes
      expect do
        delete :destroy, {id: scheme_operators_scheme.to_param, scheme_id: scheme_id}, session: valid_session
      end.to change(SchemeOperatorsScheme, :count).by(-1)
    end

    it 'redirects to the scheme_operators_schemes list' do
      scheme_operators_scheme = SchemeOperatorsScheme.create! valid_attributes
      delete :destroy, {id: scheme_operators_scheme.to_param, scheme_id: scheme_id}, session: valid_session
      expect(response).to redirect_to(scheme_scheme_operators_schemes_path)
    end
  end
end
