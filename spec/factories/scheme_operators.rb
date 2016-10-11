FactoryGirl.define do
  factory :scheme_operator do
    email 'jennifer@back_to_the_future.com'
    name 'Jennifer'
    password 'mypassword'
    confirmed_at DateTime.now
    schemes [Scheme.create(name: 'test scheme', active: true)]

    factory :scheme_operator_with_director do
      after(:create) do |co|
        co.add_role 'sc_director'
      end
    end
  end
end
