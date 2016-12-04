require 'rails_helper'

RSpec.describe SchemeStatusCode, type: :model do
  context 'Associtations' do
    describe '#has_many' do
      it {is_expected.to have_many(:businesses)}
    end
  end
end
