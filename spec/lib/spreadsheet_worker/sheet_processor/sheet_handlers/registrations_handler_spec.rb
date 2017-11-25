require 'rails_helper'

RSpec.describe SpreadsheetWorker::SheetProcessor::SheetHandlers::RegistrationsHandler do
  subject { described_class.new(valid_agency_template.id) }
  let(:speadsheet) { double('RooSheet') }
  let(:valid_row_array) do
    [
      '', '',	'056',	'NPWD106683',	'Peter Hogarth & Sons Ltd',	'Individual Co',	'N/A',	'01143352',	'36 High Street',
      'Cleethorpes', '',	'',	'South Humberside',	'DN35 8JN',	'England', '',	'',	'',	'47.52',	'SELLING',	'2.80',	'N',
      'Y',	'84',	'Paper',	'Y',	'Y',	'Y',	'N',	'',	'Y',	'',	'N', '',	'Estate Road Number 5',	'South Humberside Industrial Estate',
      '',	'',	'Grimsby',	'DN31 2UR',	'01472 345726',	'01472 250272',	'ian.hogarth@peterhogarth.co.uk',	'Ian',	'Hogarth',
      'Mr',	'Estate Road Number 5',	'South Humberside Industrial Estate',	'',	'',	'Grimsby',	'DN31 2UR',	'England',
      '01472 345726'
    ]
  end
  let(:valid_row_array2) do
    [
      '', '',	'056',	'NPWD106683',	'Peter Hogarth & Sons Ltd',	'Individual Co',	'N/A',	'01143352',	'36 High Street',
      'Cleethorpes', '',	'',	'South Humberside',	'DN35 8JN',	'England', '',	'',	'',	'47.52',	'SELLING',	'2.80',	'N',
      'N',	'84',	'Paper',	'Y',	'Y',	'Y',	'N',	'',	'Y',	'',	'N', '',	'Estate Road Number 5',	'South Humberside Industrial Estate',
      '',	'',	'Grimsby',	'DN31 2UR',	'01472 345726',	'01472 250272',	'ian.hogarth@peterhogarth.co.uk',	'Ian',	'Hogarth',
      'Mr',	'Estate Road Number 5',	'South Humberside Industrial Estate',	'',	'',	'Grimsby',	'DN31 2UR',	'England',
      '01472 345726'
    ]
  end
  let(:empty_row) { [] }
  let(:valid_business) { Business.new(id: 1, sic_code: sic_code) }
  let(:sic_code) { SicCode.new(id: 1) }
  let(:packaging_sector) { PackagingSectorMainActivity.new(id: 1) }
  let(:valid_agency_template) { AgencyTemplateUpload.new(id: 1) }
  let(:server_file_path) { double('server/file/test.xls') }
  let(:filename) { 'test.xls' }
  let(:registration) { subject.instance_variable_get(:@registration) }
  let(:audit_address) { Address.new(id: 2) }
  let(:correspondence_address) { Address.new(id: 1) }
  let(:registered_address) { Address.new(id: 3) }
  let(:contact_address) { Address.new(id: 4) }
  let(:address_type) { AddressType.new(id: 1) }
  let(:contacts_addresses) { ContactsAddresses.new(id: 1, contact_id: 1) }
  let(:contact) { subject.instance_variable_get(:@contact) }
  let(:small_producer) { SmallProducerDetail.new(id: 1) }
  let(:regular_producer) { RegularProducerDetail.new(id: 1) }

  before do
    allow(InputOutput::ServerFileHandler).to receive(:server_file_path_for).and_return server_file_path
    allow(valid_agency_template).to receive(:filename).and_return filename
    allow(Roo::Spreadsheet).to receive(:open).and_return speadsheet
    allow_any_instance_of(Registration).to receive(:save!).and_return true
    allow_any_instance_of(Business).to receive(:save!).and_return true
    allow_any_instance_of(Contact).to receive(:save!).and_return true
    allow_any_instance_of(Address).to receive(:save!).and_return true
    allow_any_instance_of(SmallProducerDetail).to receive(:save!).and_return true
    allow_any_instance_of(RegularProducerDetail).to receive(:save!).and_return true
    allow(AddressType).to receive(:where).with(title: 'Correspondence').and_return [address_type]
    allow(AddressType).to receive(:id_from_setting).with('Correspondence').and_return 1
    allow(AddressType).to receive(:where).with(title: 'Audit').and_return [address_type]
    allow(AddressType).to receive(:id_from_setting).with('Audit').and_return 2
    allow(AddressType).to receive(:where).with(title: 'Registered').and_return [address_type]
    allow(AddressType).to receive(:id_from_setting).with('Registered').and_return 3
    allow(AddressType).to receive(:where).with(title: 'Contact').and_return [address_type]
    allow(AddressType).to receive(:id_from_setting).with('Contact').and_return 4
  end

  describe '#process' do
    before do
      allow(Business).to receive(:where).and_return [valid_business]
      allow(AgencyTemplateUpload).to receive(:find_by_id).and_return valid_agency_template
      allow(speadsheet).to receive_message_chain(:sheet, :drop).and_return [valid_row_array]
      allow(PackagingSectorMainActivity).to receive(:where).and_return [packaging_sector]
      allow(valid_business.addresses).to receive(:where).and_return []
      subject.process
    end

    context 'when empty row' do
      before do
        allow(speadsheet).to receive_message_chain(:sheet, :drop).and_return [empty_row]
      end

      it 'skips the row' do
        expect(Registration).not_to receive(:new)
      end
    end

    context 'when object fields are valid' do
      context 'business is found' do
        it 'sets the business on the object' do
          expect(registration.business).to eq valid_business
        end

        context 'when address exists' do
          before do
            allow(valid_business.addresses).to receive(:where).and_return [1]
          end

          it 'return early' do
            expect(Address).not_to receive(:new)
          end
        end

        context 'creates audit address' do
          before do
            allow(Address).to receive(:new).and_return audit_address
            subject.process
          end

          it 'has correct address_line_1' do
            expect(audit_address.address_line_1).to eq 'Estate Road Number 5'
          end

          it 'has correct address_line_2' do
            expect(audit_address.address_line_2).to eq 'South Humberside Industrial Estate'
          end

          it 'has correct address_line_3' do
            expect(audit_address.address_line_3).to eq ''
          end

          it 'has correct address_line_4' do
            expect(audit_address.address_line_4).to eq ''
          end

          it 'has correct town' do
            expect(audit_address.town).to eq 'Grimsby'
          end

          it 'has correct post_code' do
            expect(audit_address.post_code).to eq 'DN31 2UR'
          end

          it 'has correct site_country' do
            expect(audit_address.site_country).to eq 'England'
          end

          it 'has correct address_type' do
            expect(audit_address.address_type).to eq address_type
          end

          it 'has correct business' do
            expect(audit_address.business).to eq valid_business
          end

          it 'object is valid' do
            audit_address.contacts_addresses.first.contact_id = 1
            expect(audit_address).to be_valid
          end
        end

        context 'creates correspondence address' do
          before do
            allow(Address).to receive(:new).and_return correspondence_address
            subject.process
          end

          it 'has correct address_line_1' do
            expect(correspondence_address.address_line_1).to eq 'Estate Road Number 5'
          end

          it 'has correct address_line_2' do
            expect(correspondence_address.address_line_2).to eq 'South Humberside Industrial Estate'
          end

          it 'has correct address_line_3' do
            expect(correspondence_address.address_line_3).to eq ''
          end

          it 'has correct address_line_4' do
            expect(correspondence_address.address_line_4).to eq ''
          end

          it 'has correct town' do
            expect(correspondence_address.town).to eq 'Grimsby'
          end

          it 'has correct post_code' do
            expect(correspondence_address.post_code).to eq 'DN31 2UR'
          end

          it 'has correct site_country' do
            expect(correspondence_address.site_country).to eq 'England'
          end

          it 'has correct address_type' do
            expect(correspondence_address.address_type).to eq address_type
          end

          it 'has correct business' do
            expect(correspondence_address.business).to eq valid_business
          end

          it 'has correct contact' do
            expect(correspondence_address.contacts).to include contact
          end

          it 'object is valid' do
            correspondence_address.contacts_addresses.last.contact_id = 1
            expect(correspondence_address).to be_valid
          end
        end

        context 'creates registered address' do
          before do
            allow(Address).to receive(:new).and_return registered_address
            subject.process
          end

          it 'has correct address_line_1' do
            expect(registered_address.address_line_1).to eq 'Estate Road Number 5'
          end

          it 'has correct address_line_2' do
            expect(registered_address.address_line_2).to eq 'South Humberside Industrial Estate'
          end

          it 'has correct address_line_3' do
            expect(registered_address.address_line_3).to eq ''
          end

          it 'has correct address_line_4' do
            expect(registered_address.address_line_4).to eq ''
          end

          it 'has correct town' do
            expect(registered_address.town).to eq 'Grimsby'
          end

          it 'has correct post_code' do
            expect(registered_address.post_code).to eq 'DN31 2UR'
          end

          it 'has correct site_country' do
            expect(registered_address.site_country).to eq 'England'
          end

          it 'has correct address_type' do
            expect(registered_address.address_type).to eq address_type
          end

          it 'has correct business' do
            expect(registered_address.business).to eq valid_business
          end

          it 'object is valid' do
            registered_address.contacts_addresses.last.contact_id = 1
            expect(registered_address).to be_valid
          end
        end

        context 'creates contact' do
          it 'sets the correct title' do
            expect(contact.title).to eq 'Mr'
          end

          it 'sets the correct first_name' do
            expect(contact.first_name).to eq 'Ian'
          end

          it 'sets the correct last_name' do
            expect(contact.last_name).to eq 'Hogarth'
          end

          it 'sets the correct telephone_1' do
            expect(contact.telephone_1).to eq '01472 345726'
          end

          it 'sets the correct fax' do
            expect(contact.fax).to eq '01472 250272'
          end

          it 'sets the correct business' do
            expect(contact.business).to eq valid_business
          end

          it 'sets the correct address_type_id' do
            expect(contact.address_type_id).to eq address_type.id
          end

          it 'sets the correct email' do
            expect(contact.email).to eq 'ian.hogarth@peterhogarth.co.uk'
          end

          it 'creates a valid object' do
            expect(contact).to be_valid
          end
        end

        context 'creates small_producer' do
          before do
            allow(SmallProducerDetail).to receive(:new).and_return small_producer
            subject.process
          end

          it 'sets the allocation_method_obligation' do
            expect(small_producer.allocation_method_obligation).to eq '84'.to_i
          end

          it 'sets the allocation_method_obligation' do
            expect(small_producer.allocation_method_predominant_material).to eq 'Paper'
          end

          it 'creates a valid object' do
            small_producer.registration = Registration.new(id: 1)
            expect(small_producer).to be_valid
          end
        end

        context 'creates regular_producer' do
          before do
            allow(RegularProducerDetail).to receive(:new).and_return regular_producer
            allow(speadsheet).to receive_message_chain(:sheet, :drop).and_return [valid_row_array2]
            subject.process
          end

          it 'sets the calculation_method_supplier_data' do
            expect(regular_producer.calculation_method_supplier_data).to eq true
          end

          it 'sets the calculation_method_sample_weighing' do
            expect(regular_producer.calculation_method_sample_weighing).to eq true
          end

          it 'sets the calculation_method_sales_records' do
            expect(regular_producer.calculation_method_sales_records).to eq true
          end

          xit 'sets the calculation_method_trade_association_method_details' do
            expect(regular_producer.calculation_method_trade_association_method_details).to eq false
          end

          it 'sets the data_system_used' do
            expect(regular_producer.data_system_used).to eq ''
          end

          # Needs deeper investigation on spec data provided
          it 'sets the other_method_details' do
            expect(regular_producer.other_method_details).to eq ''
          end

          it 'creates a valid object' do
            regular_producer.registration = Registration.new(id: 1)
            expect(regular_producer).to be_valid
          end
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
  end
end
