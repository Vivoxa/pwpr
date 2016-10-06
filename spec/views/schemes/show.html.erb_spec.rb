require 'rails_helper'

RSpec.describe "schemes/show", type: :view do
  before(:each) do
    @scheme = assign(:scheme, Scheme.create!(
      :name => "Name",
      :active => false
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/false/)
  end
end
