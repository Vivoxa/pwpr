require 'rails_helper'

RSpec.describe Address, type: :model do
  context 'Associations' do
    describe '#belongs_to' do
      it {should belong_to(:business)}
      it {should belong_to(:address_type)}
    end
  end
end
