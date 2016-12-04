require 'rails_helper'

RSpec.describe Address, type: :model do
  context 'Associations' do
    describe '#belongs_to' do
      it {is_expected.to belong_to(:business)}
      it {is_expected.to belong_to(:address_type)}
    end
  end
end
