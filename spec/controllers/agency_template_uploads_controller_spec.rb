require 'rails_helper'

RSpec.describe AgencyTemplateUploadsController, type: :controller do
  let(:valid_attributes) { {year: '2015', file: 'some_file.xls'} }
  let(:invalid_attributes) { {filename: 'some_file.xls'} }
  let(:so_marti_director) { FactoryGirl.create(:scheme_operator_with_director) }
  let(:role_permissions) { ::PermissionsForRole::SchemeOperatorDefinitions.new }
  let(:sc_director_roles) { role_permissions.permissions_for_role('sc_director').keys }

  before do
    sign_in so_marti_director

    # This will need to better be included in the spec once we have a process
    allow_any_instance_of(QueueHelpers::RabbitMq::Publisher).to receive(:publish).and_return true
  end

  after do
    sign_out so_marti_director
  end

  describe 'GET #index' do
    before do
      get :index, scheme_id: so_marti_director.schemes.first.id
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
      get :show, scheme_id: so_marti_director.schemes.first.id, id: 1
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
      get :new, scheme_id: so_marti_director.schemes.first.id
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
      expect(assigns(:scheme)).to eq so_marti_director.schemes.first
    end
  end

  describe 'POST #create' do
    let(:filename) { double('file', original_filename: 'my original filename.xls', tempfile: double('tempfile', path: 'my temp file.xls')) }

    before do
      allow(FileUtils).to receive(:cp).with('my temp file.xls', 'public/my original filename.xls')
      allow(File).to receive(:exist?).and_return true
      ENV['AWS_REGION'] = 'eu-west-1'
    end

    context 'when a user is uploading for year that has an upload already' do
      before do
        @request.env['HTTP_REFERER'] = '/'
        allow_any_instance_of(Aws::S3::Object).to receive(:upload_file).with('public/my original filename.xls').and_return(true)
        allow(subject).to receive(:upload_params).and_return(year: 2015, filename: filename)
      end
      context 'when the user does NOT give permission to overwrite' do
        let(:params) { {agency_template_upload: {year: 2015, filename: 'feef.xls'}, scheme_id: so_marti_director.schemes.first.id, upload_exists: true} }
        it 'expects a flash error message to be displayed' do
          expect { post :create, params }.not_to change { AgencyTemplateUpload.count }
          expect(flash[:error]).to eq 'You are uploading a file for a year that already has an uploaded and processed template.'\
      ' Please resubmit the upload and confirm you want to replace the existing file in the checkbox highlighted red.'
        end
      end
      context 'when the user DOES give permission to overwrite' do
        let(:params) { {agency_template_upload: {year: 2015, filename: 'feef.xls'}, scheme_id: so_marti_director.schemes.first.id, upload_exists: '1', confirm_replace: '1'} }
        it 'expects a flash error message to be displayed' do
          expect { post :create, params }.to change { AgencyTemplateUpload.count }.by(1)
          expect(flash[:error]).to be_nil
        end
      end
    end
    context 'when correct values are present' do
      before do
        allow_any_instance_of(Aws::S3::Object).to receive(:upload_file).with('public/my original filename.xls').and_return(true)
        allow(subject).to receive(:upload_params).and_return(year: 2015, filename: filename)
        expect { post :create, agency_template_upload: {year: 2015, filename: 'feef.xls'}, scheme_id: so_marti_director.schemes.first.id }.to change { AgencyTemplateUpload.count }.by(1)
      end
      it 'responds with 302' do
        expect(response.status).to eq 302
      end

      it 'responds to be redirect' do
        expect(response.redirect?).to be true
      end

      it 'expects the year to be assigned correctly' do
        expect(AgencyTemplateUpload.last.year).to eq 2015
      end

      it 'expects the filename to be assigned correctly' do
        expect(AgencyTemplateUpload.last.filename).to eq 'my original filename.xls'
      end

      it 'expects the uploaded_by_id to be correct' do
        expect(AgencyTemplateUpload.last.uploaded_by_id).to eq so_marti_director.id
      end

      it 'expects the uploaded_by_type to be correct' do
        expect(AgencyTemplateUpload.last.uploaded_by_type).to eq 'SchemeOperator'
      end

      it 'expects the user to see a flash message' do
        expect(flash[:notice]).to eq "'my original filename.xls' uploaded successfully! Processing of this template will be done in the background. The status of the Agency Template Upload will be updated when processing is complete."
      end

      it 'expects the scheme_id to be correct' do
        expect(AgencyTemplateUpload.last.scheme_id).to eq so_marti_director.schemes.first.id
      end

      it 'expects the status to be correct' do
        expect(AgencyTemplateUpload.last.status).to eq CommonHelpers::AgencyTemplateUploadStatus::PENDING
      end
    end

    context 'when the upload is NOT successful' do
      before do
        allow_any_instance_of(Aws::S3::Object).to receive(:upload_file).with('public/my original filename.xls').and_return(false)
        allow(subject).to receive(:upload_params).and_return(year: 2015, filename: filename)
      end
      it 'expects the user to see a flash message' do
        post :create, agency_template_upload: {year: 2015, filename: 'feef.xls'}, scheme_id: so_marti_director.schemes.first.id
        expect(flash[:alert]).to eq "'my original filename.xls' was not uploaded!"
      end
    end

    context 'when a value is missing' do
      before do
        allow(subject).to receive(:upload_params).and_return(year: nil, filename: filename)
        expect { post :create, agency_template_upload: {year: 2015, filename: 'feef.xsl'}, scheme_id: so_marti_director.schemes.first.id }.not_to change { AgencyTemplateUpload.count }
      end
      it 'responds to be redirect' do
        expect(assigns(:upload).errors[:year].first).to eq "can't be blank"
        expect(assigns(:upload).errors[:year].second).to eq 'is not included in the list'
      end
    end

    context 'when the file extention is invalid' do
      let(:invalid_filename) { double('file', original_filename: 'my original filename.abc', tempfile: double('tempfile', path: 'my temp file.abc')) }

      before do
        allow_any_instance_of(Aws::S3::Object).to receive(:upload_file).with('public/my original filename.abc').and_return(false)
        allow(subject).to receive(:upload_params).and_return(year: 2015, filename: invalid_filename)
      end
      it 'expects the user to see a flash message' do
        post :create, agency_template_upload: {year: 2015, filename: 'feef.abc'}, scheme_id: so_marti_director.schemes.first.id
        expect(flash[:alert]).to eq "ERROR: Unsupported file type!'my original filename.abc'' was not uploaded!"
      end
    end
  end

  describe '#previous_upload_for_year' do
    let(:scheme_id) { so_marti_director.schemes.first.id }
    let(:year) { 2015 }
    let(:params) { {scheme_id: scheme_id, year: year} }

    context 'when a previous upload DOES NOT exist for the year' do
      it 'expects the user is NOT shown a confirmation checkbox' do
        xhr :get, :previous_upload_for_year, params
        expect(assigns(:show_confirmation_field)).to eq false
      end
    end

    context 'when a previous upload DOES exist for the year' do
      xit 'expects the user IS shown a confirmation checkbox' do
        AgencyTemplateUpload.create!(scheme_id:        scheme_id,
                                     year:             year - 1,
                                     uploaded_at:      DateTime.now,
                                     uploaded_by_id:   so_marti_director.id,
                                     uploaded_by_type: SchemeOperator,
                                     filename:         double(original_filename: 'MyFileName'))
        xhr :get, :previous_upload_for_year, params
        expect(assigns(:show_confirmation_field)).to eq true
      end
    end
  end
end
