require 'rails_helper'
RSpec.describe ReportsController, type: :controller do
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
    let(:valid_attributes) { {scheme_id: 1} }

    let(:invalid_attributes) { {scheme_id: 10} }

    # This should return the minimal set of values that should be in the session
    # in order to pass any filters (e.g. authentication) defined in
    # SchemesController. Be sure to keep this updated too.
    let(:valid_session) { {} }

    describe 'GET #index' do
      before do
        get :index, valid_attributes, session: valid_session
      end
      it 'assigns reports as @reports' do
        expect(assigns(:years)).to eq(LookupValues::ValidYears.for('reports'))
      end

      it 'assigns years as @years' do
        expect(assigns(:reports)).to eq(LookupValues::Reports::ValidReports.for('scheme'))
      end

      it 'assigns scheme as @scheme' do
        expect(assigns(:scheme)).to eq(Scheme.find(1))
      end

      it 'assigns scheme as @scheme' do
        expect(assigns(:report_form_data)).to eq([])
      end
    end

    describe 'GET #report_data' do
      context 'when params are valid' do
        before do
          AgencyTemplateUpload.create!(scheme_id:        1,
                                       year:             2014,
                                       uploaded_at:      DateTime.now,
                                       uploaded_by_id:   admin.id,
                                       uploaded_by_type: 'Admin',
                                       filename:         double(original_filename: 'my file'))
          xhr :get, :report_data, {report: 'Registration Form', year: 2015, scheme_id: 1, format: 'js'}, session: valid_session
        end
        it 'assigns a new report_form_data as @report_form_data' do
          expect(assigns(:report_form_data).count).to eq 1
        end

        it 'expects the correct business id' do
          expect(assigns(:report_form_data).first.business_id).to eq 1
        end

        it 'expects the correct business name' do
          expect(assigns(:report_form_data).first.business_name).to eq 'dans pack business'
        end

        it 'expects the correct email value' do
          expect(assigns(:report_form_data).first.email).to eq false
        end

        it 'expects the correct email_contact_present value' do
          expect(assigns(:report_form_data).first.email_contact_present).to eq true
        end

        it 'expects the correct emailed_report value' do
          expect(assigns(:report_form_data).first.emailed_report).to be_nil
        end

        it 'expects no errors' do
          expect(assigns(:errors)).to be_empty
        end
      end

      context 'when data IS present for the previous year' do
        before do
          AgencyTemplateUpload.create!(scheme_id:        1,
                                       year:             2016,
                                       uploaded_at:      DateTime.now,
                                       uploaded_by_id:   admin.id,
                                       uploaded_by_type: 'Admin',
                                       filename:         double(original_filename: 'my file'))
          xhr :get, :report_data, {report: 'Registration Form', year: 2017, scheme_id: 1, format: 'js'}, session: valid_session
        end

        it 'expects no errors' do
          expect(assigns(:errors)).to be_empty
        end

        it 'expects report_form_data is not populated' do
          expect(assigns(:report_form_data).first.business_id).to eq 1
        end
      end

      context 'when NO data present for the previous year' do
        before do
          xhr :get, :report_data, {report: 'Registration Form', year: 2017, scheme_id: 1, format: 'js'}, session: valid_session
        end

        it 'expects an error' do
          expect(assigns(:errors)).to eq(['No data found for year 2016'])
        end

        it 'expects report_form_data is not populated' do
          expect(assigns(:report_form_data)).to eq([])
        end
      end

      context 'when year is not valid' do
        before do
          xhr :get, :report_data, {report: 'Registration Form', year: 1979, scheme_id: 1, format: 'js'}, session: valid_session
        end

        it 'expects an error' do
          expect(assigns(:errors)).to eq(['Select a Year'])
        end

        it 'expects is not populated' do
          expect(assigns(:report_form_data)).to eq([])
        end
      end

      context 'when report is not valid' do
        it 'expects an error' do
          xhr :get, :report_data, {report: 'Dodgy Report', year: 2016, scheme_id: 1, format: 'js'}, session: valid_session
          expect(assigns(:errors)).to eq(['Select a Report', 'No data found for year 2015'])
        end

        it 'expects is not populated' do
          xhr :get, :report_data, {report: 'Dodgy Report', year: 2016, scheme_id: 1, format: 'js'}, session: valid_session
          expect(assigns(:report_form_data)).to eq([])
        end
      end

      describe 'POST #create' do
        context 'with valid params' do
          let(:publisher) { double(publish: true) }
          it 'publishes an email report event' do
            expect(QueueHelpers::RabbitMq::Publisher).to receive(:new).and_return(publisher)
            expect(publisher).to receive(:publish).and_return(true)
            post :create, {scheme_id: 1, report: 'Registration Form', year: 2016, businesses: {'1' => {'email' => '1'}}}, session: valid_session
            expect(flash[:notice]).to eq '1 Registration Form queued to be emailed'
          end
        end
      end
    end
  end
end
