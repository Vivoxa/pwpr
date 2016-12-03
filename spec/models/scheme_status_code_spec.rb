require 'rails_helper'

RSpec.describe SchemeStatusCode, type: :model do
  it {should have_many(:businesses)}
end
