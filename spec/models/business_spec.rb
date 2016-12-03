require 'rails_helper'

RSpec.describe Business, type: :model do
  context 'Associations' do
    describe '#belongs_to' do
      it {should belong_to(:scheme)}
      it {should belong_to(:business_type)}
      it {should belong_to(:business_subtype)}
      it {should belong_to(:scheme_status_code)}
      it {should belong_to(:registration_status_code)}
    end

    describe '#has_many' do
      it {should have_many(:company_operators)}
      it {should have_many(:addresses)}
    end
  end

  context 'Validations' do
    # describe '#validates_presence_of' do
    #   it {should validate_presence_of(:NPWD)}
    #   it {should validate_presence_of(:scheme_id)}
    #   it {should validate_presence_of(:business_type_id)}
    #   it {should validate_presence_of(:business_subtype_id)}
    #   it {should validate_presence_of(:scheme_status_code_id)}
    #   it {should validate_presence_of(:registration_status_code_id)}
    #   it {should validate_presence_of(:registration_status_code_id)}
    # end
  end
end
