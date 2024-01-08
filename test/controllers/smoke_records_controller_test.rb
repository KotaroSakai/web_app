require "test_helper"

class SmokeRecordsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get smoke_records_new_url
    assert_response :success
  end

  test "should get create" do
    get smoke_records_create_url
    assert_response :success
  end

  test "should get edit" do
    get smoke_records_edit_url
    assert_response :success
  end
end
