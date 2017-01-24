require 'rails_helper'

RSpec.describe 'email_names/index', type: :view do
  before do
    assign(:email_names, [
             EmailName.create!(
               name: 'Name'
             ),
             EmailName.create!(
               name: 'Name'
             )
           ])
  end

  xit 'renders a list of email_names' do
    render
    assert_select 'tr>td', text: 'Name'.to_s, count: 2
  end
end
