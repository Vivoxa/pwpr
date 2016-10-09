
require 'rails_helper'

RSpec.describe SchemeOperator, type: :model do
  let(:scheme) { Scheme.first }

  before do
    subject.email = 'nigelsurtees@wvivoxa.com'
    subject.password = 'khgsdfgaskgfdkag'
    subject.schemes << scheme
    subject.save
  end

  context 'Scopes' do
    describe 'company_operators' do
      let(:test_company_operators) { SchemeOperator.company_operators(scheme) }

      context 'when scheme is present' do
        it 'returns the object' do
          expect(test_company_operators.first).to be_a ::CompanyOperator
        end
      end

      context 'when scheme does not exist' do
        let(:scheme) { Scheme.new }

        it 'returns empty' do
          expect(test_company_operators.size).to eq(0)
        end
      end
    end

    describe 'pending_scheme_operators' do
      let(:pending_scheme_operators) { SchemeOperator.pending_scheme_operators }

      context 'when scheme is present' do
        it 'returns the object' do
          expect(pending_scheme_operators.first).to be_a ::SchemeOperator
        end

        it 'expects objects to have a past confirmed_at' do
          expect(pending_scheme_operators.first.confirmed_at).to be <= DateTime.now
        end
      end
    end
  end

  context 'Roles' do
    it 'expects the correct roles to be available' do
      expect(SchemeOperator.available_role_names).to eq %w(scheme_owner scheme_full_access scheme_user_r scheme_user_rw)
    end

    it 'expects scheme_owner to be an available role' do
      expect(subject.allowed_role?(:scheme_owner)).to be true
    end

    it 'expects scheme_full_access to be an available role' do
      expect(subject.allowed_role?(:scheme_full_access)).to be true
    end

    it 'expects scheme_user_r to be an available role' do
      expect(subject.allowed_role?(:scheme_user_r)).to be true
    end

    it 'expects scheme_user_rw to be an available role' do
      expect(subject.allowed_role?(:scheme_user_rw)).to be true
    end

    it 'expects name to be an attribute' do
      expect(subject.respond_to?(:name)).to be true
    end

    context 'when assigning a role' do
      it 'expects the SchemeOperator to have that role' do
        subject.add_role :scheme_owner
        expect(subject.has_role?(:scheme_owner)).to be true
        expect(subject.scheme_owner?).to be true
        subject.scheme_full_access!
        expect(subject.scheme_full_access?).to be true
        expect(subject.has_role?(:scheme_full_access)).to be true
      end
    end

    context 'when removing a role' do
      it 'expects the SchemeOperator to NOT have that role' do
        subject.add_role :scheme_owner
        expect(subject.has_role?(:scheme_owner)).to be true
        subject.remove_role :scheme_owner
        expect(subject.has_role?(:scheme_owner)).to be false
      end
    end
  end
end
