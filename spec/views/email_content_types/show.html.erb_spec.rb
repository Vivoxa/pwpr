require 'rails_helper'

RSpec.describe 'email_content_types/show', type: :view do
  before do
    @email_content_type = assign(:email_content_type, EmailContentType.create!(
                                                        type: 'Type'
    ))
  end

  xit 'renders attributes in <p>' do
    render
    expect(rendered).to match(/Type/)
  end
end
