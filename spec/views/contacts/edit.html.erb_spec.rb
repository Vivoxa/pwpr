require 'rails_helper'

RSpec.describe 'contacts/edit', type: :view do
  before do
    @contact = assign(:contact, Contact.create!(
                                  address_type_id: 2,
                                  business_id:     1,
                                  first_name:      'nigel',
                                  last_name:       'surtees',
                                  title:           'Mr',
                                  email:           'somebody@emai.com',
                                  telephone_1:     '09876543212',
                                  telephone_2:     '09876543233',
                                  fax:             '987864357389485'
    ))
  end

  xit 'renders the edit contact form' do
    render

    assert_select 'form[action=?][method=?]', business_contact_path(@contact), 'post' do
    end
  end
end
