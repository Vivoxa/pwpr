require 'rails_helper'

RSpec.describe Admin, type: :model do
  let(:expected_roles) { %w(super_admin normal_admin restricted_admin).freeze }
  let(:expected_available_roles) do
    %w(super_admin normal_admin restricted_admin admins_r
       admins_w admins_e admins_d sc_users_r sc_users_w
       sc_users_e sc_users_d co_users_r co_users_w co_users_d
       co_users_e businesses_r businesses_w businesses_d businesses_e
       schemes_r schemes_w schemes_d schemes_e).freeze
  end

  let(:expected_permissions) do
    %w(admins_r admins_w admins_e admins_d
       sc_users_r sc_users_w sc_users_e sc_users_d
       co_users_r co_users_w co_users_d co_users_e
       businesses_r businesses_w businesses_d businesses_e
       schemes_r schemes_w schemes_d schemes_e).freeze
  end

  before do
    subject.email = 'nigelsurtees@wvivoxa.com'
    subject.password = 'khgsdfgaskgfdkag'
    subject.save
  end

  context 'when an Admin is created' do
    it 'expects the admin to have the restricted admin role' do
      admin = Admin.create(email: 'admin101@pwpr.com', password: 'my password', name: 'fred')
      %i(businesses_r schemes_r sc_users_r co_users_r).each do |permission|
        expect(admin.has_role?(permission)).to eq true
      end
    end
  end

  context 'schemes' do
    it 'expects admins to have access to all schemes' do
      expect(subject.schemes).to eq(Scheme.all)
    end
  end

  context 'Roles' do
    context 'Constants' do
      describe 'ROLES' do
        it 'expects the ROLES constant to exist' do
          expect(subject.class::ROLES).not_to be_nil
        end

        it 'load the correct values in ROLES' do
          expect(subject.class::ROLES).to eq expected_roles
        end
      end

      describe 'PERMISSIONS' do
        it 'expects the PERMISSIONS constant to exist' do
          expect(subject.class::PERMISSIONS).not_to be_nil
        end

        it 'load the correct values in PERMISSIONS' do
          expect(subject.class::PERMISSIONS).to eq expected_permissions
        end
      end
    end

    it 'expects the correct role to be available' do
      expect(Admin.available_role_names).to eq expected_available_roles
    end

    it 'expects super_admin to be an available role' do
      expect(subject.allowed_role?(:super_admin)).to be true
    end

    it 'expects name to be an attribute' do
      expect(subject.respond_to?(:name)).to be true
    end

    context 'when assigning a role' do
      it 'expects the Admin to have that role' do
        subject.add_role :super_admin
        expect(subject.has_role?(:super_admin)).to be true
        expect(subject.super_admin?).to be true
        subject.super_admin!
        expect(subject.super_admin?).to be true
        expect(subject.has_role?(:super_admin)).to be true
      end
    end

    context 'when removing a role' do
      it 'expects the Admin to NOT have that role' do
        subject.add_role :super_admin
        expect(subject.has_role?(:super_admin)).to be true
        subject.remove_role :super_admin
        expect(subject.has_role?(:super_admin)).to be false
      end
    end
  end
  context 'abilities' do
    context 'with Role super_admin' do
      let(:super_admin) { FactoryGirl.create(:super_admin) }
      let(:ability) { Abilities.ability_for(super_admin) }

      it_behaves_like 'a manager', Admin

      it_behaves_like 'a manager', CompanyOperator

      it_behaves_like 'a manager', Scheme

      it_behaves_like 'a manager', SchemeOperator

      it_behaves_like 'a manager', SchemeOperators::RegistrationsController

      it_behaves_like 'a manager', CompanyOperators::RegistrationsController
    end

    context 'with no Role' do
      subject(:normal_admin) { FactoryGirl.create(:normal_admin) }
      let(:ability) { Abilities.ability_for(normal_admin) }

      it_behaves_like 'NOT a manager', Admin

      it_behaves_like 'NOT a manager', CompanyOperator

      it_behaves_like 'NOT a manager', SchemeOperator

      it_behaves_like 'NOT a manager', Scheme

      it_behaves_like 'NOT a manager', SchemeOperators::RegistrationsController

      it_behaves_like 'NOT a manager', CompanyOperators::RegistrationsController
    end
  end
end
