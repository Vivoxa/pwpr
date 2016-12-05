require 'rails_helper'

RSpec.describe LeavingCode, type: :model do
  context 'Associations' do
    describe '#has_many' do
      it { is_expected.to have_many(:leavers) }
    end
  end
end
