// Import and register all your controllers from the importmap via controllers/**/*_controller
import { application } from "controllers/application"
import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading"

import MultiSelectController from "controllers/multi_select_controller"
application.register("multi-select", MultiSelectController)

eagerLoadControllersFrom("controllers", application)
