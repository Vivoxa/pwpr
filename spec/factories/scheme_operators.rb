FactoryGirl.define do
  factory :scheme_operator do
    first_name 'John'
    last_name 'Doe'
    email
    approved true
    password 'Min700si'
    confirmed_at DateTime.now - 1.day

    factory :not_approved_scheme_operator do
      first_name 'not'
      last_name 'approved'
      email
      approved false
      password 'Min700si'
    end

    factory :scheme_operator_with_sc_user do
      after(:create) do |scheme_operator, _evaluator|
        create_list(:scheme_with_business, 1, scheme_operators: [scheme_operator])
        PermissionsForRole::SchemeOperatorDefinitions.new.permissions_for_role(:sc_user).each do |permission, has|
          scheme_operator.add_role permission if has[:checked]
        end
      end
    end

    after(:create) do |scheme_operator, _evaluator|
      create_list(:scheme_with_business, 1, scheme_operators: [scheme_operator])
      scheme_operator.role_list.each do |role|
        scheme_operator.remove_role role
      end
    end

    factory :scheme_operator_with_director do
      after(:create) do |scheme_operator_with_director, _evaluator|
        scheme_operator_with_director.sc_director!
        scheme_operator_with_director.remove_role :sc_user
        PermissionsForRole::SchemeOperatorDefinitions.new.permissions_for_role(:sc_director).each do |permission, has|
          scheme_operator_with_director.add_role permission if has[:checked]
        end
      end
    end

    factory :scheme_operator_with_super_user do
      after(:create) do |scheme_operator, _evaluator|
        scheme_operator.sc_super_user!
        scheme_operator.remove_role :sc_user
        PermissionsForRole::SchemeOperatorDefinitions.new.permissions_for_role(:sc_super_user).each do |permission, has|
          scheme_operator.add_role permission if has[:checked]
        end
      end
    end
  end
end
