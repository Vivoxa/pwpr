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
      it { is_expected.to validate_presence_of(:year_introduced)}
      it { is_expected.to validate_presence_of(:code)}
    end
  end
end
