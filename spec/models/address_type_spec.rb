require 'rails_helper'

RSpec.describe AddressType, type: :model do
  it {should have_many(:addresses)}
end
