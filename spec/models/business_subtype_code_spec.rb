require 'rails_helper'

RSpec.describe BusinessSubtype, type: :model do
  context 'Associations' do
    describe '#has_many' do
      it { is_expected.to have_many(:businesses) }
    end
  end
end
