require 'rails_helper'

RSpec.describe Subsidiary, type: :model do
  context 'Associations' do
    describe '#belong_to' do
      it { is_expected.to belong_to(:business) }
      it { is_expected.to belong_to(:agency_template_upload) }
    end
  end
end
