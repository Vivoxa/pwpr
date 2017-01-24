require 'rails_helper'

RSpec.describe SpreadsheetWorker::SheetProcessor::SheetHandlers::TargetsHandler do
  subject { described_class.new(valid_agency_template.id) }
  let(:speadsheet) { double('RooSheet') }
  let(:valid_row_array) {['004',	'NPWD107133',	'G I Hadfield & Son Ltd',	'0',	'0',	'0',	'0',	'42',	'1',	'0',	'43',
                          '66',	'66',	'71',	'71',	'0',	'0',	'0',	'0',	'0',	'0',	'0',	'0',	'0',	'0',	'0',	'0',
                          '0',	'0',	'0',	'0',	'0',	'0',	'0',	'0',	'0',	'0',	'0',	'0',	'0',	'0',	'0',	'0',
                          '0',	'0',	'0',	'0',	'0',	'0',	'0',	'0',	'0',	'0',	'0',	'0',	'0',	'0',	'0',	'0',
                          '0',	'0',	'0',	'0',	'0',	'0',	'0',	'0',	'0',	'0',	'0',	'0',	'0',	'0',	'0',	'0',
                          '0',	'0',	'0',	'0',	'0',	'0',	'0',	'0',	'0',	'0',	'101',	'68',	'0',	'0',	'0',	'0',
                          '0',	'0',	'0',	'0',	'0',	'101',	'0',	'1',	'0',	'0',	'0',	'0',	'0',	'0',	'0',	'0',
                          '0',	'0',	'0',	'0',	'0',	'0',	'0',	'0',	'5',	'0',	'0',	'0',	'0',	'0',	'0',	'0',
                          '0',	'0',	'0',	'0',	'0',	'0',	'0',	'0',	'0',	'0',	'0'
                        ]}
  let(:valid_business) { Business.new(id: 1) }
  let(:regular_producer) { RegularProducerDetail.new(id: 1) }
  let(:registration) { Registration.new(id: 1) }
  let(:packaging_material) { PackagingMaterial.new(id: 1) }
  let(:new_business) { Business.new(id: 2) }
  let(:invalid_business) { Business.new }
  let(:valid_agency_template) { AgencyTemplateUpload.new(id: 1) }
  let(:server_file_path) { double('server/file/test.xls')}
  let(:filename) { 'test.xls' }
  let(:target) { subject.instance_variable_get(:@target) }
  let(:material_detail) { MaterialDetail.new }
  let(:material_total) { MaterialTotal.new }
  let(:target_total) { TargetTotal.new }

  before do
    allow(InputOutput::ServerFileHandler).to receive(:server_file_path_for).and_return server_file_path
    allow(valid_agency_template).to receive(:filename).and_return filename
    allow(Roo::Spreadsheet).to receive(:open).and_return speadsheet
    allow_any_instance_of(MaterialDetail).to receive(:save!).and_return true
    allow(MaterialDetail).to receive(:new).and_return material_detail
    allow_any_instance_of(MaterialTotal).to receive(:save!).and_return true
    allow(MaterialTotal).to receive(:new).and_return material_total
    allow_any_instance_of(TargetTotal).to receive(:save!).and_return true
    allow(TargetTotal).to receive(:new).and_return target_total
    allow_any_instance_of(Business).to receive(:registrations).and_return [registration]
    allow(registration).to receive(:regular_producer_detail).and_return regular_producer
    allow(PackagingMaterial).to receive(:where).and_return [packaging_material]
  end

  describe '#process' do
    context 'when object fields are valid' do
      before do
        allow(Business).to receive(:where).and_return [valid_business]
        allow(AgencyTemplateUpload).to receive(:find_by_id).and_return valid_agency_template
        allow(speadsheet).to receive_message_chain(:sheet, :drop).and_return [valid_row_array]
        subject.process
      end

      it 'creates a valid material_detail object' do
        expect(material_detail).to be_valid
      end

      it 'creates a valid material_total object' do
        expect(material_total).to be_valid
      end

      it 'creates a valid target_total object' do
        expect(target_total).to be_valid
      end
    end
  end
end
