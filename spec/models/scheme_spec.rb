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

    describe '#has_and_belongs_to_many' do
      it { is_expected.to have_and_belong_to_many(:scheme_operators) }
    end
  end

  context 'Validations' do
    describe '#validates_presence_of' do
      it { is_expected.to validate_presence_of(:scheme_country_code_id) }
      it { is_expected.to validate_presence_of(:name) }
    end
  end
end
