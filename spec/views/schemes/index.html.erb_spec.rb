require 'rails_helper'

RSpec.describe 'schemes/index', type: :view do
  before do
    assign(:schemes, [
             Scheme.create!(
               name:   'Name',
               active: false
             ),
             Scheme.create!(
               name:   'Name',
               active: false
             )
           ])
  end

  it 'renders a list of schemes' do
    render
    assert_select 'h3', value: 'card-header', text: 'Name (not active)', count: 2
    assert_select 'p', value: 'card-footer', text: '', count: 2
  end
end
