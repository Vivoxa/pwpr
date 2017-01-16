require 'rails_helper'

RSpec.describe SpreadsheetWorker::SheetProcessor::SheetHandlers::LicensorsHandler do
  subject { described_class.new(valid_agency_template.id) }
  let(:speadsheet) { double('RooSheet') }
  let(:valid_row_array) { ['NPWD100815',	'Camerons Brewery Ltd',	'NPWD100815',	'1',	'Angel Inn Thirsk',	'00000000',	'N/A',	'N/A',	'N/A',	'N/A',	'N/A',	'Richard',	'Forster',	'01429 852025',	'richardforster@cameronsbrewery.com',	'Long Street',	'Topcliffe',	'',	'Thirsk',	'YO7 3RW'] }
  let(:valid_business) { Business.new(id: 1) }
  let(:invalid_business) { Business.new }
  let(:valid_agency_template) { AgencyTemplateUpload.new(id: 1) }
  let(:invalid_agency_template) { AgencyTemplateUpload.new }
  let(:server_file_path) { double('server/file/test.xls')}
  let(:filename) { 'test.xls' }
  let(:licensor) { subject.instance_variable_get(:@licensor) }
  let(:contact) { subject.instance_variable_get(:@contact) }
  let(:address_type) { AddressType.new(id: 1) }

  before do
    allow(InputOutput::ServerFileHandler).to receive(:server_file_path_for).and_return server_file_path
    allow(valid_agency_template).to receive(:filename).and_return filename
    allow(invalid_agency_template).to receive(:filename).and_return filename
    allow(Roo::Spreadsheet).to receive(:open).and_return speadsheet
    allow(AddressType).to receive(:where).and_return [address_type]
    allow(valid_business.addresses).to receive(:where).and_return []
    allow_any_instance_of(Contact).to receive(:save!).and_return true
    allow(Contact).to receive(:where).and_return []
    allow_any_instance_of(Address).to receive(:save!).and_return true
    allow(Address).to receive(:where).and_return []
    allow_any_instance_of(Licensor).to receive(:save!).and_return true
  end

  describe '#process' do
    context 'when object fields are valid' do
      before do
        allow(Business).to receive(:where).and_return [valid_business]
        allow(AgencyTemplateUpload).to receive(:find_by_id).and_return valid_agency_template
        allow(speadsheet).to receive_message_chain(:sheet, :drop).and_return [valid_row_array]
        subject.process
      end

      context 'licensor' do
        it 'sets the business on the object' do
          expect(licensor.business).to eq valid_business
        end

        it 'sets the agency_template_upload on the object' do
          expect(licensor.agency_template_upload).to eq valid_agency_template
        end

        it 'creates a valid object' do
          expect(licensor).to be_valid
        end
      end

      context 'contact object' do
        before do
          subject.process
        end

        it 'sets the first_name on the object' do
          expect(contact.first_name).to eq 'Richard'
        end

        it 'sets the last_name on the object' do
          expect(contact.last_name).to eq 'Forster'
        end

        it 'sets the email on the object' do
          expect(contact.email).to eq 'richardforster@cameronsbrewery.com'
        end

        it 'sets the telephone_1 on the object' do
          expect(contact.telephone_1).to eq '01429 852025'
        end

        it 'sets the business on the object' do
          expect(contact.business).to eq valid_business
        end

        it 'creates a valid object' do
          expect(contact).to be_valid
        end
      end
    end

    context 'when object fields are invalid' do
      before do
        allow(Business).to receive(:where).and_return [invalid_business]
        allow(invalid_business.addresses).to receive(:where).and_return []
        allow(AgencyTemplateUpload).to receive(:find_by_id).and_return invalid_agency_template
        allow(speadsheet).to receive_message_chain(:sheet, :drop).and_return [valid_row_array]
        subject.process
      end

      it 'creates a invalid object' do
        expect(licensor).to be_invalid
      end
    end
  end
end
