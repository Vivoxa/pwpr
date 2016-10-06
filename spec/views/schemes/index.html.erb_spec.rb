require 'rails_helper'

RSpec.describe "schemes/index", type: :view do
  before(:each) do
    assign(:schemes, [
      Scheme.create!(
        :name => "Name",
        :active => false
      ),
      Scheme.create!(
        :name => "Name",
        :active => false
      )
    ])
  end

  it "renders a list of schemes" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
  end
end
