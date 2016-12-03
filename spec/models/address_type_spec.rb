require 'rails_helper'

RSpec.describe AddressType, type: :model do
  context 'Associations' do
    describe '#has_many' do
      it {should have_many(:addresses)}
    end
  end
end
