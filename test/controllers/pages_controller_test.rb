require "test_helper"

class PagesControllerTest < ActionDispatch::IntegrationTest
  test "should get up" do
    get pages_up_url
    assert_response :success
  end

  test "should get home" do
    get pages_home_url
    assert_response :success
  end
end
