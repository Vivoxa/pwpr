FactoryGirl.define do
  factory :admin do
    email 'marti.mcfly@back_to_future.com'
    name 'Marti Mcfly'
    password 'my_password'

    factory :admin_full_access do
      email 'doc.brown@back_to_future.com'
      name 'Doc Brown'
      password 'my_password'
      after(:create) do |admin|
        admin.add_role 'full_access'
      end
    end
  end
end
