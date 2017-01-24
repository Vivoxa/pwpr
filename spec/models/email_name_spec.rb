require 'rails_helper'

RSpec.describe EmailName, type: :model do
  context 'Validations' do
    describe '#validates_presence_of' do
      it { is_expected.to validate_presence_of(:name) }
    end
  end
  describe '#id_from_setting' do
    it 'expects an id for a valid setting' do
      expect(described_class.id_from_setting('registration_email')).to eq 1
    end
  end
end
