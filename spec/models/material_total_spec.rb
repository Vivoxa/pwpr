require 'rails_helper'

RSpec.describe MaterialTotal, type: :model do
  context 'Associations' do
    describe '#belongs_to' do
      it { is_expected.to belong_to(:regular_producer_detail) }
      it { is_expected.to belong_to(:packaging_material) }
    end
  end

  context 'Validations' do
    describe '#validates_presence_of' do
      it { is_expected.to validate_presence_of(:regular_producer_detail_id) }
      it { is_expected.to validate_presence_of(:packaging_material_id) }
      it { is_expected.to validate_presence_of(:recycling_obligation) }
    end
  end
end
