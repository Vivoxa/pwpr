require 'rails_helper'

RSpec.describe 'email_names/edit', type: :view do
  before do
    @email_name = assign(:email_name, EmailName.create!(
                                        name: 'MyString'
    ))
  end

  xit 'renders the edit email_name form' do
    render

    assert_select 'form[action=?][method=?]', email_name_path(@email_name), 'post' do
      assert_select 'input#email_name_name[name=?]', 'email_name[name]'
    end
  end
end
