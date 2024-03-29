require 'rails_helper'

RSpec.describe BusinessType, type: :model do
  context 'Associations' do
    describe '#has_many' do
      it { is_expected.to have_many(:businesses) }
    end
  end

  context 'Validations' do
    describe '#validates_presence_of' do
      it { is_expected.to validate_presence_of(:name) }
      it { is_expected.to validate_presence_of(:description) }
    end
  end
  describe '#id_from_setting' do
    context 'when value exists in the database' do
      it 'expects the value to be returned' do
        result = described_class.id_from_setting('Individual Co')
        business_type = described_class.find(result)
        expect(business_type).to be_a(BusinessType)
      end
    end
    context 'when value does NOT exist in the database' do
      it 'expects nil to be returned' do
        result = described_class.id_from_setting('Absent')
        business_type = described_class.where(id: result).first
        expect(business_type).to be_nil
      end
    end
  end
end
