require 'rails_helper'

RSpec.describe 'email_contents/edit', type: :view do
  xit 'renders the edit email_content form' do
    render

    assert_select 'form[action=?][method=?]', email_content_path(@email_content), 'post' do
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
