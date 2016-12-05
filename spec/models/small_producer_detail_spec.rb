require 'rails_helper'

RSpec.describe SmallProducerDetail, type: :model do
  context 'Associations' do
    describe '#belongs_to' do
      it { is_expected.to belong_to(:registration) }
    end
  end
end
