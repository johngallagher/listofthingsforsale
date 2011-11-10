require 'test_helper'

class UserNotifierTest < ActionMailer::TestCase
  it "activation" do
    mail = UserNotifier.activation
    mail.subject.should == "Activation"
    mail.to.should == ["john@synapticmishap.co.uk"]
    mail.from.should == ["jgediting@gmail.com"]
    assert_match "Hi", mail.body.encoded
  end

end
