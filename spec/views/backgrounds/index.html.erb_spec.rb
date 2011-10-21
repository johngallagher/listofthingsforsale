require 'spec_helper'

describe "backgrounds/index.html.erb" do
  before(:each) do
    assign(:backgrounds, [
      stub_model(Background),
      stub_model(Background)
    ])
  end

  it "renders a list of backgrounds" do
    render
  end
end
