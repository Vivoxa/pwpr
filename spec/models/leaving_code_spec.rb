require 'rails_helper'

RSpec.describe LeavingCode, type: :model do
  context 'Associations' do
    describe '#has_many' do
      it { is_expected.to have_many(:leavers) }
    end
  end

  context 'Validations' do
    describe '#validates_presence_of' do
      it { is_expected.to validate_presence_of(:code)}
      it { is_expected.to validate_presence_of(:reason)}
    end
  end
end
