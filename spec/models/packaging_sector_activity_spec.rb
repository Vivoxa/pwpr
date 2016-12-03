require 'rails_helper'

RSpec.describe PackagingSectorActivity, type: :model do
  context 'Associations' do
    describe '#has_many' do
      it {should have_many(:registrations)}
    end
  end
end
