require 'rails_helper'

RSpec.describe "scheme_operator_invitations/new", type: :view do
  before(:each) do
    assign(:scheme_operator_invitation, SchemeOperatorInvitation.new())
  end

  it "renders new scheme_operator_invitation form" do
    render

    assert_select "form[action=?][method=?]", scheme_operator_invitations_path, "post" do
    end
  end
end
