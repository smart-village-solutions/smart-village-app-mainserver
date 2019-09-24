require 'rails_helper'

RSpec.describe "static_contents/new", type: :view do
  before(:each) do
    assign(:static_content, StaticContent.new(
      :name => "MyString",
      :data_type => "MyString",
      :content => "MyText"
    ))
  end

  it "renders new static_content form" do
    render

    assert_select "form[action=?][method=?]", static_contents_path, "post" do

      assert_select "input[name=?]", "static_content[name]"

      assert_select "input[name=?]", "static_content[data_type]"

      assert_select "textarea[name=?]", "static_content[content]"
    end
  end
end
