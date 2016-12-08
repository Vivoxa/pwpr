require 'rails_helper'

RSpec.describe Address, type: :model do
  context 'Associations' do
    describe '#belongs_to' do
      it { is_expected.to belong_to(:business) }
      it { is_expected.to belong_to(:address_type) }
    end

    describe '#has_many' do
      it { is_expected.to have_many(:contacts_addresses) }
      it { is_expected.to have_many(:contacts) }
    end
  end

  context 'Validations' do
    describe '#validates_presence_of' do
      it { is_expected.to validate_presence_of(:business_id) }
      it { is_expected.to validate_presence_of(:address_type_id) }
      it { is_expected.to validate_presence_of(:address_line_1) }
      it { is_expected.to validate_presence_of(:post_code) }
      it { is_expected.to validate_presence_of(:county) }
      it { is_expected.to validate_presence_of(:site_country) }
      it { is_expected.to validate_presence_of(:telephone) }
      it { is_expected.to validate_presence_of(:email) }
    end
  end
end
