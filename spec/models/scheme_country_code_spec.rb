require 'rails_helper'

RSpec.describe SchemeCountryCode, type: :model do
  context 'Associations' do
    describe '#has_many' do
      it { is_expected.to have_many(:schemes) }
      it { is_expected.to have_many(:annual_target_sets) }
    end
  end
end
