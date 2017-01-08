require 'rails_helper'

RSpec.describe 'contacts/show', type: :view do
  before do
    @contact = assign(:contact, Contact.create!)
  end

  xit 'renders attributes in <p>' do
    render
  end
end
