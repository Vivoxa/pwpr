require 'rails_helper'

RSpec.describe "SchemeOperatorInvitations", type: :request do
  describe "GET /scheme_operator_invitations" do
    it "works! (now write some real specs)" do
      get scheme_operator_invitations_path
      expect(response).to have_http_status(200)
    end
  end
end
