# Pin npm packages by running ./bin/importmap

pin "application"
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"

# Explicitly pin multi_select_controller to debug 404
pin "multi_select_controller", to: "controllers/multi_select_controller.js"

# Re-add this line to map the 'controllers' namespace
pin_all_from "app/javascript/controllers", under: "controllers"

