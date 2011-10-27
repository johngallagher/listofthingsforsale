require 'spec_helper'

describe "backgrounds/show.html.erb" do
  before(:each) do
    @background = assign(:background, stub_model(Background))
  end

  it "renders attributes in <p>" do
    render
  end
end
