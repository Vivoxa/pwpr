require 'rails_helper'

RSpec.describe 'contacts/index', type: :view do
  before do
    assign(:contacts, [
             Contact.create!,
             Contact.create!
           ])
  end

  xit 'renders a list of contacts' do
    render
  end
end
