require 'rails_helper'

RSpec.describe SpreadsheetWorker::SheetProcessor::SheetHandlers::RegistrationsHandler do
  subject { described_class.new(valid_agency_template.id) }
  let(:speadsheet) { double('RooSheet') }
  let(:valid_row_array) {[
                          '', '',	'056',	'NPWD106683',	'Peter Hogarth & Sons Ltd',	'Individual Co',	'N/A',	'01143352',	'36 High Street',
                          'Cleethorpes', '',	'',	'South Humberside',	'DN35 8JN',	'England', '',	'',	'',	'47.52',	'SELLING',	'2.80',	'N',
                          'Y',	'84',	'Paper',	'',	'',	'',	'',	'',	'',	'',	'', '',	'Estate Road Number 5',	'South Humberside Industrial Estate',
                          '',	'',	'Grimsby',	'DN31 2UR',	'01472 345726',	'01472 250272',	'ian.hogarth@peterhogarth.co.uk',	'Ian',	'Hogarth',
                          'Mr',	'Estate Road Number 5',	'South Humberside Industrial Estate',	'',	'',	'Grimsby',	'DN31 2UR',	'England',
                          '01472 345726'
                        ]}
  let(:invalid_row_array) {[
                          '', '',	'056',	'NPWD106683',	'Peter Hogarth & Sons Ltd',	'Individual Co',	'N/A',	'01143352',	'36 High Street',
                          'Cleethorpes', '',	'',	'South Humberside',	'DN35 8JN',	'England', '',	'',	'',	'47.52',	'SELLING',	'2.80',	'N',
                          'Y',	'84',	'Paper',	'',	'',	'',	'',	'',	'',	'',	'', '',	'Estate Road Number 5',	'South Humberside Industrial Estate',
                          '',	'',	'Grimsby',	'DN31 2UR',	'01472 345726',	'01472 250272',	'ian.hogarth@peterhogarth.co.uk',	'Ian',	'Hogarth',
                          'Mr',	'Estate Road Number 5',	'South Humberside Industrial Estate',	'',	'',	'Grimsby',	'DN31 2UR',	'England',
                          '01472 345726'
                        ]}
  let(:valid_business) { Business.new(id: 1, sic_code: sic_code) }
  let(:new_business) { Business.new(id: 2, sic_code: sic_code) }
  let(:sic_code) { SicCode.new(id: 1) }
  let(:packaging_sector) { PackagingSectorMainActivity.new(id: 1) }
  let(:invalid_business) { Business.new }
  let(:valid_agency_template) { AgencyTemplateUpload.new(id: 1) }
  let(:invalid_agency_template) { AgencyTemplateUpload.new }
  let(:server_file_path) { double('server/file/test.xls')}
  let(:filename) { 'test.xls' }
  let(:registration) { subject.instance_variable_get(:@registration) }

  before do
    allow(InputOutput::ServerFileHandler).to receive(:server_file_path_for).and_return server_file_path
    allow(valid_agency_template).to receive(:filename).and_return filename
    allow(invalid_agency_template).to receive(:filename).and_return filename
    allow(Roo::Spreadsheet).to receive(:open).and_return speadsheet
    allow_any_instance_of(Registration).to receive(:save!).and_return true
    allow_any_instance_of(Business).to receive(:save!).and_return true
    allow_any_instance_of(Contact).to receive(:save!).and_return true
    allow_any_instance_of(Address).to receive(:save!).and_return true
    allow_any_instance_of(SmallProducerDetail).to receive(:save!).and_return true
    allow_any_instance_of(RegularProducerDetail).to receive(:save!).and_return true
    allow(AddressType).to receive(:id_from_setting).with('Correspondence').and_return 1
    allow(AddressType).to receive(:id_from_setting).with('Audit').and_return 2
    allow(AddressType).to receive(:id_from_setting).with('Registered').and_return 3
    allow(AddressType).to receive(:id_from_setting).with('Contact').and_return 4
  end

  describe '#process' do
    context 'when object fields are valid' do
      before do
        allow(Business).to receive(:where).and_return [valid_business]
        allow(AgencyTemplateUpload).to receive(:find_by_id).and_return valid_agency_template
        allow(speadsheet).to receive_message_chain(:sheet, :drop).and_return [valid_row_array]
        allow(new_business).to receive(:sic_code).and_return sic_code
        allow(PackagingSectorMainActivity).to receive(:where).and_return [packaging_sector]
        subject.process
      end

      context 'business is found' do
        it 'sets the business on the object' do
          expect(registration.business).to eq valid_business
        end

        it 'creates a valid object' do
          expect(registration).to be_valid
        end
      end

      context 'business is not found' do
        before do
          allow(Business).to receive(:where).and_return []
          subject.process
        end

        it 'sets the agency_template_upload on the object' do
          expect(registration.agency_template_upload).to eq valid_agency_template
        end
      end
    end

    context 'when object fields are invalid' do
      before do
        allow(Business).to receive(:where).and_return []
        allow(AgencyTemplateUpload).to receive(:find_by_id).and_return invalid_agency_template
        allow(speadsheet).to receive_message_chain(:sheet, :drop).and_return [valid_row_array]
        subject.process
      end

      it 'creates a invalid object' do
        expect(registration).to be_invalid
      end
    end
  end
end
