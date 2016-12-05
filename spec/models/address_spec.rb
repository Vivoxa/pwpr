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
end
