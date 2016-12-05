require 'rails_helper'

RSpec.describe TargetField, type: :model do
  context 'Associations' do
    describe '#has_many' do
      it { is_expected.to have_many(:targets) }
    end
  end
end
