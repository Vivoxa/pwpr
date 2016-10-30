require 'rails_helper'

RSpec.describe CompanyOperator, type: :model do
  let(:scheme) { Scheme.first }
  let(:subject) { FactoryGirl.create(:company_operator) }
  let(:expected_roles) { %w(co_users_r co_users_w co_users_d co_users_e businesses_r businesses_e).freeze }

  context 'Scopes' do
    describe 'scheme_operators' do
      let(:test_scheme_operators) { CompanyOperator.scheme_operators(scheme) }

      context 'when scheme is present' do
        xit 'returns the object' do
          expect(test_scheme_operators.first).to be_a ::SchemeOperator
        end
      end

      context 'when scheme does NOT exist' do
        let(:scheme) { Scheme.new }

        xit 'returns empty' do
          expect(test_scheme_operators.size).to eq(0)
        end
      end
    end
  end

  context 'Roles' do
    it 'expects the correct roles to be available' do
      expected_roles.each do |role|
        expect(subject.allowed_role?(role)).to be true
      end
    end

    context 'when assigning a role' do
      it 'expects the CompanyOperator to have that role' do
        subject.add_role :co_director
        expect(subject.has_role?(:co_director)).to be true
        expect(subject.co_director?).to be true
        subject.co_super_user!
        expect(subject.co_super_user?).to be true
        expect(subject.has_role?(:co_super_user)).to be true
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
  context 'Abitlites' do
    context 'with NO Role' do
      let(:company_operator_no_role) { FactoryGirl.create(:company_operator) }
      let(:ability) { Abilities.ability_for(company_operator_no_role) }

      it_behaves_like 'NOT a manager', Admin

      it_behaves_like 'NOT a manager', CompanyOperator

      it_behaves_like 'NOT a manager', SchemeOperator

      it_behaves_like 'NOT a manager', Scheme

      it_behaves_like 'NOT a manager', SchemeOperators::RegistrationsController

      it_behaves_like 'NOT a manager', CompanyOperators::RegistrationsController
    end

    context 'with co_director role' do
      let(:company_operator_with_director) { FactoryGirl.create(:company_operator_with_director) }
      let(:ability) { Abilities.ability_for(company_operator_with_director) }

      it_behaves_like 'NOT a manager', Admin

      it_behaves_like 'a writer', CompanyOperator

      it_behaves_like 'NOT a manager', SchemeOperator

      it_behaves_like 'NOT a manager', Scheme

      it_behaves_like 'NOT a manager', SchemeOperators::RegistrationsController

      it_behaves_like 'NOT a manager', CompanyOperators::RegistrationsController
    end

    context 'with co_user_r role' do
      let(:company_operator_with_co_users_r) { FactoryGirl.create(:company_operator_with_co_users_r) }
      let(:ability) { Abilities.ability_for(company_operator_with_co_users_r) }

      it_behaves_like 'a reader', CompanyOperator

      it_behaves_like 'NOT an editor', CompanyOperator

      it_behaves_like 'NOT an updater', CompanyOperator

      it_behaves_like 'NOT a writer', CompanyOperator

      it_behaves_like 'NOT a destroyer', CompanyOperator

      it_behaves_like 'NOT a manager', Admin

      it_behaves_like 'NOT a manager', SchemeOperator

      it_behaves_like 'NOT a manager', SchemeOperator

      it_behaves_like 'NOT a manager', SchemeOperators::RegistrationsController

      it_behaves_like 'NOT a manager', CompanyOperators::RegistrationsController
    end

    context 'with co_user_rw role' do
      let(:company_operator_with_co_users_w) { FactoryGirl.create(:company_operator_with_co_users_w) }
      let(:ability) { Abilities.ability_for(company_operator_with_co_users_w) }

      it_behaves_like 'a reader', CompanyOperator

      it_behaves_like 'a writer', CompanyOperator

      it_behaves_like 'NOT a manager', Admin

      it_behaves_like 'NOT an editor', CompanyOperator

      it_behaves_like 'NOT an updater', CompanyOperator

      it_behaves_like 'NOT a destroyer', CompanyOperator

      it_behaves_like 'NOT a manager', SchemeOperator

      it_behaves_like 'NOT a manager', Scheme

      it_behaves_like 'NOT a manager', SchemeOperators::RegistrationsController

      it_behaves_like 'NOT a manager', CompanyOperators::RegistrationsController
    end

    context 'with co_user_rwe role' do
      let(:company_operator_with_co_users_e) { FactoryGirl.create(:company_operator_with_co_users_e) }
      let(:ability) { Abilities.ability_for(company_operator_with_co_users_e) }

      it_behaves_like 'a reader', CompanyOperator

      it_behaves_like 'a writer', CompanyOperator

      it_behaves_like 'NOT a manager', Admin

      it_behaves_like 'an editor', CompanyOperator

      it_behaves_like 'an updater', CompanyOperator

      it_behaves_like 'NOT a destroyer', CompanyOperator

      it_behaves_like 'NOT a manager', SchemeOperator

      it_behaves_like 'NOT a manager', Scheme

      it_behaves_like 'NOT a manager', SchemeOperators::RegistrationsController

      it_behaves_like 'NOT a manager', CompanyOperators::RegistrationsController
    end
  end
end
