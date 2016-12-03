require 'rails_helper'

RSpec.describe BusinessSubtype, type: :model do
  context 'Associations' do
    describe '#has_many' do
      it {should have_many(:businesses)}
    end
  end
end
