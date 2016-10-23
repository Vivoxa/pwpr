require 'rails_helper'

RSpec.describe 'businesses/edit', type: :view do
  before do
    @business = assign(:business, Business.create!(scheme_id: 1, NPWD: 'jghfjf', SIC: 'gyg'))
  end

  xit 'renders the edit business form' do
    render

    assert_select 'form[action=?][method=?]', business_path(@business), 'post' do
    end
  end
end