require 'rails_helper'

RSpec.describe SpreadsheetWorker::SheetProcessor::SheetHandlers::SubsidiariesHandler do
  subject { described_class.new(valid_agency_template.id) }
  let(:speadsheet) { double('RooSheet') }
  let(:valid_row_array) {['',	'161',	'NPWD302870',	'Ulysses Leisure Ltd',	'161/3',	'NPWD210566',	'Sheridan Nightclubs Limited',
                          'NI043767',	'56.30/1',	'Unit 1 Odyssey Pavillion',	"2 Queen's Quay",	'',	'',	'Belfast',	'BT3 9QQ',
                          'Northern Ireland',	'2.05',	'Selling',	'N',	'',	'',	'Unit 2 Hadrian House',	'Beaminster Way East',
                          '',	'',	'Newcastle Upon Tyne',	'NE3 2ER',	'07894 388 923',	'garymx5@gmail.com',	'Gary',
                          'Abernethy',	'Mr'
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
  let(:subsidiary) { subject.instance_variable_get(:@subsidiary) }

  before do
    allow(InputOutput::ServerFileHandler).to receive(:server_file_path_for).and_return server_file_path
    allow(valid_agency_template).to receive(:filename).and_return filename
    allow(invalid_agency_template).to receive(:filename).and_return filename
    allow(Roo::Spreadsheet).to receive(:open).and_return speadsheet
    allow_any_instance_of(Subsidiary).to receive(:save!).and_return true
    allow_any_instance_of(Business).to receive(:save!).and_return true
    allow_any_instance_of(Contact).to receive(:save!).and_return true
    allow_any_instance_of(Address).to receive(:save!).and_return true
    allow_any_instance_of(SmallProducerDetail).to receive(:save!).and_return true
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
          expect(subsidiary.business).to eq valid_business
        end

        it 'creates a valid object' do
          expect(subsidiary).to be_valid
        end
      end

      context 'business is not found' do
        before do
          allow(Business).to receive(:where).and_return []
          subject.process
        end

        it 'sets the agency_template_upload on the object' do
          expect(subsidiary.agency_template_upload).to eq valid_agency_template
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
        expect(subsidiary).to be_invalid
      end
    end
  end
end
