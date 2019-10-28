require 'rails_helper'

RSpec.describe 'scheme_operators_schemes/index', type: :view do
  before do
    assign(:scheme_operators_schemes, [
             SchemeOperatorsScheme.create!(
               scheme:             2,
               scheme_operator_id: 3
             ),
             SchemeOperatorsScheme.create!(
               scheme:             2,
               scheme_operator_id: 3
             )
           ])
  end

  xit 'renders a list of scheme_operators_schemes' do
    render
    assert_select 'tr>td', text: 2.to_s, count: 2
    assert_select 'tr>td', text: 3.to_s, count: 2
  end
end
