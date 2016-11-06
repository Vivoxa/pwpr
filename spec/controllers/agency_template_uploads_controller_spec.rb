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
    co_marti.add_role :uploads_w
    co_marti.add_role :uploads_r
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
      get :show, scheme_id: 1, id: 1
    end

    it 'responds with 200' do
      expect(response.status).to eq 200
    end

    it 'assigns the upload as @upload' do
      expect(assigns(:upload)).to eq AgencyTemplateUpload.first
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

    it 'initializes the uploaded_at' do
      expect(assigns(:upload).uploaded_at).not_to be_nil
    end

    it 'initializes the status' do
      expect(assigns(:upload).status).to eq CommonHelpers::AgencyTemplateUploadStatus::PENDING
    end

    it 'assigns the scheme as @scheme' do
      expect(assigns(:scheme)).to eq Scheme.first
    end
  end

  describe 'POST #create' do
    before do
      filename = double('file', original_filename: 'my original filename', tempfile: double('tempfile', path: 'my temp file'))
      allow(subject).to receive(:upload_params).and_return(year: '2016', filename: filename)
      allow(FileUtils).to receive(:cp).with('my temp file', 'public/my original filename')
      allow(File).to receive(:exist?).and_return true
      ENV['AWS_REGION'] = 'eu-west-1'
      allow_any_instance_of(Aws::S3::Object).to receive(:upload_file).with('public/my original filename')

      expect { post :create, agency_template_upload:  {year: '2016', filename: 'feef'}, scheme_id: 1 }.to change { AgencyTemplateUpload.count }.by(1)
    end

    it 'responds with 302' do
      expect(response.status).to eq 302
    end

    it 'responds to be redirect' do
      expect(response.redirect?).to be true
    end

    it 'expects the year to be assigned correctly' do
      expect(AgencyTemplateUpload.last.year).to eq 2016
    end

    it 'expects the filename to be assigned correctly' do
      expect(AgencyTemplateUpload.last.filename).to eq 'my original filename'
    end

    it 'expects the uploaded_by_id to be correct' do
      expect(AgencyTemplateUpload.last.uploaded_by_id).to eq co_marti.id
    end

    it 'expects the uploaded_by_type to be correct' do
      expect(AgencyTemplateUpload.last.uploaded_by_type).to eq 'SchemeOperator'
    end

    it 'expects the scheme_id to be correct' do
      expect(AgencyTemplateUpload.last.scheme_id).to eq 1
    end

    it 'expects the status to be correct' do
      expect(AgencyTemplateUpload.last.status).to eq CommonHelpers::AgencyTemplateUploadStatus::PENDING
    end
  end
end
