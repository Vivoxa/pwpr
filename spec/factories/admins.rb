FactoryGirl.define do
  sequence :email do |n|
    "email#{n}@factory.com"
  end
  factory :admin do
    email
    name 'Marti Mcfly'
    password 'my_password'

    factory :normal_admin do
      email
      name 'Jennifer'
      password 'my_password'
      after(:create) do |admin1|
        %i(normal_admin businesses_r businesses_w businesses_e
           schemes_r schemes_e sc_users_r sc_users_e sc_users_w
           co_users_r co_users_e co_users_w).each do |_permission|
          admin1.add_role :normal_admin
        end
      end
    end
    factory :super_admin do
      email
      name 'Doc Brown'
      password 'my_password'
      after(:create) do |admin|
        admin.add_role :super_admin
        PermissionsForRole::AdminDefinitions::PERMISSIONS.each do |permission|
          admin.add_role(permission)
        end
      end
    end
    factory :no_role do
      email
      name 'John Doe'
      password 'my_password'
    end
  end
end
