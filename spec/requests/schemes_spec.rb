require 'rails_helper'

RSpec.describe "Schemes", type: :request do
  describe "GET /schemes" do
    it "works! (now write some real specs)" do
      get schemes_path
      expect(response).to have_http_status(200)
    end
  end
end
