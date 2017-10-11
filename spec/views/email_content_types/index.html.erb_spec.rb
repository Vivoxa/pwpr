require 'rails_helper'

RSpec.describe 'email_content_types/index', type: :view do
  before do
    assign(:email_content_types, [
             EmailContentType.create!(
               type: 'Type'
             ),
             EmailContentType.create!(
               type: 'Type'
             )
           ])
  end

  xit 'renders a list of email_content_types' do
    render
    assert_select 'tr>td', text: 'Type'.to_s, count: 2
  end
end
