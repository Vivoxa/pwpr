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
        admin1.add_role :normal_admin
        admin1.add_role :businesses_r
        admin1.add_role :businesses_w
        admin1.add_role :businesses_e

        admin1.add_role :schemes_r
        admin1.add_role :schemes_e

        admin1.add_role :sc_users_r
        admin1.add_role :sc_users_e
        admin1.add_role :sc_users_w

        admin1.add_role :co_users_r
        admin1.add_role :co_users_e
        admin1.add_role :co_users_w
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
