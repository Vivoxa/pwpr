require 'rails_helper'

RSpec.describe PackagingMaterial, type: :model do
  context 'Associations' do
    describe '#has_many' do
      it { is_expected.to have_many(:material_totals) }
      it { is_expected.to have_many(:material_details) }
      it { is_expected.to have_many(:material_targets) }
    end
  end
end
