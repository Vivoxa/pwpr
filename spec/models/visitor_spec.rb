require 'rails_helper'

RSpec.describe Visitor do
  subject(:visitor) { described_class.new }
  context 'when visiting the homepage' do
    it 'expects the name to save' do
      visitor.name = 'temp_user'
      expect(visitor.name).to eq 'temp_user'
    end
  end
end
