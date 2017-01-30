require 'rails_helper'

RSpec.describe SpreadsheetWorker::SheetProcessor::SheetHandlers::SubleaversHandler do
  subject { described_class.new(valid_agency_template.id) }
  let(:speadsheet) { double('RooSheet') }
  let(:valid_row_array) { ['020/2',	'NPWD174946',	'Samuel Grant (Sheffield) Ltd',	'01784435',	'N',	'J',	'31-Dec-15',	'become subsidiary of Samuel Grant Group Ltd'] }
  let(:invalid_row_array) { ['020/2',	'NPWD174946',	'Samuel Grant (Sheffield) Ltd',	'01784435',	'N',	'J',	'',	'become subsidiary of Samuel Grant Group Ltd'] }
  let(:valid_business) { Business.new(id: 1) }
  let(:new_business) { Business.new(id: 2) }
  let(:invalid_business) { Business.new }
  let(:valid_agency_template) { AgencyTemplateUpload.new(id: 1) }
  let(:invalid_agency_template) { AgencyTemplateUpload.new }
  let(:server_file_path) { double('server/file/test.xls') }
  let(:filename) { 'test.xls' }
  let(:subleaver) { subject.instance_variable_get(:@subleaver) }
  let(:leaving_code) { LeavingCode.new(id: 1) }

  before do
    allow(InputOutput::ServerFileHandler).to receive(:server_file_path_for).and_return server_file_path
    allow(valid_agency_template).to receive(:filename).and_return filename
    allow(invalid_agency_template).to receive(:filename).and_return filename
    allow(Roo::Spreadsheet).to receive(:open).and_return speadsheet
    allow(LeavingCode).to receive(:where).and_return [leaving_code]
    allow_any_instance_of(Leaver).to receive(:save!).and_return true
  end

  describe '#process' do
    context 'when object fields are valid' do
      before do
        allow(Business).to receive(:where).and_return [valid_business]
        allow(AgencyTemplateUpload).to receive(:find_by_id).and_return valid_agency_template
        allow(speadsheet).to receive_message_chain(:sheet, :drop).and_return [valid_row_array]
        subject.process
      end

      context 'business is found' do
        it 'sets the leaving_date on the object' do
          expect(subleaver.leaving_date).to eq Date.parse('31-Dec-15')
        end

        it 'sets the leaving_code on the object' do
          expect(subleaver.leaving_code).to eq leaving_code
        end

        it 'sets the scheme_comments on the object' do
          expect(subleaver.scheme_comments).to eq 'become subsidiary of Samuel Grant Group Ltd'
        end

        it 'sets the business on the object' do
          expect(subleaver.business).to eq valid_business
        end

        it 'creates a valid object' do
          expect(subleaver).to be_valid
        end
      end

      context 'business is not found' do
        before do
          allow(Business).to receive(:where).and_return []
          subject.process
        end

        it 'sets the agency_template_upload on the object' do
          expect(subleaver.agency_template_upload).to eq valid_agency_template
        end

        it 'sets the scheme_ref on the object' do
          expect(subleaver.leaving_business.scheme_ref).to eq '020/2'
        end

        it 'sets the npwd on the object' do
          expect(subleaver.leaving_business.npwd).to eq 'NPWD174946'
        end

        it 'sets the company_name on the object' do
          expect(subleaver.leaving_business.company_name).to eq 'Samuel Grant (Sheffield) Ltd'
        end

        it 'sets the company_number on the object' do
          expect(subleaver.leaving_business.company_number).to eq '01784435'
        end

        it 'creates a valid object' do
          expect(subleaver.leaving_business).to be_valid
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
        expect(subleaver).to be_invalid
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
