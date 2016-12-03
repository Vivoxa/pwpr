require 'rails_helper'

RSpec.describe RegistrationStatusCode, type: :model do
  it {should have_many(:registrations)}
end
