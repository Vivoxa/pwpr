require 'rails_helper'

RSpec.describe BusinessSubtype, type: :model do
  context 'Associations' do
    describe '#has_many' do
      it { is_expected.to have_many(:businesses) }
    end
  end

  context 'Validations' do
    describe '#validates_presence_of' do
      it { is_expected.to validate_presence_of(:name)}
      it { is_expected.to validate_presence_of(:description)}
    end
  end
end
