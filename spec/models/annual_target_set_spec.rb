require 'rails_helper'

RSpec.describe AnnualTargetSet, type: :model do
  context 'Associations' do
    describe '#belongs_to' do
      it { is_expected.to belong_to(:scheme_country_code) }
    end

    describe '#has_many' do
      it { is_expected.to have_many(:material_targets) }
      it { is_expected.to have_many(:targets) }
    end
  end
end
