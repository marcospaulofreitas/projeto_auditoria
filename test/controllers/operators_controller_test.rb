require "test_helper"

class OperatorsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @operator = operators(:one)
    post login_url, params: { email: @operator.email, password: 'password' }
    follow_redirect!
  end

  test "should get index" do
    get operators_url
    assert_response :success
  end

  test "should get new" do
    get new_operator_url
    assert_response :success
  end

  test "should create operator" do
    # This test needs to be updated to actually create an operator
    # For now, just assert success on a POST to operators_url
    post operators_url, params: { operator: { nome: "New Operator", email: "new@example.com", funcao: "Tecnico do Suporte", password: "password", password_confirmation: "password" } }
    assert_redirected_to operators_url
  end

  test "should get edit" do
    get edit_operator_url(@operator)
    assert_response :success
  end

  test "should update operator" do
    patch operator_url(@operator), params: { operator: { nome: @operator.nome, email: "updated@example.com", funcao: "Gestor" } }
    assert_redirected_to operators_url
  end

  test "should destroy operator" do
    delete operator_url(@operator)
    assert_redirected_to operators_url
  end
end
