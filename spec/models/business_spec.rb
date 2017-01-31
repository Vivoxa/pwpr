require 'rails_helper'

RSpec.describe Business, type: :model do
  context 'Associations' do
    describe '#belongs_to' do
      it { is_expected.to belong_to(:scheme) }
      it { is_expected.to belong_to(:business_type) }
      it { is_expected.to belong_to(:business_subtype) }
      it { is_expected.to belong_to(:scheme_status_code) }
      it { is_expected.to belong_to(:registration_status_code) }
      it { is_expected.to belong_to(:country_of_business_registration) }
      it { is_expected.to belong_to(:sic_code) }
    end

    describe '#has_many' do
      it { is_expected.to have_many(:company_operators) }
      it { is_expected.to have_many(:addresses) }
    end

    describe '#correspondence_contact' do
      it 'expects the correspondence contact to be returned' do
        business = Business.first

        contact = business.correspondence_contact
        expect(contact.address_type_id).to eq(AddressType.id_from_setting('Correspondence'))
      end
    end

    describe '#scope for_registration' do
      it 'expects only businesses from the registration tab to be returned' do
        businesses = Scheme.first.businesses.for_registration
        expect(businesses.count).to eq(1)
      end
    end

    describe '#validate Company Subtype' do
      let(:business) { Business.first }
      context 'when Subsidiary Co' do
        before do
          business.business_subtype_id = BusinessSubtype.id_from_setting('Subsidiary Co')
        end
        it 'expects an error to be raised' do
          business.save
          expect(business.errors.messages).to include(holding_business_id: ['cannot be nil if Subsidiary Co'])
        end
      end

      context 'when NOT Subsidiary Co' do
        it 'expects an error to be raised' do
          business.save
          expect(business.errors.messages).to be_empty
        end
      end
    end
  end

  context 'Validations' do
    describe '#validates_presence_of' do
      it { is_expected.to validate_presence_of(:NPWD) }
      it { is_expected.to validate_presence_of(:scheme_id) }
      it { is_expected.to validate_presence_of(:scheme_ref) }
      it { is_expected.to validate_presence_of(:sic_code_id) }
      #   it {is_expected.to validate_presence_of(:business_type_id)}
      #   it {is_expected.to validate_presence_of(:business_subtype_id)}
      #   it {is_expected.to validate_presence_of(:scheme_status_code_id)}
      #   it {is_expected.to validate_presence_of(:registration_status_code_id)}
      #   it {is_expected.to validate_presence_of(:country_of_business_registration)}
    end
  end
end
