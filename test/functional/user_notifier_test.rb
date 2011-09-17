require 'test_helper'

class UserNotifierTest < ActionMailer::TestCase
  test "activation" do
    mail = UserNotifier.activation
    assert_equal "Activation", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
