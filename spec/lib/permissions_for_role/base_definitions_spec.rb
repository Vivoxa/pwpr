require 'rails_helper'

RSpec.describe PermissionsForRole::BaseDefinitions do
  subject(:permissions_helper) { described_class.new }

  describe '#assign_default_permissions_for_role!' do
    context 'when assigning to a new admin' do
      it 'expects permissions to be assigned correctly' do
        admin = Admin.create(email:    'test_admin101@pwpr.com',
                             password: 'my password')

        admin.role_list.each do |role|
          admin.remove_role role
        end

        permissions_helper = PermissionsForRole::AdminDefinitions.new

        permissions_helper.assign_mandatory_permissions_for_role!(admin, :restricted_admin)
        permissions_helper.permissions_for_role(:restricted_admin).each do |permission, can_have|
          expect(admin.has_role?(permission)).to be true if can_have[:checked] && can_have[:locked]
        end
      end
    end

    context 'when assigning to a new scheme operator' do
      it 'expects permissions to be assigned correctly' do
        sc_operator = SchemeOperator.create(first_name: 'rspec owner',
                                            last_name:  'last',
                                            email:      'test_sc101@pwpr.com',
                                            password:   'my password')

        sc_operator.role_list.each do |role|
          sc_operator.remove_role role
        end

        permissions_helper = PermissionsForRole::SchemeOperatorDefinitions.new

        permissions_helper.assign_mandatory_permissions_for_role!(sc_operator, :sc_user)

        permissions_helper.permissions_for_role(:sc_user).each do |permission, can_have|
          expect(sc_operator.has_role?(permission)).to be true if can_have[:checked] && can_have[:locked]
        end
      end
    end

    context 'when assigning to a new company operator' do
      it 'expects permissions to be assigned correctly' do
        co_operator = CompanyOperator.create(first_name:  'John',
                                             last_name:   'Smith',
                                             email:       'test_co101@pwpr.com',
                                             password:    'my password',
                                             business_id: Business.last.id)

        co_operator.role_list.each do |role|
          co_operator.remove_role role
        end

        permissions_helper = PermissionsForRole::CompanyOperatorDefinitions.new

        permissions_helper.assign_mandatory_permissions_for_role!(co_operator, :co_user)
        permissions_helper.permissions_for_role(:co_user).each do |permission, can_have|
          expect(co_operator.has_role?(permission)).to be true if can_have[:checked] && can_have[:locked]
        end
      end
    end
  end

  describe 'permissions_for_role' do
    it 'expects a NotImplementedError error to be raised' do
      expect { permissions_helper.permissions_for_role(:restricted_admin) }.to raise_error(NotImplementedError)
    end
  end
end
