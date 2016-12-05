require 'rails_helper'

RSpec.describe TargetTotal, type: :model do
  context 'Associations' do
    describe '#belongs_to' do
      it { is_expected.to belong_to(:regular_producer_detail) }
    end
  end
end
