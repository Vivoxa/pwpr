FactoryGirl.define do
  factory :company_operator do
    email 'jennifer@back_to_the_future.com'
    name 'Jennifer'
    password 'mypassword'
    confirmed_at DateTime.now

    factory :company_operator_with_director do
      after(:create) do |co|
        co.add_role 'co_director'
      end
    end

    factory :company_operator_with_contact do
      after(:create) do |co|
        co.add_role 'co_contact'
      end
    end

    factory :company_operator_with_co_user_r do
      after(:create) do |co|
        co.add_role 'co_user_r'
      end
    end

    factory :company_operator_with_co_user_rw do
      after(:create) do |co|
        co.add_role 'co_user_rw'
      end
    end

    factory :company_operator_with_co_user_rwe do
      after(:create) do |co|
        co.add_role 'co_user_rwe'
      end
    end
  end
end
