require 'rails_helper'

RSpec.describe SmallProducerDetail, type: :model do
  context 'Associations' do
    describe '#belongs_to' do
      it { is_expected.to belong_to(:registration) }
    end
  end

  context 'Validations' do
    describe '#validates_presence_of' do
      it { is_expected.to validate_presence_of(:allocation_method_predominant_material) }
      it { is_expected.to validate_presence_of(:registration_id) }
      it { is_expected.to validate_presence_of(:allocation_method_obligation) }
    end
  end
end
