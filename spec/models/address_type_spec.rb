require 'rails_helper'

RSpec.describe AddressType, type: :model do
  context 'Associations' do
    describe '#has_many' do
      it { is_expected.to have_many(:addresses) }
    end
  end

  context 'Validations' do
    describe '#validates_presence_of' do
      it { is_expected.to validate_presence_of(:title) }
    end
  end

  describe '#id_from_setting' do
    context 'when value exists in the database' do
      it 'expects the value to be returned' do
        result = described_class.id_from_setting('Audit')
        expect(result).to be_a(AddressType)
      end
    end
    context 'when value does NOT exist in the database' do
      it 'expects nil to be returned' do
        result = described_class.id_from_setting('Absent')
        expect(result).to be_nil
      end
    end
  end
end
