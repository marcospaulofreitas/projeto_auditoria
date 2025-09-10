require "test_helper"

class SessionsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get login_url
    assert_response :success
  end

  test "should get create" do
    post login_url, params: { email: operators(:one).email, password: "password" }
    assert_redirected_to root_path
  end

  test "should get destroy" do
    delete logout_url
    assert_redirected_to login_path
  end
end
