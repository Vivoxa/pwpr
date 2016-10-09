require 'rails_helper'

RSpec.describe CompanyOperator, type: :model do
  let(:scheme) { Scheme.first }

  before do
    subject.email = 'nigelsurtees@wvivoxa.com'
    subject.password = 'khgsdfgaskgfdkag'
    subject.save
  end

  context 'Scopes' do
    describe 'scheme_operators' do
      let(:test_scheme_operators) { CompanyOperator.scheme_operators(scheme) }

      context 'when scheme is present' do
        it 'returns the object' do
          expect(test_scheme_operators.first).to be_a ::SchemeOperator
        end
      end

      context 'when scheme does not exist' do
        let(:scheme) { Scheme.new }

        it 'returns empty' do
          expect(test_scheme_operators.size).to eq(0)
        end
      end
    end
  end

  context 'Roles' do
    it 'expects the correct roles to be available' do
      expect(CompanyOperator.available_role_names).to eq %w(company_owner company_full_access company_user_r company_user_rw)
    end

    it 'expects company_owner to be an available role' do
      expect(subject.allowed_role?(:company_owner)).to be true
    end

    it 'expects company_full_access to be an available role' do
      expect(subject.allowed_role?(:company_full_access)).to be true
    end

    it 'expects company_user_r to be an available role' do
      expect(subject.allowed_role?(:company_user_r)).to be true
    end

    it 'expects company_user_rw to be an available role' do
      expect(subject.allowed_role?(:company_user_rw)).to be true
    end

    it 'expects name to be an attribute' do
      expect(subject.respond_to?(:name)).to be true
    end

    context 'when assigning a role' do
      it 'expects the CompanyOperator to have that role' do
        subject.add_role :company_owner
        expect(subject.has_role?(:company_owner)).to be true
        expect(subject.company_owner?).to be true
        subject.company_full_access!
        expect(subject.company_full_access?).to be true
        expect(subject.has_role?(:company_full_access)).to be true
      end
    end

    context 'when removing a role' do
      it 'expects the CompanyOperator to NOT have that role' do
        subject.add_role :company_owner
        expect(subject.has_role?(:company_owner)).to be true
        subject.remove_role :company_owner
        expect(subject.has_role?(:company_owner)).to be false
      end
    end
  end
end
