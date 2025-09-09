import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { startTime: Number, limit: Number, status: String }

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
      
      // Remove previous color classes to avoid conflicts
      this.element.classList.remove('text-yellow-900', 'text-red-500');

      // Apply default color
      this.element.classList.add('text-yellow-900');

      // Check for red color condition
      if (this.hasStatusValue && this.statusValue === 'retorno_cliente' && elapsed > this.limitValue) {
        this.element.classList.remove('text-yellow-900'); // Remove default color
        this.element.classList.add('text-red-500'); // Add red color
      }

      const hours = Math.floor(elapsed / 3600);
      const remainingMinutes = Math.floor((elapsed % 3600) / 60);
      const seconds = elapsed % 60;

      let timeText;
      if (hours > 0) {
        timeText = `${hours.toString().padStart(2, '0')}:${remainingMinutes.toString().padStart(2, '0')}:${seconds.toString().padStart(2, '0')}`;
      } else {
        timeText = `${remainingMinutes.toString().padStart(2, '0')}:${seconds.toString().padStart(2, '0')}`;
      }
      this.element.textContent = timeText;
      
      console.log('Timer update:', timeText, 'elapsed:', elapsed)
    }
  }
}