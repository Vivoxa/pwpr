require 'rails_helper'

RSpec.describe MaterialDetail, type: :model do
  context 'Associations' do
    describe '#belongs_to' do
      it { is_expected.to belong_to(:regular_producer_detail) }
      it { is_expected.to belong_to(:packaging_material) }
    end
  end

  context 'Validations' do
    describe '#validates_presence_of' do
      it { is_expected.to validate_presence_of(:regular_producer_detail_id) }
      it { is_expected.to validate_presence_of(:packaging_material_id) }
      it { is_expected.to validate_presence_of(:t1man) }
      it { is_expected.to validate_presence_of(:t1conv) }
      it { is_expected.to validate_presence_of(:t1pf) }
      it { is_expected.to validate_presence_of(:t1sell) }
      it { is_expected.to validate_presence_of(:t2aman) }
      it { is_expected.to validate_presence_of(:t2aconv) }
      it { is_expected.to validate_presence_of(:t2apf) }
      it { is_expected.to validate_presence_of(:t2asell) }
      it { is_expected.to validate_presence_of(:t2bman) }
      it { is_expected.to validate_presence_of(:t2bconv) }
      it { is_expected.to validate_presence_of(:t2bpf) }
      it { is_expected.to validate_presence_of(:t2bsell) }
      it { is_expected.to validate_presence_of(:t3aconv) }
      it { is_expected.to validate_presence_of(:t3apf) }
      it { is_expected.to validate_presence_of(:t3asell) }
      it { is_expected.to validate_presence_of(:t3b) }
      it { is_expected.to validate_presence_of(:t3c) }
    end
  end
end
