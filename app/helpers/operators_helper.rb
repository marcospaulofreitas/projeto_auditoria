module OperatorsHelper
  def operator_funcao_color(funcao)
    case funcao
    when 'Gestor'
      'bg-red-100 text-red-800'
    when 'Auditor da Qualidade'
      'bg-yellow-100 text-yellow-800'
    when 'Tecnico do Suporte'
      'bg-green-100 text-green-800'
    else
      'bg-gray-100 text-gray-800'
    end
  end
end
