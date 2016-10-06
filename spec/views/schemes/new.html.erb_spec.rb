require 'rails_helper'

RSpec.describe "schemes/new", type: :view do
  before(:each) do
    assign(:scheme, Scheme.new(
      :name => "MyString",
      :active => false
    ))
  end

  it "renders new scheme form" do
    render

    assert_select "form[action=?][method=?]", schemes_path, "post" do

      assert_select "input#scheme_name[name=?]", "scheme[name]"

      assert_select "input#scheme_active[name=?]", "scheme[active]"
    end
  end
end
