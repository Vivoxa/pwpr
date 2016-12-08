require 'rails_helper'

RSpec.describe TargetTotal, type: :model do
  context 'Associations' do
    describe '#belongs_to' do
      it { is_expected.to belong_to(:regular_producer_detail) }
    end
  end

  context 'Validations' do
    describe '#validates_presence_of' do
      it { is_expected.to validate_presence_of(:regular_producer_detail_id) }
      it { is_expected.to validate_presence_of(:total_recycling_obligation) }
      it { is_expected.to validate_presence_of(:total_recovery_obligation) }
      it { is_expected.to validate_presence_of(:total_material_specific_recycling_obligation) }
      it { is_expected.to validate_presence_of(:adjusted_total_recovery_obligation) }
      it { is_expected.to validate_presence_of(:ninetytwo_percent_min_recycling_target) }
    end
  end
end
