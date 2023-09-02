import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  //Current issue
    //If user is on mobile device and flips to horizontal
    //after clicking on the dropdown the class slide-down/slide-up is not removed.
  connect() {
  }

  sortToggle(e) {
    document.querySelector(".sort-options").classList.toggle("sort-down");
  }

  toggle(e) {
    let landingCardInfo = e.currentTarget;
    let infoDropdown = landingCardInfo.querySelector(".landing-info-dropdown");

    // If user clicks popup menu, toggle dropdown WHEN in mobile version.
    if (window.innerWidth < 796) {
      if (infoDropdown.classList.length === 1) {
        infoDropdown.classList.add("slide-down");
        landingCardInfo.classList.add("center");
      }
      else if (infoDropdown.classList.contains("slide-down")) {
        infoDropdown.classList.toggle("slide-down");
        infoDropdown.classList.toggle("slide-up");
      }
    }
  }
}
