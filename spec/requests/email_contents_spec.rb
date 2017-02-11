require 'rails_helper'

RSpec.describe 'EmailContents', type: :request do
  describe 'GET /email_contents' do
    xit 'works! (now write some real specs)' do
      get email_contents_path
      expect(response).to have_http_status(200)
    end
  end
end
