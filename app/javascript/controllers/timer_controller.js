import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { startTime: Number, limit: Number }

  connect() {
    console.log('Timer connected', this.startTimeValue)
    this.updateTimer()
    this.timer = setInterval(() => {
      this.updateTimer()
    }, 1000)
  }

  disconnect() {
    if (this.timer) {
      clearInterval(this.timer)
    }
  }

  updateTimer() {
    if (this.hasStartTimeValue) {
      const now = Math.floor(Date.now() / 1000)
      const elapsed = now - this.startTimeValue
      
      const minutes = Math.floor(elapsed / 60)
      const seconds = elapsed % 60
      
      const timeText = `${minutes.toString().padStart(2, '0')}:${seconds.toString().padStart(2, '0')}`
      this.element.textContent = `⏱ ${timeText}`
      
      console.log('Timer update:', timeText, 'elapsed:', elapsed)
    }
  }
}