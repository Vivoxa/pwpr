require 'rails_helper'

RSpec.describe MaterialTarget, type: :model do
  context 'Associations' do
    describe '#belongs_many' do
      it { is_expected.to belong_to(:packaging_material) }
      it { is_expected.to belong_to(:annual_target_set) }
    end
  end
end
