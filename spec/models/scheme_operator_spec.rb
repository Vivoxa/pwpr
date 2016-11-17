require 'rails_helper'

RSpec.describe SchemeOperator, type: :model do
  let(:scheme) { Scheme.first }
  let(:expected_roles) { PermissionsForRole::SchemeOperatorDefinitions::ROLES }

  let(:expected_permissions) { PermissionsForRole::SchemeOperatorDefinitions::PERMISSIONS }

  before do
    subject.email = 'nigelsurtees@wvivoxa.com'
    subject.password = 'khgsdfgaskgfdkag'
    subject.schemes << scheme
    subject.save
  end

  # context 'Scopes' do
  # describe 'company_operators' do
  #   let(:test_company_operators) { SchemeOperator.company_operators(scheme) }

  #   context 'when scheme is present' do
  #     it 'returns the object' do
  #       expect(test_company_operators.first).to be_a ::CompanyOperator
  #     end
  #   end

  #   context 'when scheme does not exist' do
  #     let(:scheme) { Scheme.new }

  #     it 'returns empty' do
  #       expect(test_company_operators.size).to eq(0)
  #     end
  #   end
  # end

  # describe 'pending_scheme_operators' do
  #   let(:pending_scheme_operators) { SchemeOperator.pending_scheme_operators }

  #   context 'when scheme is present' do
  #     it 'returns the object' do
  #       expect(pending_scheme_operators.first).to be_a ::SchemeOperator
  #     end

  #     it 'expects objects to have a past confirmed_at' do
  #       expect(pending_scheme_operators.first.confirmed_at).to be <= DateTime.now
  #     end
  #   end
  # end
  # nd

  context 'Roles' do
    it 'expects the correct role to be available' do
      expect(SchemeOperator.available_role_names).to eq expected_roles + expected_permissions
    end

    it 'expects the correct roles to be available' do
      expected_roles.each do |role|
        expect(subject.allowed_role?(role)).to be true
      end
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

  context 'when an Scheme Operator is created' do
    it 'expects the Scheme Operator to have the restricted sc_user role' do
      scheme_operator = SchemeOperator.create(email: 'sc_operator101@pwpr.com', password: 'my password', name: 'fred', schemes: [Scheme.last])
      %i(sc_user businesses_r schemes_r sc_users_r).each do |permission|
        expect(scheme_operator.has_role?(permission)).to eq true
      end
    end
  end

  context 'Abitlites' do
    let(:scheme_operator) do
      SchemeOperator.create(name:                 'rspec owner',
                            email:                'rspec@test.com',
                            password:             'my_password',
                            confirmation_token:   '12345678912345678912',
                            confirmation_sent_at: DateTime.now,
                            confirmed_at:         DateTime.now,
                            scheme_ids:           Scheme.last.id)
    end
    context 'with NO Role' do
      let(:ability) { Abilities.ability_for(scheme_operator) }

      it_behaves_like 'NOT a manager', Admin

      it_behaves_like 'NOT a manager', CompanyOperator

      it_behaves_like 'NOT a manager', SchemeOperator

      it_behaves_like 'NOT a manager', Scheme

      it_behaves_like 'NOT a manager', SchemeOperators::RegistrationsController

      it_behaves_like 'NOT a manager', CompanyOperators::RegistrationsController

      it_behaves_like 'NOT a manager', Business
    end

    context 'with sc_director role' do
      before do
        scheme_operator.add_role :sc_director
        scheme_operator.add_role :sc_users_w
        scheme_operator.add_role :schemes_r
        scheme_operator.add_role :schemes_e
        scheme_operator.add_role :co_users_r
        scheme_operator.add_role :co_users_e
        scheme_operator.add_role :co_users_w
      end

      after do
        scheme_operator.remove_role :sc_director
        scheme_operator.remove_role :sc_users_w
        scheme_operator.remove_role :schemes_r
        scheme_operator.remove_role :schemes_e
        scheme_operator.add_role :co_users_r
        scheme_operator.add_role :co_users_e
        scheme_operator.add_role :co_users_w
      end

      let(:ability) { Abilities.ability_for(scheme_operator) }

      it_behaves_like 'NOT a manager', Admin

      it_behaves_like 'a writer', CompanyOperator

      it_behaves_like 'a writer', SchemeOperator

      it_behaves_like 'a reader', Scheme.last

      it_behaves_like 'an updater', Scheme.last

      it_behaves_like 'a reader', SchemeOperators::RegistrationsController

      it_behaves_like 'a reader', CompanyOperators::RegistrationsController

      it_behaves_like 'a reader', SchemeOperators::InvitationsController

      it_behaves_like 'a reader', CompanyOperators::InvitationsController

      it_behaves_like 'an editor', SchemeOperators::RegistrationsController

      it_behaves_like 'an editor', CompanyOperators::RegistrationsController

      it_behaves_like 'an updater', SchemeOperators::InvitationsController

      it_behaves_like 'an updater', CompanyOperators::InvitationsController

      it 'expects to be able to update_businesses on company operator invitations' do
        expect(ability).to be_able_to(:update_businesses, CompanyOperators::InvitationsController)
      end

      it 'expects to be able to update_businesses on company operators' do
        expect(ability).to be_able_to(:update_businesses, CompanyOperator)
      end
    end

    context 'with sc_super_user role' do
      before do
        scheme_operator.add_role :sc_super_user
        scheme_operator.add_role :sc_users_r
        scheme_operator.add_role :sc_users_w
        scheme_operator.add_role :sc_users_e
      end

      after do
        scheme_operator.remove_role :sc_super_user
        scheme_operator.remove_role :sc_users_r
        scheme_operator.remove_role :sc_users_w
        scheme_operator.remove_role :sc_users_e
      end

      let(:ability) { Abilities.ability_for(scheme_operator) }

      it_behaves_like 'a reader', SchemeOperator

      it_behaves_like 'an editor', SchemeOperator

      it_behaves_like 'an updater', SchemeOperator

      it_behaves_like 'a writer', SchemeOperator

      it_behaves_like 'NOT a manager', Admin

      it_behaves_like 'NOT a destroyer', CompanyOperator

      it_behaves_like 'NOT a manager', SchemeOperator

      it_behaves_like 'NOT a manager', Scheme

      it_behaves_like 'a reader', SchemeOperators::RegistrationsController

      it_behaves_like 'a writer', SchemeOperators::RegistrationsController

      it_behaves_like 'an editor', SchemeOperators::RegistrationsController

      it_behaves_like 'an updater', SchemeOperators::RegistrationsController

      it 'expects NOT to be able to update_businesses on company operator invitations' do
        expect(ability).not_to be_able_to(:update_businesses, CompanyOperators::InvitationsController)
      end

      it 'expects NOT to be able to update_businesses on company operator invitations' do
        expect(ability).not_to be_able_to(:update_businesses, CompanyOperator)
      end
    end

    context 'with sc_users_r role' do
      before do
        scheme_operator.add_role :sc_user
        scheme_operator.add_role :sc_users_r
      end

      after do
        scheme_operator.remove_role :sc_user_r
        scheme_operator.add_role :sc_users_r
      end

      let(:ability) { Abilities.ability_for(scheme_operator) }

      it_behaves_like 'a reader', SchemeOperator

      it_behaves_like 'NOT an editor', SchemeOperator

      it_behaves_like 'NOT an updater', SchemeOperator

      it_behaves_like 'NOT a writer', SchemeOperator

      it_behaves_like 'NOT a destroyer', SchemeOperator

      it_behaves_like 'NOT a manager', Admin

      it_behaves_like 'NOT a manager', SchemeOperator

      it_behaves_like 'NOT a manager', Scheme

      it_behaves_like 'NOT a manager', SchemeOperators::RegistrationsController

      it_behaves_like 'NOT a manager', CompanyOperators::RegistrationsController
    end

    context 'with sc_users_w role' do
      before do
        scheme_operator.add_role :sc_user
        scheme_operator.add_role :sc_users_r
        scheme_operator.add_role :sc_users_w
      end

      after do
        scheme_operator.remove_role :sc_user_rw
        scheme_operator.add_role :sc_users_r
        scheme_operator.add_role :sc_users_w
      end

      let(:ability) { Abilities.ability_for(scheme_operator) }

      it_behaves_like 'a reader', SchemeOperator

      it_behaves_like 'NOT an editor', SchemeOperator

      it_behaves_like 'NOT an updater', SchemeOperator

      it_behaves_like 'a writer', SchemeOperator

      it_behaves_like 'NOT a destroyer', SchemeOperator

      it_behaves_like 'NOT a manager', Admin

      it_behaves_like 'NOT a manager', SchemeOperator

      it_behaves_like 'NOT a manager', Scheme

      it_behaves_like 'NOT a manager', SchemeOperators::RegistrationsController

      it_behaves_like 'NOT a manager', CompanyOperators::RegistrationsController
    end

    context 'with sc_users_e role' do
      before do
        scheme_operator.add_role :sc_user_rwe
        scheme_operator.add_role :sc_users_r
        scheme_operator.add_role :sc_users_w
        scheme_operator.add_role :sc_users_e
      end

      after do
        scheme_operator.add_role :sc_user_rwe
        scheme_operator.add_role :sc_users_r
        scheme_operator.add_role :sc_users_w
        scheme_operator.add_role :sc_users_e
      end

      let(:ability) { Abilities.ability_for(scheme_operator) }

      it_behaves_like 'a reader', SchemeOperator

      it_behaves_like 'an editor', SchemeOperator

      it_behaves_like 'an updater', SchemeOperator

      it_behaves_like 'a writer', SchemeOperator

      it_behaves_like 'NOT a destroyer', SchemeOperator

      it_behaves_like 'NOT a manager', Admin

      it_behaves_like 'NOT a manager', SchemeOperator

      it_behaves_like 'NOT a manager', Scheme

      it_behaves_like 'NOT a manager', SchemeOperators::RegistrationsController

      it_behaves_like 'NOT a manager', CompanyOperators::RegistrationsController
    end
  end
end
