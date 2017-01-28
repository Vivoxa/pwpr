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

  describe '#delete_parents' do
    let(:leaving_business) do
      LeavingBusiness.create!(scheme_ref:          'ref 1',
                              npwd:                'NPWD123',
                              company_name:        'Company 1',
                              company_number:      '123456789',
                              subsidiaries_number: 0)
    end

    let(:leaver) { Leaver.create(leaving_business: leaving_business) }
    it 'expects the leaving_business to be destroyed' do
      leaving_business_id = leaving_business.id
      leaver.destroy
      expect(LeavingBusiness.where(id: leaving_business_id)).to be_empty
    end
  end
end
