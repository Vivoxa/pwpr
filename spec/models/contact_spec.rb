require 'rails_helper'

RSpec.describe Contact, type: :model do
  context 'Associations' do
    describe '#belongs_to' do
      it {is_expected.to belong_to(:business)}
    end

    describe '#has_many' do
      it {is_expected.to have_many(:contacts_addresses)}
      it {is_expected.to have_many(:addresses)}
    end
  end
end
