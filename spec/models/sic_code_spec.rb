require 'rails_helper'

RSpec.describe SicCode, type: :model do
  context 'Associations' do
    describe '#has_many' do
      it { is_expected.to have_many(:businesses) }
      it { is_expected.to have_many(:registrations) }
    end
  end
end
