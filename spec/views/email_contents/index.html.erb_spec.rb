require 'rails_helper'

RSpec.describe 'email_contents/index', type: :view do
  before do
    assign(:email_contents, [
             EmailContent.create!(
               scheme_id:          2,
               email_content_type_id: 1,
               email_name_id:         1,
               intro:              'Intro',
               title:              'Title',
               body:               'MyText',
               footer:             'Footer'
             ),
             EmailContent.create!(
               scheme_id:          2,
               email_content_type_id: 1,
               email_name_id:         1,
               intro:              'Intro',
               title:              'Title',
               body:               'MyText',
               footer:             'Footer'
             )
           ])
  end

  it 'renders a list of email_contents' do
    render
    assert_select 'tr>td', text: 2.to_s, count: 2
    assert_select 'tr>td', text: 2.to_s, count: 2
    assert_select 'tr>td', text: 2.to_s, count: 2
    assert_select 'tr>td', text: 'Intro'.to_s, count: 2
    assert_select 'tr>td', text: 'Title'.to_s, count: 2
    assert_select 'tr>td', text: 'MyText'.to_s, count: 2
    assert_select 'tr>td', text: 'Footer'.to_s, count: 2
  end
end
