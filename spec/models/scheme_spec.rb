require 'rails_helper'

RSpec.describe Scheme, type: :model do
  context 'Associtations' do
    describe '#belongs_to' do
      it { is_expected.to belong_to(:scheme_country_code) }
    end

    describe '#has_many' do
      it { is_expected.to have_many(:businesses) }
      it { is_expected.to have_many(:agency_template_uploads) }
    end

    describe '#has_many through' do
      it { is_expected.to have_many(:scheme_operators).through(:scheme_operators_schemes) }
    end
  end

  context 'Validations' do
    describe '#validates_presence_of' do
      it { is_expected.to validate_presence_of(:scheme_country_code_id) }
      it { is_expected.to validate_presence_of(:name) }
    end
  end
end
