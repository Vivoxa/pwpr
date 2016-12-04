require 'rails_helper'

RSpec.describe MaterialDetail, type: :model do
  context 'Associations' do
    describe '#belongs_to' do
      it {is_expected.to belong_to(:regular_producer_detail)}
      it {is_expected.to belong_to(:packaging_material)}
    end
  end
end
