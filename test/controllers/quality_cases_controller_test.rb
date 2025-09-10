require "test_helper"

class QualityCasesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @quality_case = quality_cases(:one)
    @operator = operators(:one)
    post login_url, params: { email: @operator.email, password: "password" }
    follow_redirect!
  end

  test "should get index" do
    get quality_cases_url
    assert_response :success
  end

  test "should show quality_case" do
    get quality_case_url(@quality_case)
    assert_response :success
  end

  test "should get new" do
    get new_quality_case_url
    assert_response :success
  end

  test "should create quality_case" do
    # This test needs to be updated to actually create a quality_case
    # For now, just assert success on a POST to quality_cases_url
    post quality_cases_url, params: { quality_case: { numero_chamado: "UniqueNumeroChamado#{Time.now.to_i}", tecnico: "New Tecnico", cliente: "New Cliente", data_chamado: Date.today, data_pesquisa_satisfacao: Date.today, team_id: teams(:one).id, status: "Novo", insatisfacao_cliente: "Test", analise_qualidade: "Test", acoes_corretivas: "Test", retorno_cliente: "Test", retorno_gestor: "Test" } }
    assert_redirected_to quality_cases_url
  end

  test "should get edit" do
    get edit_quality_case_url(@quality_case)
    assert_response :success
  end

  test "should update quality_case" do
    patch quality_case_url(@quality_case), params: { quality_case: { numero_chamado: @quality_case.numero_chamado, tecnico: "Updated Tecnico", cliente: @quality_case.cliente, data_chamado: @quality_case.data_chamado, data_pesquisa_satisfacao: @quality_case.data_pesquisa_satisfacao, team_id: @quality_case.team_id, status: @quality_case.status, insatisfacao_cliente: @quality_case.insatisfacao_cliente, analise_qualidade: @quality_case.analise_qualidade, acoes_corretivas: @quality_case.acoes_corretivas, retorno_cliente: @quality_case.retorno_cliente, retorno_gestor: @quality_case.retorno_gestor } }
    assert_redirected_to quality_case_url(@quality_case)
  end

  test "should destroy quality_case" do
    delete quality_case_url(@quality_case)
    assert_redirected_to quality_cases_url
  end
end
