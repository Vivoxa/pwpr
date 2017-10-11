require 'rails_helper'

RSpec.describe 'EmailContentTypes', type: :request do
  describe 'GET /email_content_types' do
    xit 'works! (now write some real specs)' do
      get email_content_types_path
      expect(response).to have_http_status(200)
    end
  end
end
