require 'rails_helper'

RSpec.describe PackagingSectorMainActivity, type: :model do
  context 'Associations' do
    describe '#has_many' do
      it { is_expected.to have_many(:registrations) }
    end
  end

  context 'Validations' do
    describe '#validates_presence_of' do
      it { is_expected.to validate_presence_of(:type) }
    end
  end
end
