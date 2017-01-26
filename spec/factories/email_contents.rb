FactoryGirl.define do
  factory :email_content do
    scheme_id 1
    email_content_type nil
    email_name nil
    intro 'MyString'
    title 'MyString'
    body 'MyText'
    footer 'MyString'
  end
end
