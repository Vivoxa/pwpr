require 'rails_helper'

RSpec.describe 'email_names/new', type: :view do
  before do
    assign(:email_name, EmailName.new(
                          name: 'MyString'
    ))
  end

  xit 'renders new email_name form' do
    render

    assert_select 'form[action=?][method=?]', email_names_path, 'post' do
      assert_select 'input#email_name_name[name=?]', 'email_name[name]'
    end
  end
end
