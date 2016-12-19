FactoryGirl.define do
  factory :emailed_report do
    report_name 'MyString'
    date_last_sent '2016-12-19 19:56:14'
    business nil
    sent_by_id 1
    sent_by_type 'MyString'
  end
end
