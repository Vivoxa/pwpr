FactoryGirl.define do
  sequence :email do |n|
    "email#{n}@factory.com"
  end
  factory :admin do
    email
    name 'Marti Mcfly'
    password 'my_password'

    factory :restricted_admin do
      email
      name 'Jennifer'
      password 'my_password'
      after(:create) do |admin1|
        admin1.add_role :restricted_admin
        permission_helper = PermissionsForRole::AdminDefinitions.new
        permission_helper.assign_mandatory_permissions_for_role!(admin1, :restricted_admin)
      end
    end

    factory :normal_admin do
      email
      name 'Jennifer'
      password 'my_password'
      after(:create) do |admin1|
        admin1.add_role :normal_admin
        permission_helper = PermissionsForRole::AdminDefinitions.new
        permission_helper.assign_mandatory_permissions_for_role!(admin1, :normal_admin)
      end
    end
    factory :super_admin do
      email
      name 'Doc Brown'
      password 'my_password'
      after(:create) do |admin|
        admin.add_role :super_admin
        permission_helper = PermissionsForRole::AdminDefinitions.new
        permission_helper.assign_mandatory_permissions_for_role!(admin, :super_admin)
      end
    end
    factory :no_role do
      email
      name 'John Doe'
      password 'my_password'
    end
  end
end
