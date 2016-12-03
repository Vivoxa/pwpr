require 'rails_helper'

RSpec.describe PackagingSectorActivity, type: :model do
  it {should have_many(:registrations)}
end
