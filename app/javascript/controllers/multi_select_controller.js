import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["modal", "modalSearchInput", "modalTeamsList", "chipsContainer", "hiddenInput"]

  connect() {
    const allTeamsData = this.data.get("allTeams")
    this.allTeams = JSON.parse(allTeamsData)

    const initialTeamsData = this.data.get("initialTeams")
    this.selectedTeamsInModal = initialTeamsData ? JSON.parse(initialTeamsData) : []

    this.renderInitialChips()
    this.updateHiddenInput()
  }

  openModal() {
    this.modal.classList.remove("hidden")
    this.renderModalTeamsList()
    this.modalSearchInputTarget.value = '' // Clear search on open
  }

  closeModal() {
    this.modal.classList.add("hidden")
    // Reset selected teams in modal to current saved teams if cancelled
    const currentSelectedIds = this.getSelectedTeamIds()
    this.selectedTeamsInModal = this.allTeams.filter(team => currentSelectedIds.includes(team.id.toString()))
  }

  filterModalTeams() {
    this.renderModalTeamsList()
  }

  renderModalTeamsList() {
    const query = this.modalSearchInputTarget.value.toLowerCase()
    this.modalTeamsListTarget.innerHTML = ''

    const filteredTeams = this.allTeams.filter(team => 
      team.nome.toLowerCase().includes(query)
    )

    filteredTeams.forEach(team => {
      const isChecked = this.selectedTeamsInModal.some(selected => selected.id.toString() === team.id.toString())
      const checkboxItem = document.createElement("div")
      checkboxItem.className = "flex items-center py-2"
      checkboxItem.innerHTML = `
        <input type="checkbox" id="modal-team-${team.id}" value="${team.id}" data-name="${team.nome}" ${isChecked ? 'checked' : ''} data-action="change->multi-select#toggleTeamSelection" class="h-4 w-4 text-indigo-600 focus:ring-indigo-500 border-gray-300 rounded">
        <label for="modal-team-${team.id}" class="ml-3 text-sm text-gray-900">${team.nome}</label>
      `
      this.modalTeamsListTarget.appendChild(checkboxItem)
    })
  }

  toggleTeamSelection(event) {
    const teamId = event.target.value
    const teamName = event.target.dataset.name
    const team = { id: teamId, nome: teamName }

    if (event.target.checked) {
      if (!this.selectedTeamsInModal.some(selected => selected.id.toString() === teamId)) {
        this.selectedTeamsInModal.push(team)
      }
    } else {
      this.selectedTeamsInModal = this.selectedTeamsInModal.filter(selected => selected.id.toString() !== teamId)
    }
  }

  applySelection() {
    // Clear existing chips
    this.chipsContainerTarget.innerHTML = ''
    
    // Render new chips based on selectedTeamsInModal
    this.selectedTeamsInModal.forEach(team => {
      this.addChip(team.id, team.nome)
    })
    this.updateHiddenInput()
    this.closeModal()
  }

  addChip(id, name) {
    if (!this.element.querySelector(`[data-id="${id}"]`)) { // Prevent duplicates
      const chip = document.createElement("div")
      chip.className = "inline-flex items-center px-3 py-1 rounded-full text-sm font-medium bg-indigo-100 text-indigo-800 mr-2 mb-2"
      chip.dataset.id = id
      chip.innerHTML = `
        <span>${name}</span>
        <button type="button" data-action="multi-select#removeChip" class="flex-shrink-0 ml-1.5 h-4 w-4 rounded-full inline-flex items-center justify-center text-indigo-400 hover:bg-indigo-200 hover:text-indigo-500 focus:outline-none focus:bg-indigo-500 focus:text-white">
          <span class="sr-only">Remove team</span>
          <svg class="h-2 w-2" stroke="currentColor" fill="none" viewBox="0 0 8 8">
            <path stroke-linecap="round" stroke-width="1.5" d="M1 1l6 6M6 1L1 6" />
          </svg>
        </button>
      `
      this.chipsContainerTarget.appendChild(chip)
    }
  }

  removeChip(event) {
    const chip = event.target.closest("[data-id]")
    const teamIdToRemove = chip.dataset.id
    chip.remove()
    
    // Remove from selectedTeamsInModal as well
    this.selectedTeamsInModal = this.selectedTeamsInModal.filter(selected => selected.id.toString() !== teamIdToRemove)
    
    this.updateHiddenInput()
    this.renderModalTeamsList() // Re-render modal list to uncheck the removed item
  }

  updateHiddenInput() {
    const selectedIds = this.getSelectedTeamIds()
    this.hiddenInputTarget.value = selectedIds.join(",")
  }

  getSelectedTeamIds() {
    return Array.from(this.chipsContainerTarget.children).map(chip => chip.dataset.id)
  }

  renderInitialChips() {
    this.chipsContainerTarget.innerHTML = '' // Clear existing chips
    this.selectedTeamsInModal.forEach(team => {
      this.addChip(team.id, team.nome)
    })
  }

  // Hide modal when clicking outside (if not clicking on modal content)
  hide(event) {
    if (this.modal && !this.modal.contains(event.target) && !this.element.contains(event.target)) {
      this.closeModal()
    }
  }
}
