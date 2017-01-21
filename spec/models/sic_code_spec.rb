require 'rails_helper'

RSpec.describe SicCode, type: :model do
  context 'Associations' do
    describe '#has_many' do
      it { is_expected.to have_many(:businesses) }
      it { is_expected.to have_many(:registrations) }
    end
  end

  context 'Validations' do
    describe '#validates_presence_of' do
      it { is_expected.to validate_presence_of(:year_introduced) }
      it { is_expected.to validate_presence_of(:code) }
    end

    describe '#id_from_setting' do
      it 'expects an id for a valid setting' do
        expect(described_class.id_from_setting('01.23')).to eq 10
      end
    end
  end
end
