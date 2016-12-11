require 'rails_helper'

RSpec.describe TargetField, type: :model do
  context 'Associations' do
    describe '#has_many' do
      it { is_expected.to have_many(:targets) }
    end
  end

  context 'Validations' do
    describe '#validates_presence_of' do
      it { is_expected.to validate_presence_of(:name) }
      it { is_expected.to validate_presence_of(:year_introduced) }
    end
  end
end
