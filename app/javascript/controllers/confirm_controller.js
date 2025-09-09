import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="confirm"
export default class extends Controller {
  static values = {
    message: String,
  }

  static targets = [ "modal", "message" ]

  connect() {
    // Create a reference to the bound confirm method
    this.boundConfirm = this.confirm.bind(this)
    this.element.addEventListener("click", this.boundConfirm)
    this.element.dataset.action = "" // Clear the original action to prevent double binding
  }

  disconnect() {
    this.element.removeEventListener("click", this.boundConfirm)
  }

  confirm(event) {
    event.preventDefault()
    event.stopImmediatePropagation()

    this.originalLink = event.currentTarget
    const message = this.originalLink.dataset.confirmMessage || "Você tem certeza?"
    
    const modal = this.getModal()
    modal.querySelector("[data-confirm-target='message']").textContent = message
    modal.classList.remove("hidden")

    this.handleProceed = (e) => {
      e.preventDefault()
      this.proceed()
    }

    this.handleCancel = (e) => {
      e.preventDefault()
      this.cancel()
    }
    
    modal.querySelector("[data-action='confirm#proceed']").addEventListener("click", this.handleProceed)
    modal.querySelector("[data-action='confirm#cancel']").addEventListener("click", this.handleCancel)
  }

  proceed() {
    // Use Turbo to visit the link, preserving the turbo_method
    const turboMethod = this.originalLink.dataset.turboMethod || 'get'
    
    // Create a temporary, invisible link to carry the turbo-method data
    const link = document.createElement('a')
    link.href = this.originalLink.href
    link.dataset.turboMethod = turboMethod
    link.style.display = 'none'
    document.body.appendChild(link)
    link.click()
    document.body.removeChild(link)

    this.hideModal()
  }

  cancel() {
    this.hideModal()
  }

  getModal() {
    if (!this.modal) {
      this.modal = document.getElementById("confirm-modal")
    }
    return this.modal
  }

  hideModal() {
    const modal = this.getModal()
    if (modal) {
      modal.classList.add("hidden")
      // Clean up event listeners
      modal.querySelector("[data-action='confirm#proceed']").removeEventListener("click", this.handleProceed)
      modal.querySelector("[data-action='confirm#cancel']").removeEventListener("click", this.handleCancel)
    }
  }
}
