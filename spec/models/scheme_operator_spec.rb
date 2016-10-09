
require 'rails_helper'

RSpec.describe SchemeOperator, type: :model do
  let(:scheme) { Scheme.first }

  before do
    subject.email = 'nigelsurtees@wvivoxa.com'
    subject.password = 'khgsdfgaskgfdkag'
    subject.save
  end

  context 'Scopes' do
    describe 'company_operators' do
      before do
        @company_operators = SchemeOperator.company_operators(scheme)
      end
      context 'when scheme is present' do
        it 'returns the object' do
          expect(@company_operators.first).to be_a ::CompanyOperator
        end
      end

      context 'when scheme does not exist' do
        let(:scheme) { Scheme.new }

        it 'returns empty' do
          expect(@company_operators.size).to eq(0)
        end
      end
    end

    describe 'pending_scheme_operators' do
      before do
        @pending_scheme_operators = SchemeOperator.pending_scheme_operators
      end
      context 'when scheme is present' do
        it 'returns the object' do
          expect(@pending_scheme_operators.first).to be_a ::SchemeOperator
        end

        it 'expects objects to have a past confirmed_at' do
          expect(@pending_scheme_operators.first.confirmed_at).to be <= DateTime.now
        end
      end
    end
  end

  context 'Roles' do
    it 'expects the correct roles to be available' do
      expect(SchemeOperator.available_role_names).to eq %w(owner admin user_r user_rw)
    end

    it 'expects owner to be an available role' do
      expect(subject.allowed_role?(:owner)).to be true
    end

    it 'expects admin to be an available role' do
      expect(subject.allowed_role?(:admin)).to be true
    end

    it 'expects user_r to be an available role' do
      expect(subject.allowed_role?(:user_r)).to be true
    end

    it 'expects user_rw to be an available role' do
      expect(subject.allowed_role?(:user_rw)).to be true
    end

    it 'expects name to be an attribute' do
      expect(subject.respond_to?(:name)).to be true
    end

    context 'when assigning a role' do
      it 'expects the SchemeOperator to have that role' do
        subject.add_role :owner
        expect(subject.has_role?(:owner)).to be true
        expect(subject.owner?).to be true
        subject.admin!
        expect(subject.admin?).to be true
        expect(subject.has_role?(:admin)).to be true
      end
    end

    context 'when removing a role' do
      it 'expects the SchemeOperator to NOT have that role' do
        subject.add_role :owner
        expect(subject.has_role?(:owner)).to be true
        subject.remove_role :owner
        expect(subject.has_role?(:owner)).to be false
      end
    end
  end
end
