require "test_helper"

class TechniciansControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get technicians_index_url
    assert_response :success
  end

  test "should get new" do
    get technicians_new_url
    assert_response :success
  end

  test "should get create" do
    get technicians_create_url
    assert_response :success
  end

  test "should get edit" do
    get technicians_edit_url
    assert_response :success
  end

  test "should get update" do
    get technicians_update_url
    assert_response :success
  end

  test "should get destroy" do
    get technicians_destroy_url
    assert_response :success
  end
end
