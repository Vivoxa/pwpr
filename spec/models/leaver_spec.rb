require 'rails_helper'

RSpec.describe Leaver, type: :model do
  context 'Associations' do
    describe '#belong_to' do
      it { is_expected.to belong_to(:business) }
      it { is_expected.to belong_to(:leaving_code) }
      it { is_expected.to belong_to(:agency_template_upload) }
    end
  end

  context 'Validations' do
    describe '#validates_presence_of' do
      it { is_expected.to validate_presence_of(:leaving_code_id) }
      it { is_expected.to validate_presence_of(:agency_template_upload_id) }
      it { is_expected.to validate_presence_of(:leaving_date) }
      xit { is_expected.to validate_presence_of(:scheme_registration_date) }
    end
  end
end
