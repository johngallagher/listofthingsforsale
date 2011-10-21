require 'spec_helper'

describe "backgrounds/edit.html.erb" do
  before(:each) do
    @background = assign(:background, stub_model(Background))
  end

  it "renders the edit background form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => backgrounds_path(@background), :method => "post" do
    end
  end
end
