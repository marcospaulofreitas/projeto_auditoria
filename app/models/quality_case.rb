class QualityCase < ApplicationRecord
  belongs_to :team
  belongs_to :auditor, class_name: "Operator", optional: true
  has_many :contacts, dependent: :destroy
  accepts_nested_attributes_for :contacts, allow_destroy: true, reject_if: :all_blank

  validates :numero_chamado, presence: true, uniqueness: true
  validates :tecnico, :cliente, :data_chamado, :data_pesquisa_satisfacao, :team_id, presence: true

  scope :by_tecnico, ->(tecnico) { where(tecnico: tecnico) if tecnico.present? }
  scope :by_status, ->(status) { where(status: status) if status.present? }
  scope :by_team, ->(team_id) { where(team_id: team_id) if team_id.present? }

  # Novos status do workflow
  def self.statuses
    {
      "Novo" => "Novo",
      "Aguardando contato" => "Aguardando contato",
      "Em análise pela Qualidade" => "Em análise pela Qualidade",
      "Aguardando retorno ao cliente" => "Aguardando retorno ao cliente",
      "Aguardando aprovação do gestor" => "Aguardando aprovação do gestor",
      "Recusada pelo Gestor" => "Recusada pelo Gestor",
      "Reanalisado" => "Reanalisado",
      "Avaliação Mantida" => "Avaliação Mantida",
      "Concluído" => "Concluído"
    }
  end

  # Status selecionáveis apenas no primeiro registro
  def self.initial_statuses
    [ "Novo" ]
  end

  # Callbacks
  before_create :set_data_registro
  before_create :set_initial_status

  def auto_transition_status!
    case status
    when "Novo"
      # Não faz transição automática
    when "Aguardando contato"
      if can_advance_from_contact?
        update_column(:status, "Em análise pela Qualidade")
        start_timer_for_status("Em análise pela Qualidade")
      end
    when "Em análise pela Qualidade"
      # Transição manual via botão "Finalizar"
    when "Aguardando retorno ao cliente"
      # Lógica similar ao contato inicial
    end
  end

  def start_timer_for_status(new_status)
    case new_status
    when "Aguardando contato"
      update_column(:contato_started_at, Time.current)
    when "Em análise pela Qualidade"
      update_column(:analise_started_at, Time.current)
    end
  end

  def contato_time_remaining
    return nil unless contato_started_at
    return 0 if ![ "Aguardando contato" ].include?(status)

    elapsed = Time.current - contato_started_at
    remaining = (30 * 60) - elapsed # 30 minutos em segundos
    [ remaining, 0 ].max
  end

  def analise_time_remaining
    return nil unless analise_started_at
    return 0 unless status == "Em análise pela Qualidade"

    elapsed = Time.current - analise_started_at
    remaining = (2 * 60 * 60) - elapsed # 2 horas em segundos
    [ remaining, 0 ].max
  end

  def format_time_remaining(seconds)
    return "--" if seconds.nil?
    return "Encerrado" if seconds == 0

    hours = seconds / 3600
    minutes = (seconds % 3600) / 60
    secs = seconds % 60

    if hours > 0
      "%02d:%02d:%02d" % [ hours, minutes, secs ]
    else
      "%02d:%02d" % [ minutes, secs ]
    end
  end

  # Lógica de contatos
  def can_advance_from_contact?
    contatos_sucesso >= 1 || contatos_insucesso >= 3
  end

  def is_readonly?
    persisted? && status != "Novo"
  end

  # Botões disponíveis por status
  def available_actions
    case status
    when "Novo"
      [ "cancelar", "enviar_para_contato" ]
    when "Aguardando contato"
      if can_advance_from_contact?
        [ "cancelar", "enviar_para_analise" ]
      else
        [ "cancelar", "salvar_contato" ]
      end
    when "Em análise pela Qualidade"
      [ "cancelar", "salvar", "finalizar" ]
    when "Aguardando retorno ao cliente"
      [ "cancelar", "salvar_retorno" ]
    when "Aguardando aprovação do gestor"
      if current_user_is_manager?
        [ "aprovar", "recusar" ]
      else
        []
      end
    when "Recusada pelo Gestor"
      [ "reanalisar", "manter_avaliacao" ]
    else
      []
    end
  end

  private

  def set_data_registro
    self.data_registro = Time.current
  end

  def set_initial_status
    self.status = "Novo" if status.blank?
  end

  def current_user_is_manager?
    # Será implementado com current_user
    false
  end
end
