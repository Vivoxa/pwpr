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
      expect(CompanyOperator.available_role_names).to eq %w(co_director co_contact co_user_r co_user_rw co_user_rwe)
    end

    it 'expects co_director to be an available role' do
      expect(subject.allowed_role?(:co_director)).to be true
    end

    it 'expects co_cantact to be an available role' do
      expect(subject.allowed_role?(:co_contact)).to be true
    end

    it 'expects co_user_r to be an available role' do
      expect(subject.allowed_role?(:co_user_r)).to be true
    end

    it 'expects company_user_rw to be an available role' do
      expect(subject.allowed_role?(:co_user_rw)).to be true
    end

    it 'expects company_user_rwe to be an available role' do
      expect(subject.allowed_role?(:co_user_rwe)).to be true
    end

    it 'expects name to be an attribute' do
      expect(subject.respond_to?(:name)).to be true
    end

    context 'when assigning a role' do
      it 'expects the CompanyOperator to have that role' do
        subject.add_role :co_director
        expect(subject.has_role?(:co_director)).to be true
        expect(subject.co_director?).to be true
        subject.co_contact!
        expect(subject.co_contact?).to be true
        expect(subject.has_role?(:co_contact)).to be true
      end
    end

    context 'when removing a role' do
      it 'expects the CompanyOperator to NOT have that role' do
        subject.add_role :co_director
        expect(subject.has_role?(:co_director)).to be true
        subject.remove_role :co_director
        expect(subject.has_role?(:co_director)).to be false
      end
    end
  end
end
