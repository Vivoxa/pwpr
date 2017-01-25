require 'rails_helper'

RSpec.describe 'email_content_types/edit', type: :view do
  before do
    @email_content_type = assign(:email_content_type, EmailContentType.create!(
                                                        type: ''
    ))
  end

  xit 'renders the edit email_content_type form' do
    render

    assert_select 'form[action=?][method=?]', email_content_type_path(@email_content_type), 'post' do
      assert_select 'input#email_content_type_type[name=?]', 'email_content_type[type]'
    end
  end
end
