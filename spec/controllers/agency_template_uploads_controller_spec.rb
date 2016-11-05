require 'rails_helper'

RSpec.describe AgencyTemplateUploadsController, type: :controller do
  let(:valid_attributes) { {year: '2015', file: 'some_file.xls'} }
  let(:invalid_attributes) { {filename: 'some_file.xls'} }
  let(:co_marti) { SchemeOperator.new }
  let(:role_permissions) { ::PermissionsForRole::SchemeOperatorDefinitions.new }
  let(:sc_director_roles) { role_permissions.permissions_for_role('sc_director').keys }

  before do
    co_marti.email = 'jennifer@back_to_the_future.com'
    co_marti.name = 'Jennifer'
    co_marti.password = 'mypassword'
    co_marti.confirmed_at = DateTime.now
    co_marti.schemes = [Scheme.first]
    co_marti.save
    co_marti.approved = true

    sc_director_roles.each do |permission|
      co_marti.add_role permission
    end

    co_marti.save
    sign_in co_marti
  end

  after do
    sc_director_roles.each do |permission|
      co_marti.remove_role permission
    end
    sign_out co_marti
  end

  describe 'GET #index' do
    before do
      get :index, scheme_id: 1
    end

    it 'responds with 200' do
      expect(response.status).to eq 200
    end

    it 'assigns all uploads as @uploads' do
      expect(assigns(:uploads)).to eq(Scheme.first.agency_template_uploads)
    end
  end

  describe 'GET #show' do
    before do
      get :index, scheme_id: 1, id: 1
    end

    it 'responds with 200' do
      expect(response.status).to eq 200
    end

    it 'assigns the upload as @upload' do
      expect(assigns(:upload)).to eq(AgencyTemplateUpload.first)
    end
  end

  describe 'GET #new' do
    before do
      get :new, scheme_id: 1
    end

    it 'responds with 200' do
      expect(response.status).to eq 200
    end

    it 'assigns the upload as @upload' do
      expect(assigns(:upload)).to be_a(AgencyTemplateUpload)
    end

    it 'initializes the scheme_id' do
      expect(assigns(:upload).scheme_id).to be_a(Scheme.first.id)
    end

    it 'initializes the uploaded_by_id' do
      expect(assigns(:upload).uploaded_by_id).to be_a(subject.current_user.id)
    end

    it 'initializes the uploaded_at' do
      expect(assigns(:upload).uploaded_at).to be_a(DateTime.now)
    end

    it 'initializes the status' do
      expect(assigns(:upload).status).to be_a(DateTime.now)
    end

    it 'assigns the scheme as @scheme' do
      expect(assigns(:upload)).to eq(Scheme.first)
    end
  end

  describe 'POST #create' do
    it 'creates and uploads the file' do
      before do
        post :create, scheme_id: 1
      end

      it 'responds with 200' do
        expect(response.status).to eq 200
      end

      it 'assigns the upload as @upload' do
        expect(assigns(:upload)).to be_a(AgencyTemplateUpload)
      end
    end
  end
end
