module QualityCasesHelper
  def status_color(status)
    case status
    when "Em Análise"
      "bg-amber-100 text-amber-800"
    when "Em Contato"
      "bg-sky-100 text-sky-800"
    when "Finalizado"
      "bg-emerald-100 text-emerald-800"
    else
      "bg-slate-100 text-slate-800"
    end
  end

  def status_border_color(status)
    case status
    when "Em Análise"
      "border-amber-500"
    when "Em Contato"
      "border-sky-500"
    when "Finalizado"
      "border-emerald-500"
    else
      "border-slate-500"
    end
  end
end
