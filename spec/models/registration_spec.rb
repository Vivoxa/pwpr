require 'rails_helper'

RSpec.describe Registration, type: :model do
  context 'Associations' do
    describe '#belongs_to' do
      it { is_expected.to belong_to(:agency_template_upload) }
      it { is_expected.to belong_to(:sic_code) }
      it { is_expected.to belong_to(:packaging_sector_main_activity) }
    end

    describe '#has_one' do
      it { is_expected.to have_one(:small_producer_detail) }
      it { is_expected.to have_one(:regular_producer_detail) }
    end
  end

  context 'Validations' do
    describe '#validates_presence_of' do
      it { is_expected.to validate_presence_of(:agency_template_upload_id)}
      it { is_expected.to validate_presence_of(:sic_code_id)}
      it { is_expected.to validate_presence_of(:packaging_sector_main_activity)}
      it { is_expected.to validate_presence_of(:turnover)}
    end
  end
end
