require 'test_helper'
require 'rails/performance_test_help'

class CreateShopTest < ActionDispatch::PerformanceTest
  # Replace this with your real tests.
  it "create shop with four items" do
    post '/shops', :shop => { :description => "For example:\r\n\r\niPod Touch 16gig 2nd Gen &pound;70 In excellent condition\r\nFender Jazz Bass Guitar &pound;280 Never been played\r\nNouveau Banjo CD &pound;5 The London quintet&#x27;s infamous first album\r\nPearl Bracelet &pound;35 Stunning original Art Deco piece"}
  end
end
