require 'rails_helper'

RSpec.describe SchemeOperator, type: :model do
  let(:scheme) { Scheme.first }
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
    context 'Constants' do
      describe 'ROLES' do
        it 'expects the ROLES constant to exist' do
          expect(subject.class::ROLES).not_to be_nil
        end

        it 'load the correct values in ROLES' do
          expect(subject.class::ROLES).to eq %w(sc_director sc_super_user sc_user).freeze
        end
      end

      describe 'PERMISSIONS' do
        it 'expects the PERMISSIONS constant to exist' do
          expect(subject.class::PERMISSIONS).not_to be_nil
        end

        it 'load the correct values in PERMISSIONS' do
          expect(subject.class::PERMISSIONS).to eq %w(sc_user_r sc_user_rw sc_user_rwe).freeze
        end
      end
    end

    it 'expects the correct roles to be available' do
      expect(SchemeOperator.available_role_names).to eq %w(sc_director sc_super_user sc_user sc_user_r sc_user_rw sc_user_rwe)
    end

    it 'expects sc_director to be an available role' do
      expect(subject.allowed_role?(:sc_director)).to be true
    end

    it 'expects sc_super_user to be an available role' do
      expect(subject.allowed_role?(:sc_super_user)).to be true
    end

    it 'expects sc_user to be an available role' do
      expect(subject.allowed_role?(:sc_user)).to be true
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
      let(:ability) { Ability.new(scheme_operator) }

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
        scheme_operator.add_role(:sc_director)
      end

      after do
        scheme_operator.remove_role(:sc_director)
      end

      let(:ability) { Ability.new(scheme_operator) }

      it_behaves_like 'NOT a manager', Admin

      it_behaves_like 'a writer', CompanyOperator

      it_behaves_like 'a writer', SchemeOperator

      it_behaves_like 'a writer', Scheme

      it_behaves_like 'a manager', SchemeOperators::RegistrationsController

      it_behaves_like 'a manager', CompanyOperators::RegistrationsController

      it_behaves_like 'a manager', SchemeOperators::InvitationsController

      it_behaves_like 'a manager', CompanyOperators::InvitationsController
    end

    context 'with sc_super_user role' do
      before do
        scheme_operator.add_role(:sc_super_user)
      end

      after do
        scheme_operator.remove_role(:sc_super_user)
      end

      let(:ability) { Ability.new(scheme_operator) }

      it_behaves_like 'a reader', SchemeOperator

      it_behaves_like 'an editor', SchemeOperator

      it_behaves_like 'an updater', SchemeOperator

      it_behaves_like 'a writer', SchemeOperator

      it_behaves_like 'NOT a manager', Admin

      it_behaves_like 'NOT a destroyer', CompanyOperator

      it_behaves_like 'NOT a manager', SchemeOperator

      it_behaves_like 'NOT a manager', Scheme

      it_behaves_like 'a manager', SchemeOperators::RegistrationsController

      it_behaves_like 'a manager', CompanyOperators::RegistrationsController
    end

    context 'with sc_user_r role' do
      before do
        scheme_operator.add_role(:sc_user_r)
      end

      after do
        scheme_operator.remove_role(:sc_user_r)
      end

      let(:ability) { Ability.new(scheme_operator) }

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

    context 'with sc_user_rw role' do
      before do
        scheme_operator.add_role(:sc_user_rw)
      end

      after do
        scheme_operator.remove_role(:sc_user_rw)
      end

      let(:ability) { Ability.new(scheme_operator) }

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

    context 'with sc_user_rwe role' do
      before do
        scheme_operator.add_role(:sc_user_rwe)
      end

      after do
        scheme_operator.remove_role(:sc_user_rwe)
      end

      let(:ability) { Ability.new(scheme_operator) }

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
