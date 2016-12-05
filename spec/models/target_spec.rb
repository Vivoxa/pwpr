require 'rails_helper'

RSpec.describe Target, type: :model do
  context 'Associations' do
    describe '#belongs_to' do
      it { is_expected.to belong_to(:annual_target_set) }
      it { is_expected.to belong_to(:target_field) }
    end
  end
end
