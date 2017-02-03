FactoryGirl.define do
  factory :business do
    name 'MyString'
    company_number 'MyString'
    sequence(:NPWD) { |n| "NPWD#{n}" }
    scheme_id 1
    scheme_ref SecureRandom.uuid
    sic_code_id 1
    year_first_reg '2010'
    scheme_status_code_id 1
    registration_status_code_id 1
  end
end
