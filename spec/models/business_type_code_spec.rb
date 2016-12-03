require 'rails_helper'

RSpec.describe BusinessType, type: :model do
  context 'Associations' do
    describe '#has_many' do
      it {should have_many(:businesses)}
    end
  end
end
