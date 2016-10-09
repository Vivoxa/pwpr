require 'rails_helper'

RSpec.describe 'scheme_operator_invitations/show', type: :view do
  before do
    @scheme_operator_invitation = assign(:scheme_operator_invitation, SchemeOperatorInvitation.create!)
  end

  it 'renders attributes in <p>' do
    render
  end
end
