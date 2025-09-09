import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="clickable-row"
export default class extends Controller {
  static values = { url: String }

  connect() {
    this.element.style.cursor = "pointer"
    this.element.addEventListener("click", this.visit.bind(this))
  }

  visit() {
    Turbo.visit(this.urlValue)
  }
}
