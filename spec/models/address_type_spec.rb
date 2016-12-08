require 'rails_helper'

RSpec.describe AddressType, type: :model do
  context 'Associations' do
    describe '#has_many' do
      it { is_expected.to have_many(:addresses) }
    end
  end

  context 'Validations' do
    describe '#validates_presence_of' do
      it { is_expected.to validate_presence_of(:title) }
    end
  end
end
