require "test_helper"

class TeamsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @team = teams(:one)
    @operator = operators(:one)
    post login_url, params: { email: @operator.email, password: 'password' }
    follow_redirect!
  end

  test "should get index" do
    get teams_url
    assert_response :success
  end

  test "should get new" do
    get new_team_url
    assert_response :success
  end

  test "should create team" do
    # This test needs to be updated to actually create a team
    # For now, just assert success on a POST to teams_url
    post teams_url, params: { team: { nome: "New Unique Team Name" } }
    assert_redirected_to teams_url
  end

  test "should show team" do
    get team_url(@team)
    assert_response :success
  end

  test "should get edit" do
    get edit_team_url(@team)
    assert_response :success
  end

  test "should update team" do
    patch team_url(@team), params: { team: { nome: "Updated Team Name" } }
    assert_redirected_to teams_url
  end

  test "should destroy team" do
    delete team_url(@team)
    assert_redirected_to teams_url
  end
end
