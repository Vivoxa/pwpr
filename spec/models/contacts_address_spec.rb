require 'rails_helper'

RSpec.describe ContactsAddress, type: :model do
  context 'Associations' do
    describe '#belongs_to' do
      it { is_expected.to belong_to(:address) }
      it { is_expected.to belong_to(:contact) }
    end
  end

  context 'Validations' do
    describe '#validates_presence_of' do
      it { is_expected.to validate_presence_of(:address_id) }
      it { is_expected.to validate_presence_of(:contact_id) }
    end
  end
end
