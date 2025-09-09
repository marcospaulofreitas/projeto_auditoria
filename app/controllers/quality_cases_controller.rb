class QualityCasesController < ApplicationController
  before_action :set_quality_case, only: [:show, :edit, :update, :destroy, :gestao, :aprovar, :recusar, :pos_recusa, :reanalisar, :manter_avaliacao, :retorno_cliente, :registrar_retorno, :realizar_contato, :registrar_contato, :realizar_analise, :analise_qualidade]

  def index
    @all_cases = QualityCase.all
    @quality_cases = @all_cases.dup
    @quality_cases = @quality_cases.by_tecnico(params[:tecnico]) if params[:tecnico].present?
    @quality_cases = @quality_cases.by_status(params[:status]) if params[:status].present?
    @quality_cases = @quality_cases.order(created_at: :desc)
    
    @tecnicos = QualityCase.distinct.pluck(:tecnico).compact.sort
    @kpis = calculate_kpis(@all_cases)
    @chart_data = generate_chart_data(@all_cases)
  end

  def show
  end

  def new
    @quality_case = QualityCase.new
  end

  def create
    @quality_case = QualityCase.new(quality_case_params)
    @quality_case.auditor = current_operator
    
    if params[:commit] == "Enviar para Contato"
      @quality_case.status = "Aguardando contato com o cliente"
    end
    
    if @quality_case.save
      if @quality_case.status == "Aguardando contato com o cliente"
        @quality_case.start_timer_for_status(@quality_case.status)
      end
      redirect_to quality_cases_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    old_status = @quality_case.status
    
    if @quality_case.update(quality_case_params)
      # Iniciar timer se mudou de status
      if old_status != @quality_case.status
        @quality_case.start_timer_for_status(@quality_case.status)
      end
      
      @quality_case.auto_transition_status!
      redirect_to @quality_case
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @quality_case.destroy
    redirect_to quality_cases_path
  end
  
  def gestao
    @quality_case = QualityCase.find(params[:id])
    # Verificar se é gestor da equipe
    unless current_operator.funcao == 'Gestor' && @quality_case.team_id == current_operator.team_id
      redirect_to quality_cases_path
      return
    end
    render 'form_gestao'
  end
  
  def aprovar
    @quality_case = QualityCase.find(params[:id])
    
    if @quality_case.update(gestao_params.merge(status: "Concluído"))
      redirect_to quality_cases_path
    else
      render 'form_gestao', status: :unprocessable_entity
    end
  end
  
  def recusar
    @quality_case = QualityCase.find(params[:id])
    
    if @quality_case.update(gestao_params.merge(status: "Recusada pelo Gestor"))
      redirect_to quality_cases_path
    else
      render 'form_gestao', status: :unprocessable_entity
    end
  end
  
  def pos_recusa
    @quality_case = QualityCase.find(params[:id])
    render 'form_pos_recusa'
  end
  
  def reanalisar
    @quality_case = QualityCase.find(params[:id])
    
    if @quality_case.update(pos_recusa_params.merge(status: "Reanalisado"))
      # Volta para aguardando aprovação
      @quality_case.update_column(:status, "Aguardando aprovação do gestor")
      redirect_to quality_cases_path
    else
      render 'form_pos_recusa', status: :unprocessable_entity
    end
  end
  
  def manter_avaliacao
    @quality_case = QualityCase.find(params[:id])
    
    if @quality_case.update(pos_recusa_params.merge(status: "Avaliação Mantida"))
      redirect_to quality_cases_path
    else
      render 'form_pos_recusa', status: :unprocessable_entity
    end
  end
  
  def retorno_cliente
    @quality_case = QualityCase.find(params[:id])
    render 'form_retorno_cliente'
  end
  
  def registrar_retorno
    @quality_case = QualityCase.find(params[:id])
    @contact = @quality_case.contacts.build(contact_params)
    @contact.data_contato = Date.current
    @contact.hora_contato = Time.current
    
    if @contact.save
      case params[:action]
      when "retorno_sucesso"
        # Mantém no mesmo status
      when "retorno_insucesso"
        @contact.update(
          contato_com: "Não atendeu",
          registro_contato: "Cliente não atendeu - retorno sobre ações"
        )
      when "enviar_gestao"
        @quality_case.update_column(:status, "Aguardando aprovação do gestor")
      end
      
      redirect_to quality_cases_path
    else
      render 'form_retorno_cliente', status: :unprocessable_entity
    end
  end
  
  def realizar_contato
    @quality_case = QualityCase.find(params[:id])
  end
  
  def registrar_contato
    @quality_case = QualityCase.find(params[:id])
    @contact = @quality_case.contacts.build(contact_params)
    @contact.data_contato = Date.current
    @contact.hora_contato = Time.current
    
    if @contact.save
      case params[:commit]
      when "Salvar Sucesso"
        @quality_case.increment!(:contatos_sucesso)
      when "Salvar Insucesso"
        @quality_case.increment!(:contatos_insucesso)
        # Preencher campos padrão para insucesso se vazios
        if @contact.contato_com.blank?
          @contact.contato_com = "Não atendeu"
        end
        if @contact.registro_contato.blank?
          @contact.registro_contato = "Cliente não atendeu a ligação"
        end
      when "Enviar para Análise"
        # Se foi selecionado insucesso mas já tinha 2, incrementa insucesso
        if params[:tipo_contato] == "insucesso"
          @quality_case.increment!(:contatos_insucesso)
        else
          @quality_case.increment!(:contatos_sucesso)
        end
        
        @quality_case.update!(
          status: "Em análise pela Qualidade"
        )
        @quality_case.start_timer_for_status("Em análise pela Qualidade")
      end
      
      @quality_case.auto_transition_status!
      redirect_to quality_cases_path
    else
      render 'realizar_contato', status: :unprocessable_entity
    end
  end
  
  def realizar_analise
    @quality_case = QualityCase.find(params[:id])
  end
  
  def analise_qualidade
    @quality_case = QualityCase.find(params[:id])
    
    if @quality_case.update(analise_params)
      case params[:commit]
      when "Salvar"
        redirect_to quality_cases_path
      when "Finalizar"
        @quality_case.update!(
          status: "Aguardando retorno ao cliente"
        )
        redirect_to quality_cases_path
      end
    else
      render 'form_analise_qualidade', status: :unprocessable_entity
    end
  end

  private

  def set_quality_case
    @quality_case = QualityCase.find(params[:id])
  end

  def quality_case_params
    params.require(:quality_case).permit(:numero_chamado, :tecnico, :cliente, :empresa, :data_chamado, 
                                       :data_pesquisa_satisfacao, :status, :insatisfacao_cliente, 
                                       :analise_atendimento, :analise_conhecimento, :analise_procedimental,
                                       :acoes_corretivas_propostas, :acoes_adotadas, :motivo_recusa, 
                                       :informacoes_reanalise, :motivo_manutencao, :team_id,
                                       contacts_attributes: [:id, :data_contato, :hora_contato, :contato_com, :registro_contato, :_destroy])
  end

  def calculate_kpis(cases)
    {
      total: cases.count,
      novo: cases.where(status: "Novo").count,
      aguardando_contato: cases.where(status: "Aguardando contato com o cliente").count,
      em_analise: cases.where(status: "Em análise pela Qualidade").count,
      aguardando_retorno: cases.where(status: "Aguardando retorno ao cliente").count,
      aguardando_aprovacao: cases.where(status: "Aguardando aprovação do gestor").count,
      concluidos: cases.where(status: ["Concluído", "Avaliação Mantida"]).count
    }
  end

  def generate_chart_data(cases)
    {
      tecnicos: cases.group(:tecnico).count,
      status: cases.group(:status).count
    }
  end
  
  def contact_params
    params.require(:contact).permit(:contato_com, :registro_contato)
  end
  
  def analise_params
    params.require(:quality_case).permit(:analise_atendimento, :analise_conhecimento, :analise_procedimental, :acoes_corretivas_propostas)
  end
  
  def gestao_params
    params.require(:quality_case).permit(:acoes_adotadas, :motivo_recusa)
  end
  
  def pos_recusa_params
    params.require(:quality_case).permit(:informacoes_reanalise, :motivo_manutencao)
  end
end