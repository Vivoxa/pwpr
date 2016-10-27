require 'rails_helper'

RSpec.describe CompanyOperator, type: :model do
  let(:scheme) { Scheme.first }
  let(:subject) { FactoryGirl.create(:company_operator) }

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
    context 'Constants' do
      describe 'ROLES' do
        it 'expects the ROLES constant to exist' do
          expect(subject.class::ROLES).not_to be_nil
        end

        it 'load the correct values in ROLES' do
          expect(subject.class::ROLES).to eq %w(co_director co_super_user co_user).freeze
        end
      end

      describe 'PERMISSIONS' do
        it 'expects the PERMISSIONS constant to exist' do
          expect(subject.class::PERMISSIONS).not_to be_nil
        end

        it 'load the correct values in PERMISSIONS' do
          expect(subject.class::PERMISSIONS).to eq %w(co_users_r co_users_w co_users_d co_users_e
                                                      businesses_r businesses_e).freeze
        end
      end
    end

    it 'expects the correct roles to be available' do
      expect(CompanyOperator.available_role_names).to eq %w(co_director co_super_user co_user
                                                            co_users_r co_users_w co_users_d co_users_e
                                                            businesses_r businesses_e)
    end

    it 'expects name to be an attribute' do
      expect(subject.respond_to?(:name)).to be true
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
      let(:ability) { Ability.new(company_operator_no_role) }

      it_behaves_like 'NOT an admin manager'

      it_behaves_like 'NOT a company operator manager'

      it_behaves_like 'NOT a scheme operator manager'

      it_behaves_like 'NOT a scheme manager'

      it_behaves_like 'NOT a registration manager'
    end

    context 'with co_director role' do
      let(:company_operator_with_director) { FactoryGirl.create(:company_operator_with_director) }
      let(:ability) { Ability.new(company_operator_with_director) }

      it_behaves_like 'NOT an admin manager'

      it_behaves_like 'a writer', CompanyOperator

      it_behaves_like 'NOT a scheme operator manager'

      it_behaves_like 'NOT a scheme manager'

      it_behaves_like 'NOT a registration manager'
    end

    context 'with co_super_user role' do
      let(:company_operator_with_co_super_user) { FactoryGirl.create(:company_operator_with_co_super_user) }
      let(:ability) { Ability.new(company_operator_with_co_super_user) }

      it_behaves_like 'a reader', CompanyOperator

      it_behaves_like 'an editor', CompanyOperator

      it_behaves_like 'an updater', CompanyOperator

      it_behaves_like 'a writer', CompanyOperator

      it_behaves_like 'NOT an admin manager'

      it_behaves_like 'NOT a destroyer', CompanyOperator

      it_behaves_like 'NOT a scheme operator manager'

      it_behaves_like 'NOT a scheme manager'

      it_behaves_like 'NOT a registration manager'
    end

    context 'with co_users_r role' do
      let(:company_operator_with_co_users_r) { FactoryGirl.create(:company_operator_with_co_users_r) }
      let(:ability) { Ability.new(company_operator_with_co_users_r) }

      it_behaves_like 'a reader', CompanyOperator

      it_behaves_like 'NOT an editor', CompanyOperator

      it_behaves_like 'NOT an updater', CompanyOperator

      it_behaves_like 'NOT a writer', CompanyOperator

      it_behaves_like 'NOT a destroyer', CompanyOperator

      it_behaves_like 'NOT an admin manager'

      it_behaves_like 'NOT a scheme operator manager'

      it_behaves_like 'NOT a scheme manager'

      it_behaves_like 'NOT a registration manager'
    end

    context 'with co_users_w role' do
      let(:company_operator_with_co_users_w) { FactoryGirl.create(:company_operator_with_co_users_w) }
      let(:ability) { Ability.new(company_operator_with_co_users_w) }

      it_behaves_like 'a reader', CompanyOperator

      it_behaves_like 'a writer', CompanyOperator

      it_behaves_like 'NOT an admin manager'

      it_behaves_like 'NOT an editor', CompanyOperator

      it_behaves_like 'NOT an updater', CompanyOperator

      it_behaves_like 'NOT a destroyer', CompanyOperator

      it_behaves_like 'NOT a scheme operator manager'

      it_behaves_like 'NOT a scheme manager'

      it_behaves_like 'NOT a registration manager'
    end

    context 'with co_users_e role' do
      let(:company_operator_with_co_users_e) { FactoryGirl.create(:company_operator_with_co_users_e) }
      let(:ability) { Ability.new(company_operator_with_co_users_e) }

      it_behaves_like 'a reader', CompanyOperator

      it_behaves_like 'a writer', CompanyOperator

      it_behaves_like 'NOT an admin manager'

      it_behaves_like 'an editor', CompanyOperator

      it_behaves_like 'an updater', CompanyOperator

      it_behaves_like 'NOT a destroyer', CompanyOperator

      it_behaves_like 'NOT a scheme operator manager'

      it_behaves_like 'NOT a scheme manager'

      it_behaves_like 'NOT a registration manager'
    end
  end
end
