require 'rails_helper'

RSpec.describe 'email_contents/show', type: :view do
  before do
    @email_content = assign(:email_content, EmailContent.create!(
                                              scheme_id:          2,
                                              email_content_type_id: 1,
                                              email_name_id:         1,
                                              intro:              'Intro',
                                              title:              'Title',
                                              body:               'MyText',
                                              footer:             'Footer'
    ))
  end

  it 'renders attributes in <p>' do
    render
    expect(rendered).to match(/2/)
    expect(rendered).to match(//)
    expect(rendered).to match(//)
    expect(rendered).to match(/Intro/)
    expect(rendered).to match(/Title/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/Footer/)
  end
end
