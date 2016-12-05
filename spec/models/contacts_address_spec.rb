require 'rails_helper'

RSpec.describe ContactsAddress, type: :model do
  context 'Associations' do
    describe '#belongs_to' do
      it { is_expected.to belong_to(:address) }
      it { is_expected.to belong_to(:contact) }
    end
  end
end
