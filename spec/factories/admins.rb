FactoryGirl.define do
  factory :admin do
    email 'marti.mcfly@back_to_future.com'
    name 'Marti Mcfly'
    password 'my_password'

    factory :admin_super_admin do
      email 'doc.brown@back_to_future.com'
      name 'Doc Brown'
      password 'my_password'
      after(:create) do |admin|
        admin.add_role 'super_admin'
      end
    end
  end
end
