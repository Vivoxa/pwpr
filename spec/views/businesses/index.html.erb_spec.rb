require 'rails_helper'

RSpec.describe 'businesses/index', type: :view do
  before do
    assign(:businesses, [
             Business.create!(NPWD: 'jghfjf', SIC: 'gyg'),
             Business.create!(NPWD: 'jghfjf', SIC: 'gyg')
           ])
  end

  it 'renders a list of businesses' do
    render
  end
end
