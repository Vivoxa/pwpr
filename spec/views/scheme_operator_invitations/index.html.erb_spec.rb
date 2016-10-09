require 'rails_helper'

RSpec.describe 'scheme_operator_invitations/index', type: :view do
  before do
    assign(:scheme_operator_invitations, [
      SchemeOperatorInvitation.create!,
      SchemeOperatorInvitation.create!
    ])
  end

  it 'renders a list of scheme_operator_invitation' do
    render
  end
end
