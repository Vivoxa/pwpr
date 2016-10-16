FactoryGirl.define do
  factory :company_operator do |co|
    email 'jennifer@back_to_the_future.com'
    name 'Jennifer'
    password 'mypassword'
    confirmed_at DateTime.now

    co.after :build do |instance|
      instance.business_id = FactoryGirl.create(:business).id
    end

    factory :company_operator_with_director do |co_d|
      co_d.after :build do |instance|
        instance.business_id = FactoryGirl.create(:business).id
      end
      after(:create) do |co|
        co.add_role 'co_director'
      end
    end

    factory :company_operator_with_contact do |co_c|
      co_c.after :build do |instance|
        instance.business_id = FactoryGirl.create(:business).id
      end
      after(:create) do |co|
        co.add_role 'co_contact'
      end
    end

    factory :company_operator_with_co_user_r do |co_r|
      co_r.after :build do |instance|
        instance.business_id = FactoryGirl.create(:business).id
      end
      after(:create) do |co|
        co.add_role 'co_user_r'
      end
    end

    factory :company_operator_with_co_user_rw do |co_rw|
      co_rw.after :build do |instance|
        instance.business_id = FactoryGirl.create(:business).id
      end
      after(:create) do |co|
        co.add_role 'co_user_rw'
      end
    end

    factory :company_operator_with_co_user_rwe do |co_rwe|
      co_rwe.after :build do |instance|
        instance.business_id = FactoryGirl.create(:business).id
      end
      after(:create) do |co|
        co.add_role 'co_user_rwe'
      end
    end
  end
end
