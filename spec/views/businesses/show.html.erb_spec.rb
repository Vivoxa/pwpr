require 'rails_helper'

RSpec.describe 'businesses/show', type: :view do
  before do
    @business = assign(:business, Business.create!(scheme_id: 1, NPWD: 'jghfjf', SIC: 'gyg'))
  end

  it 'renders attributes in <p>' do
    render
  end
end