require "test_helper"

class RegistrationsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get signup_url
    assert_response :success
    assert_select "h1", text: /Create your account/
    assert_select "input[type=email]"
    assert_select "input[type=password]"
  end

  test "should create user with valid params and sign in" do
    assert_difference "User.count", 1 do
      post registration_url, params: {
        user: {
          email_address: "newuser@example.com",
          password: "password123",
          password_confirmation: "password123"
        }
      }
    end

    assert_redirected_to root_url
    assert cookies[:session_id].present?
  end

  test "should not create user with invalid params" do
    assert_no_difference "User.count" do
      post registration_url, params: {
        user: {
          email_address: "invalid-email",
          password: "short",
          password_confirmation: "mismatch"
        }
      }
    end

    assert_response :unprocessable_entity
    assert_select ".form__errors", minimum: 1
  end
end
