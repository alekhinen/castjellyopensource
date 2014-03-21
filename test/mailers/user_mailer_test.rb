require 'test_helper'

class UserMailerTest < ActionMailer::TestCase
  
  tests UserMailer

  # Test the registration confirmation method found in mailers/user_mailer
  test "registration_confirmation" do
    expected         = new_mail
    expected.from    = "nick@castjelly.com"
    expected.to      = "nick@example.com"
    expected.subject = "CastJelly - Registration Confirmation"
    expected.date    = Time.now

    actual = nil
    assert_nothing_raised { actual = UserMailer.registration_confirmation(@recipient) }
    assert_not_nil actual
 
    expected.message_id = '<123@456>'
    actual.message_id = '<123@456>'
 
    assert_equal expected.encoded, actual.encoded
  end
end
