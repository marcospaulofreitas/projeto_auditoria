# Create Team
qualidade_team = Team.find_or_create_by!(nome: 'Qualidade')

# Create Manager Operator
Operator.find_or_create_by!(email: 'marcospaulo@webposto.com.br') do |operator|
  operator.nome = 'Marcos Paulo de Freitas'
  operator.funcao = 'Gestor'
  operator.password = 'password' # You should use a more secure password in production
  operator.password_confirmation = 'password'
  operator.team = qualidade_team
end

# Create a generic manager operator
Operator.find_or_create_by!(email: 'generic.manager@example.com') do |operator|
  operator.nome = 'Generic Manager'
  operator.funcao = 'Gestor'
  operator.password = 'password'
  operator.password_confirmation = 'password'
  operator.team = qualidade_team
end

# Create a default auditor operator
Operator.find_or_create_by!(email: 'auditor@example.com') do |operator|
  operator.nome = 'Default Auditor'
  operator.funcao = 'Auditor'
  operator.password = 'password'
  operator.password_confirmation = 'password'
  operator.team = nil # Auditors might not need a team
end
