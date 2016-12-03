require 'rails_helper'

RSpec.describe BusinessType, type: :model do
  it {should have_many(:businesses)}
end
