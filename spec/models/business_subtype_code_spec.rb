require 'rails_helper'

RSpec.describe BusinessSubtype, type: :model do
  it {should have_many(:businesses)}
end
