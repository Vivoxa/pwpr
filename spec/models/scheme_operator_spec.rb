require 'rails_helper'

RSpec.describe SchemeOperator, type: :model do
  let(:scheme) {Scheme.first }
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
      expect(SchemeOperator.available_role_names).to eq %w(sc_director sc_super_user sc_user_r sc_user_rw sc_user_rwe)
    end

    it 'expects sc_director to be an available role' do
      expect(subject.allowed_role?(:sc_director)).to be true
    end

    it 'expects sc_super_user to be an available role' do
      expect(subject.allowed_role?(:sc_super_user)).to be true
    end

    it 'expects sc_user_r to be an available role' do
      expect(subject.allowed_role?(:sc_user_r)).to be true
    end

    it 'expects sc_user_rw to be an available role' do
      expect(subject.allowed_role?(:sc_user_rw)).to be true
    end

    it 'expects sc_user_rwe to be an available role' do
      expect(subject.allowed_role?(:sc_user_rwe)).to be true
    end

    it 'expects name to be an attribute' do
      expect(subject.respond_to?(:name)).to be true
    end

    context 'when assigning a role' do
      it 'expects the SchemeOperator to have that role' do
        subject.add_role :sc_director
        expect(subject.has_role?(:sc_director)).to be true
        expect(subject.sc_director?).to be true
        subject.sc_super_user!
        expect(subject.sc_super_user?).to be true
        expect(subject.has_role?(:sc_super_user)).to be true
      end
    end

    context 'when removing a role' do
      it 'expects the SchemeOperator to NOT have that role' do
        subject.add_role :sc_director
        expect(subject.has_role?(:sc_director)).to be true
        subject.remove_role :sc_director
        expect(subject.has_role?(:sc_director)).to be false
      end
    end
  end
end
