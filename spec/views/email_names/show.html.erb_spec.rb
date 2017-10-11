require 'rails_helper'

RSpec.describe 'email_names/show', type: :view do
  before do
    @email_name = assign(:email_name, EmailName.create!(
                                        name: 'Name'
    ))
  end

  xit 'renders attributes in <p>' do
    render
    expect(rendered).to match(/Name/)
  end
end
