require 'rails_helper'

RSpec.describe 'email_contents/new', type: :view do
  before do
    assign(:email_content, EmailContent.new(
                             scheme_id:          1,
                             email_content_type_id: 1,
                             email_name_id:         1,
                             intro:              'MyString',
                             title:              'MyString',
                             body:               'MyText',
                             footer:             'MyString'
    ))
  end

  it 'renders new email_content form' do
    render

    assert_select 'form[action=?][method=?]', email_contents_path, 'post' do
      assert_select 'input#email_content_scheme_id[name=?]', 'email_content[scheme_id]'

      assert_select 'input#email_content_email_content_type_id[name=?]', 'email_content[email_content_type_id]'

      assert_select 'input#email_content_email_name_id[name=?]', 'email_content[email_name_id]'

      assert_select 'input#email_content_intro[name=?]', 'email_content[intro]'

      assert_select 'input#email_content_title[name=?]', 'email_content[title]'

      assert_select 'textarea#email_content_body[name=?]', 'email_content[body]'

      assert_select 'input#email_content_footer[name=?]', 'email_content[footer]'
    end
  end
end
