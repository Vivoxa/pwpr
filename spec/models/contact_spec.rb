require 'rails_helper'

RSpec.describe Contact, type: :model do
  context 'Associations' do
    describe '#belongs_to' do
      it { is_expected.to belong_to(:business) }
    end

    describe '#has_many' do
      it { is_expected.to have_many(:contacts_addresses) }
      it { is_expected.to have_many(:addresses) }
    end
  end

  context 'Validations' do
    describe '#validates_presence_of' do
      it { is_expected.to validate_presence_of(:business_id) }
      it { is_expected.to validate_presence_of(:title) }
      it { is_expected.to validate_presence_of(:first_name) }
      it { is_expected.to validate_presence_of(:last_name) }
      it { is_expected.to validate_presence_of(:email) }
      it { is_expected.to validate_presence_of(:telephone_1) }
    end
  end
end
