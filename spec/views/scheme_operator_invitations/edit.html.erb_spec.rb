require 'rails_helper'

RSpec.describe "scheme_operator_invitations/edit", type: :view do
  before(:each) do
    @scheme_operator_invitation = assign(:scheme_operator_invitation, SchemeOperatorInvitation.create!())
  end

  it "renders the edit scheme_operator_invitation form" do
    render

    assert_select "form[action=?][method=?]", scheme_operator_invitation_path(@scheme_operator_invitation), "post" do
    end
  end
end
