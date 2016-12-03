require 'rails_helper'

RSpec.describe LeavingCode, type: :model do
  it {should have_many(:leavers)}
end
