require 'rails_helper'

RSpec.describe 'contacts/new', type: :view do
  before do
    assign(:contact, Contact.new)
  end

  xit 'renders new contact form' do
    render

    assert_select 'form[action=?][method=?]', contacts_path, 'post' do
    end
  end
end
