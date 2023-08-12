import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
  }

  toggle(e) {
    let landingCardInfo = e.currentTarget;
    let infoDropdown = landingCardInfo.querySelector(".landing-info-dropdown");
    console.log(infoDropdown.classList);

    // If user clicks popup menu, toggle dropdown
    if ((infoDropdown.classList.length === 1) || (infoDropdown.classList.contains("slide-up"))) {
      infoDropdown.classList.add("slide-down");
      landingCardInfo.classList.add("center");
    }
    else if (infoDropdown.classList.contains("slide-down")) {
      infoDropdown.classList.toggle("slide-down");
      infoDropdown.classList.toggle("slide-up");
    }
  }
}
