require 'test_helper'

class UserNotifierTest < ActionMailer::TestCase
  test "activation" do
    mail = UserNotifier.activation
    assert_equal "Activation", mail.subject
    assert_equal ["john@synapticmishap.co.uk"], mail.to
    assert_equal ["jgediting@gmail.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
