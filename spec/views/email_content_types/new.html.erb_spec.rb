require 'rails_helper'

RSpec.describe 'email_content_types/new', type: :view do
  before do
    assign(:email_content_type, EmailContentType.new(
                                  type: ''
    ))
  end

  xit 'renders new email_content_type form' do
    render

    assert_select 'form[action=?][method=?]', email_content_types_path, 'post' do
      assert_select 'input#email_content_type_type[name=?]', 'email_content_type[type]'
    end
  end
end
