require 'rails_helper'

RSpec.describe "static_contents/edit", type: :view do
  before(:each) do
    @static_content = assign(:static_content, StaticContent.create!(
      :name => "MyString",
      :data_type => "MyString",
      :content => "MyText"
    ))
  end

  it "renders the edit static_content form" do
    render

    assert_select "form[action=?][method=?]", static_content_path(@static_content), "post" do

      assert_select "input[name=?]", "static_content[name]"

      assert_select "input[name=?]", "static_content[data_type]"

      assert_select "textarea[name=?]", "static_content[content]"
    end
  end
end
