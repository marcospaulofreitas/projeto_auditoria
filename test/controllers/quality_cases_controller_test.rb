require "test_helper"

class QualityCasesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get quality_cases_index_url
    assert_response :success
  end

  test "should get show" do
    get quality_cases_show_url
    assert_response :success
  end

  test "should get new" do
    get quality_cases_new_url
    assert_response :success
  end

  test "should get create" do
    get quality_cases_create_url
    assert_response :success
  end

  test "should get edit" do
    get quality_cases_edit_url
    assert_response :success
  end

  test "should get update" do
    get quality_cases_update_url
    assert_response :success
  end

  test "should get destroy" do
    get quality_cases_destroy_url
    assert_response :success
  end
end
