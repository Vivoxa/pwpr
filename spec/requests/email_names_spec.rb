require 'rails_helper'

RSpec.describe 'EmailNames', type: :request do
  describe 'GET /email_names' do
    it 'works! (now write some real specs)' do
      get email_names_path
      expect(response).to have_http_status(200)
    end
  end
end
