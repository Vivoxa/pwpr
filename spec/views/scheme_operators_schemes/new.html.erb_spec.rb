require 'rails_helper'

RSpec.describe 'scheme_operators_schemes/new', type: :view do
  before do
    assign(:scheme_operators_scheme, SchemeOperatorsScheme.new(
                                       scheme:             1,
                                       scheme_operator_id: 1
    ))
  end

  xit 'renders new scheme_operators_scheme form' do
    render

    assert_select 'form[action=?][method=?]', scheme_operators_schemes_path, 'post' do
      assert_select 'input#scheme_operators_scheme_scheme[name=?]', 'scheme_operators_scheme[scheme]'

      assert_select 'input#scheme_operators_scheme_scheme_operator_id[name=?]', 'scheme_operators_scheme[scheme_operator_id]'
    end
  end
end
