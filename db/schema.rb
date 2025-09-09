# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2025_09_04_200017) do
  create_table "contacts", force: :cascade do |t|
    t.integer "quality_case_id", null: false
    t.date "data_contato"
    t.time "hora_contato"
    t.string "contato_com"
    t.text "registro_contato"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["quality_case_id"], name: "index_contacts_on_quality_case_id"
  end

  create_table "operators", force: :cascade do |t|
    t.string "nome"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "email"
    t.string "funcao"
    t.string "password_digest"
    t.integer "team_id"
    t.index ["team_id"], name: "index_operators_on_team_id"
  end

  create_table "quality_cases", force: :cascade do |t|
    t.string "numero_chamado"
    t.string "tecnico"
    t.string "cliente"
    t.date "data_chamado"
    t.date "data_avaliacao"
    t.string "status"
    t.text "insatisfacao_cliente"
    t.text "analise_qualidade"
    t.text "acoes_corretivas"
    t.text "retorno_cliente"
    t.text "retorno_gestor"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "team_id"
    t.integer "auditor_id"
    t.datetime "contato_started_at"
    t.datetime "analise_started_at"
    t.date "data_pesquisa_satisfacao"
    t.datetime "data_registro"
    t.text "analise_atendimento"
    t.text "analise_conhecimento"
    t.text "analise_procedimental"
    t.text "acoes_corretivas_propostas"
    t.text "acoes_adotadas"
    t.text "motivo_recusa"
    t.text "informacoes_reanalise"
    t.text "motivo_manutencao"
    t.integer "contatos_sucesso", default: 0
    t.integer "contatos_insucesso", default: 0
    t.string "empresa"
    t.index ["auditor_id"], name: "index_quality_cases_on_auditor_id"
    t.index ["team_id"], name: "index_quality_cases_on_team_id"
  end

  create_table "team_memberships", force: :cascade do |t|
    t.integer "operator_id", null: false
    t.integer "team_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["operator_id"], name: "index_team_memberships_on_operator_id"
    t.index ["team_id"], name: "index_team_memberships_on_team_id"
  end

  create_table "teams", force: :cascade do |t|
    t.string "nome"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "operator_ids"
  end

  add_foreign_key "contacts", "quality_cases"
  add_foreign_key "operators", "teams"
  add_foreign_key "quality_cases", "operators", column: "auditor_id"
  add_foreign_key "quality_cases", "teams"
  add_foreign_key "team_memberships", "operators"
  add_foreign_key "team_memberships", "teams"
end
