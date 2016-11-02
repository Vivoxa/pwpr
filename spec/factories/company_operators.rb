FactoryGirl.define do
  rwe_permissions = %i(co_users_r co_users_w co_users_e)

  factory :company_operator do |co|
    email
    name 'Jennifer'
    password 'mypassword'
    confirmed_at DateTime.now
    approved true

    co.after :build do |instance|
      instance.business_id = FactoryGirl.create(:business).id
    end

    factory :company_operator_with_director do |co_d|
      co_d.after :build do |instance|
        instance.business_id = FactoryGirl.create(:business).id
      end
      after(:create) do |co|
        co.add_role :sc_director
        rwe_permissions.each do |permission|
          co.add_role permission
        end
      end
    end

    factory :company_operator_with_director_inactive do |co_d|
      co_d.after :build do |instance|
        instance.business_id = FactoryGirl.create(:business).id
        instance.approved = false
      end
      after(:create) do |co|
        co.add_role :sc_director
        rwe_permissions.each do |permission|
          co.add_role permission
        end
      end
    end

    factory :company_operator_with_co_super_user do |co_s|
      co_s.after :build do |instance|
        instance.business_id = FactoryGirl.create(:business).id
      end
      after(:create) do |co|
        co.add_role :sc_contact
        rwe_permissions.each do |permission|
          co.add_role permission
        end
      end
    end

    factory :company_operator_no_role do |co_r|
      co_r.after :build do |instance|
        instance.business_id = FactoryGirl.create(:business).id
      end
    end

    factory :company_operator_with_co_users_r do |co_r|
      co_r.after :build do |instance|
        instance.business_id = FactoryGirl.create(:business).id
      end
      after(:create) do |co|
        co.add_role :co_users_r
      end
    end

    factory :company_operator_with_co_users_w do |co_w|
      co_w.after :build do |instance|
        instance.business_id = FactoryGirl.create(:business).id
      end
      after(:create) do |co|
        co.add_role :co_users_r
        co.add_role :co_users_w
      end
    end

    factory :company_operator_with_co_users_e do |co_e|
      co_e.after :build do |instance|
        instance.business_id = FactoryGirl.create(:business).id
      end
      after(:create) do |co|
        co.add_role :sc_contact
        rwe_permissions.each do |permission|
          co.add_role permission
        end
      end
    end
  end
end
