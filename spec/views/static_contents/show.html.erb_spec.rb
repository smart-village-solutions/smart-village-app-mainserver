require 'rails_helper'

RSpec.describe "static_contents/show", type: :view do
  before(:each) do
    @static_content = assign(:static_content, StaticContent.create!(
      :name => "Name",
      :data_type => "Data Type",
      :content => "MyText"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/Data Type/)
    expect(rendered).to match(/MyText/)
  end
end
