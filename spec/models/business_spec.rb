require 'rails_helper'

RSpec.describe Business, type: :model do
  context 'Associations' do
    describe '#belongs_to' do
      it { is_expected.to belong_to(:scheme) }
      it { is_expected.to belong_to(:business_type) }
      it { is_expected.to belong_to(:business_subtype) }
      it { is_expected.to belong_to(:scheme_status_code) }
      it { is_expected.to belong_to(:registration_status_code) }
      it { is_expected.to belong_to(:sic_code) }
    end

    describe '#has_many' do
      it { is_expected.to have_many(:company_operators) }
      it { is_expected.to have_many(:addresses) }
    end
  end

  # context 'Validations' do
    # describe '#validates_presence_of' do
    #   it {is_expected.to validate_presence_of(:NPWD)}
    #   it {is_expected.to validate_presence_of(:scheme_id)}
    #   it {is_expected.to validate_presence_of(:business_type_id)}
    #   it {is_expected.to validate_presence_of(:business_subtype_id)}
    #   it {is_expected.to validate_presence_of(:scheme_status_code_id)}
    #   it {is_expected.to validate_presence_of(:registration_status_code_id)}
    #   it {is_expected.to validate_presence_of(:registration_status_code_id)}
    #   it {is_expected.to validate_presence_of(:sic_code_id)}
    # end
  # end
end
