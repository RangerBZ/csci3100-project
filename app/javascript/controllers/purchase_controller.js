import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  showSuccess(event) {
    alert("🎉 Purchase successfully!")
  }
}