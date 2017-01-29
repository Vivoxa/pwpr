require 'rails_helper'

RSpec.describe SpreadsheetWorker::SheetProcessor::SheetHandlers::JoinersHandler do
  subject { described_class.new(valid_agency_template.id) }
  let(:speadsheet) { double('RooSheet') }
  let(:valid_row_array) { ['157', 'NPWD123', 'pwpr ltd',	'12345',	'0',	'N',	'101',	'not previously registered',	'01/02/2015',	'01-Apr-16', ''] }
  let(:invalid_row_array) { ['157', 'NPWD123', 'pwpr ltd',	'12345',	'0',	'N',	'number',	'not previously registered',	'',	'date', ''] }
  let(:valid_business) { Business.new(id: 1) }
  let(:new_business) { Business.new(id: 2) }
  let(:invalid_business) { Business.new }
  let(:valid_agency_template) { AgencyTemplateUpload.new(id: 1) }
  let(:invalid_agency_template) { AgencyTemplateUpload.new }
  let(:server_file_path) { double('server/file/test.xls') }
  let(:filename) { 'test.xls' }
  let(:joiner) { subject.instance_variable_get(:@joiner) }

  before do
    allow(InputOutput::ServerFileHandler).to receive(:server_file_path_for).and_return server_file_path
    allow(valid_agency_template).to receive(:filename).and_return filename
    allow(invalid_agency_template).to receive(:filename).and_return filename
    allow(Roo::Spreadsheet).to receive(:open).and_return speadsheet
    allow_any_instance_of(Joiner).to receive(:save!).and_return true
  end

  describe '#process' do
    context 'when object fields are valid' do
      before do
        allow(Business).to receive(:where).and_return [valid_business]
        allow(AgencyTemplateUpload).to receive(:find_by_id).and_return valid_agency_template
        allow(speadsheet).to receive_message_chain(:sheet, :drop).and_return [valid_row_array]
        subject.process
      end

      it 'sets the total_recovery on the object' do
        expect(joiner.total_recovery).to eq '101'.to_f
      end

      it 'sets the previously_registered_at on the object' do
        expect(joiner.previously_registered_at).to eq 'not previously registered'
      end

      it 'sets the joining_date on the object' do
        expect(joiner.joining_date).to eq Date.parse('01/02/2015')
      end

      it 'sets the date_scheme_registered on the object' do
        expect(joiner.date_scheme_registered).to eq Date.parse('01-Apr-16')
      end

      it 'sets the business on the object' do
        expect(joiner.business).to eq valid_business
      end

      it 'sets the agency_template_upload on the object' do
        expect(joiner.agency_template_upload).to eq valid_agency_template
      end

      it 'creates a valid object' do
        expect(joiner).to be_valid
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
        expect(joiner).to be_invalid
      end
    end

    context 'when row is invalid' do
      before do
        allow(Business).to receive(:where).and_return [valid_business]
        allow(AgencyTemplateUpload).to receive(:find_by_id).and_return valid_agency_template
        allow(speadsheet).to receive_message_chain(:sheet, :drop).and_return [invalid_row_array]
      end

      it 'raises Error' do
        expect { subject.process }.to raise_error ArgumentError
      end
    end
  end
end
