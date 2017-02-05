FactoryGirl.define do
  factory :scheme do
    name 'MyScheme'
    active true
    scheme_country_code

    factory :scheme_with_business do
      after(:create) do |scheme, _evaluator|
        create_list(:business, 1, scheme: scheme)
      end
    end
  end
end
