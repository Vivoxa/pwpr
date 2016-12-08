require 'rails_helper'

RSpec.describe SchemeCountryCode, type: :model do
  context 'Associations' do
    describe '#has_many' do
      it { is_expected.to have_many(:schemes) }
      it { is_expected.to have_many(:annual_target_sets) }
    end
  end

  context 'Validations' do
    describe '#validates_presence_of' do
      it { is_expected.to validate_presence_of(:country) }
    end
  end
end
