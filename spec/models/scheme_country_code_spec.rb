require 'rails_helper'

RSpec.describe SchemeCountryCode, type: :model do
  it {should have_many(:schemes)}
  it {should have_many(:annual_target_sets)}
end
