require 'rails_helper'

RSpec.describe Ability do
  context 'when an Admin user' do
    context 'when has the super admin role' do
      let(:super_admin) { FactoryGirl.create(:super_admin) }
      it 'expects the correct abilities to be present' do
        ability = described_class.new(super_admin)
        expect(ability.can?(:new, Admin)).to eq true
      end
    end
  end

  context 'when an Scheme Operator' do
    let(:sc_marti) { SchemeOperator.new }
    before do
      sc_marti.email = 'jennifer@back_to_the_future.com'
      sc_marti.first_name = 'Jennifer'
      sc_marti.password = 'mypassword'
      sc_marti.confirmed_at = DateTime.now
      sc_marti.schemes = [Scheme.create(name: 'test scheme', active: true)]
      sc_marti.add_role :sc_director
      sc_marti.add_role :sc_users_w
      sc_marti.save
    end

    it 'expects to be able to create a Scheme Operator' do
      ability = described_class.new(sc_marti)
      expect(ability.can?(:new, SchemeOperator)).to eq true
    end
  end

  context 'when an Company Operator' do
    context 'when has the director role' do
      let(:company_operator_with_director) { FactoryGirl.create(:company_operator_with_director) }

      it 'expects to be able to edit a Company Operator' do
        ability = described_class.new(company_operator_with_director)
        expect(ability.can?(:edit, CompanyOperator)).to eq true
      end
    end
  end

  context 'when an Visitor' do
    let(:visitor) { Visitor.new }
    it 'expects to be able to accept an invitation' do
      ability = described_class.new(visitor)
      expect(ability.can?(:edit, SchemeOperators::InvitationsController)).to eq true
      expect(ability.can?(:edit, CompanyOperators::InvitationsController)).to eq true
      expect(ability.can?(:update, SchemeOperators::InvitationsController)).to eq true
      expect(ability.can?(:update, CompanyOperators::InvitationsController)).to eq true
    end
  end
end
