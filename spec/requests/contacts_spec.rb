require 'rails_helper'

RSpec.describe 'Contacts', type: :request do
  describe 'GET /contacts' do
    xit 'works! (now write some real specs)' do
      get business_contacts_path
      expect(response).to have_http_status(200)
    end
  end
end