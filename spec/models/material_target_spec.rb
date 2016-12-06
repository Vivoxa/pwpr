require 'rails_helper'

RSpec.describe MaterialTarget, type: :model do
  context 'Associations' do
    describe '#belongs_many' do
      it { is_expected.to belong_to(:packaging_material) }
      it { is_expected.to belong_to(:annual_target_set) }
    end
  end

  context 'Validations' do
    describe '#validates_presence_of' do
      it { is_expected.to validate_presence_of(:packaging_material_id)}
      it { is_expected.to validate_presence_of(:annual_target_set_id)}
      it { is_expected.to validate_presence_of(:year)}
      it { is_expected.to validate_presence_of(:value)}
    end
  end
end
