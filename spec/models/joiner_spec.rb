require 'rails_helper'

RSpec.describe Joiner, type: :model do
  context 'Associations' do
    describe '#belong_to' do
      it { is_expected.to belong_to(:business) }
      it { is_expected.to belong_to(:agency_template_upload) }
    end
  end

  context 'Validations' do
    describe '#validates_presence_of' do
      it { is_expected.to validate_presence_of(:business_id) }
      it { is_expected.to validate_presence_of(:agency_template_upload_id) }
      it { is_expected.to validate_presence_of(:joining_date) }
      it { is_expected.to validate_presence_of(:total_recovery) }
    end
  end
end
