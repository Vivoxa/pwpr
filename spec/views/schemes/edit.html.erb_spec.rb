require 'rails_helper'

RSpec.describe "schemes/edit", type: :view do
  before(:each) do
    @scheme = assign(:scheme, Scheme.create!(
      :name => "MyString",
      :active => false
    ))
  end

  it "renders the edit scheme form" do
    render

    assert_select "form[action=?][method=?]", scheme_path(@scheme), "post" do

      assert_select "input#scheme_name[name=?]", "scheme[name]"

      assert_select "input#scheme_active[name=?]", "scheme[active]"
    end
  end
end
