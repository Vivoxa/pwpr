require 'rails_helper'

RSpec.describe Target, type: :model do
  context 'Associations' do
    describe '#belongs_to' do
      it { is_expected.to belong_to(:annual_target_set) }
      it { is_expected.to belong_to(:target_field) }
    end
  end

  context 'Validations' do
    describe '#validates_presence_of' do
      it { is_expected.to validate_presence_of(:annual_target_set_id) }
      it { is_expected.to validate_presence_of(:target_field_id) }
      it { is_expected.to validate_presence_of(:year) }
      it { is_expected.to validate_presence_of(:value) }
    end
  end
end
