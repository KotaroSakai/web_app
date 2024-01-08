require "test_helper"

class TobaccosControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get tobaccos_new_url
    assert_response :success
  end

  test "should get create" do
    get tobaccos_create_url
    assert_response :success
  end
end
