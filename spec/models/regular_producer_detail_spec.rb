require 'rails_helper'

RSpec.describe RegularProducerDetail, type: :model do
  context 'Associations' do
    describe '#belongs_to' do
      it {is_expected.to belong_to(:registration)}
    end

    describe '#has_many' do
      it {is_expected.to have_many(:material_totals)}
      it {is_expected.to have_many(:material_details)}
      it {is_expected.to have_many(:target_totals)}
    end
  end
end
