
require 'rails_helper'

RSpec.describe Scheme, type: :model do
  context 'Associtations' do
    describe '#belongs_to' do
      it {should belong_to(:scheme_country_code)}
    end

    describe '#has_many' do
      it {should have_many(:businesses)}
      it {should have_many(:agency_template_uploads)}
    end

    describe '#has_and_belongs_to_many' do
      it {should have_and_belong_to_many(:scheme_operators)}
    end
  end

  context 'Validations' do
    # describe '#validates_presence_of' do
    #   it {should validate_presence_of(:scheme_country_code_id)}
    # end
  end
end
