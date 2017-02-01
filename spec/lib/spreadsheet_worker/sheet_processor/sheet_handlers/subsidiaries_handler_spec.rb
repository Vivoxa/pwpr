require 'rails_helper'

RSpec.describe SpreadsheetWorker::SheetProcessor::SheetHandlers::SubsidiariesHandler do
  subject { described_class.new(valid_agency_template.id) }
  let(:speadsheet) { double('RooSheet') }
  let(:valid_row_array) do
    ['',	'161',	'NPWD302870',	'Ulysses Leisure Ltd',	'161/3',	'NPWD210566',	'Sheridan Nightclubs Limited',
     'NI043767',	'56.30/1',	'Unit 1 Odyssey Pavillion',	"2 Queen's Quay",	'',	'',	'Belfast',	'BT3 9QQ',
     'Northern Ireland',	'2.05',	'Selling',	'Y',	'Paper',	'122',	'Unit 2 Hadrian House',	'Beaminster Way East',
     '',	'',	'Newcastle Upon Tyne',	'NE3 2ER',	'07894 388 923',	'garymx5@gmail.com',	'Gary',
     'Abernethy',	'Mr']
  end
  let(:valid_business) { Business.new(id: 1, sic_code: sic_code) }
  let(:sic_code) { SicCode.new(id: 1) }
  let(:packaging_sector) { PackagingSectorMainActivity.new(id: 1) }
  let(:valid_agency_template) { AgencyTemplateUpload.new(id: 1) }
  let(:server_file_path) { double('server/file/test.xls') }
  let(:filename) { 'test.xls' }
  let(:subsidiary) { subject.instance_variable_get(:@subsidiary) }
  let(:registration) { Registration.new(id: 1) }
  let(:audit_address) { Address.new(id: 2) }
  let(:correspondence_address) { Address.new(id: 1) }
  let(:registered_address) { Address.new(id: 3) }
  let(:contact_address) { Address.new(id: 4) }
  let(:address_type) { AddressType.new(id: 1) }
  let(:contacts_addresses) { ContactsAddresses.new(id: 1, contact_id: 1) }
  let(:contact) { subject.instance_variable_get(:@contact) }
  let(:small_producer) { SmallProducerDetail.new(id: 1) }
  let(:change_detail) { ChangeDetail.new(id: 1) }

  before do
    allow(InputOutput::ServerFileHandler).to receive(:server_file_path_for).and_return server_file_path
    allow(valid_agency_template).to receive(:filename).and_return filename
    allow(Roo::Spreadsheet).to receive(:open).and_return speadsheet
    allow_any_instance_of(Subsidiary).to receive(:save!).and_return true
    allow_any_instance_of(Business).to receive(:save!).and_return true
    allow_any_instance_of(Contact).to receive(:save!).and_return true
    allow_any_instance_of(Address).to receive(:save!).and_return true
    allow_any_instance_of(SmallProducerDetail).to receive(:save!).and_return true
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
    context 'when object fields are valid' do
      before do
        allow(Business).to receive(:where).and_return [valid_business]
        allow_any_instance_of(Registration).to receive(:save!).and_return true
        allow(AgencyTemplateUpload).to receive(:find_by_id).and_return valid_agency_template
        allow(speadsheet).to receive_message_chain(:sheet, :drop).and_return [valid_row_array]
        allow(PackagingSectorMainActivity).to receive(:where).and_return [packaging_sector]
        allow(ChangeDetail).to receive(:where).and_return [change_detail]
        allow(Registration).to receive(:new).and_return registration
        subject.process
      end

      context 'business is found' do
        it 'sets the business on the object' do
          expect(subsidiary.allocation_method_used).to eq true
        end

        it 'sets the change_detail on the object' do
          expect(subsidiary.change_detail).to eq change_detail
        end

        it 'sets the business on the object' do
          expect(subsidiary.packaging_sector_main_activity).to eq packaging_sector
        end

        it 'sets the business on the object' do
          expect(subsidiary.business).to eq valid_business
        end

        it 'sets the business on the object' do
          expect(subsidiary.agency_template_upload).to eq valid_agency_template
        end

        context 'when address exists' do
          before do
            allow(valid_business.addresses).to receive(:where).and_return [1]
          end

          it 'return early' do
            expect(Address).not_to receive(:new)
          end
        end

        context 'creates correspondence address' do
          before do
            allow(Address).to receive(:new).and_return correspondence_address
            subject.process
          end

          it 'has correct address_line_1' do
            expect(correspondence_address.address_line_1).to eq 'Unit 2 Hadrian House'
          end

          it 'has correct address_line_2' do
            expect(correspondence_address.address_line_2).to eq 'Beaminster Way East'
          end

          it 'has correct address_line_3' do
            expect(correspondence_address.address_line_3).to eq ''
          end

          it 'has correct address_line_4' do
            expect(correspondence_address.address_line_4).to eq ''
          end

          it 'has correct town' do
            expect(correspondence_address.town).to eq 'Newcastle Upon Tyne'
          end

          it 'has correct post_code' do
            expect(correspondence_address.post_code).to eq 'NE3 2ER'
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
            expect(registered_address.address_line_1).to eq 'Unit 2 Hadrian House'
          end

          it 'has correct address_line_2' do
            expect(registered_address.address_line_2).to eq 'Beaminster Way East'
          end

          it 'has correct address_line_3' do
            expect(registered_address.address_line_3).to eq ''
          end

          it 'has correct address_line_4' do
            expect(registered_address.address_line_4).to eq ''
          end

          it 'has correct town' do
            expect(registered_address.town).to eq 'Newcastle Upon Tyne'
          end

          it 'has correct post_code' do
            expect(registered_address.post_code).to eq 'NE3 2ER'
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
            expect(contact.first_name).to eq 'Gary'
          end

          it 'sets the correct last_name' do
            expect(contact.last_name).to eq 'Abernethy'
          end

          it 'sets the correct telephone_1' do
            expect(contact.telephone_1).to eq '07894 388 923'
          end

          it 'sets the correct business' do
            expect(contact.business).to eq valid_business
          end

          it 'sets the correct address_type_id' do
            expect(contact.address_type_id).to eq address_type.id
          end

          it 'sets the correct email' do
            expect(contact.email).to eq 'garymx5@gmail.com'
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
            expect(small_producer.allocation_method_obligation).to eq '122'.to_i
          end

          it 'sets the allocation_method_obligation' do
            expect(small_producer.allocation_method_predominant_material).to eq 'Paper'
          end

          it 'creates a valid object' do
            small_producer.registration = Registration.new(id: 1)
            expect(small_producer).to be_valid
          end
        end

        context 'creates registration for small producer' do
          before do
            allow(SicCode).to receive(:id_from_setting).and_return sic_code.id
            subject.process
          end

          it 'sets the turnover' do
            expect(registration.turnover).to eq '2.05'.to_f
          end

          it 'sets the allocation_method_used' do
            expect(registration.allocation_method_used).to eq true
          end

          it 'sets the packaging_sector_main_activity' do
            expect(registration.packaging_sector_main_activity).to eq packaging_sector
          end

          it 'sets the business' do
            expect(registration.business).to eq valid_business
          end

          it 'sets the sic_code_id' do
            expect(registration.sic_code_id).to eq sic_code.id
          end

          it 'sets the agency_template_upload' do
            expect(registration.agency_template_upload).to eq valid_agency_template
          end

          it 'creates a valid object' do
            expect(registration).to be_valid
          end
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
  end
end
