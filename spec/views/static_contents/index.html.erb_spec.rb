require 'rails_helper'

RSpec.describe "static_contents/index", type: :view do
  before(:each) do
    assign(:static_contents, [
      StaticContent.create!(
        :name => "Name",
        :data_type => "Data Type",
        :content => "MyText"
      ),
      StaticContent.create!(
        :name => "Name",
        :data_type => "Data Type",
        :content => "MyText"
      )
    ])
  end

  it "renders a list of static_contents" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "Data Type".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
  end
end
