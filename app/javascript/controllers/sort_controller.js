import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  connect () {

  }
  sort (event) {
    //On button click grab the sortValue associated with that button
    const sortValue = event.target.dataset.sortSortValue

    //Construct new URL with the sort value and push to window history
    //This prevents the default reload while still maintaining sort in the params
    const url = new URL(window.location)
    url.searchParams.set('sort', sortValue)
    window.history.pushState({}, '', url)

    fetch(`/sort/${sortValue}`, {
      headers: { Accept: 'application/json' }
    }).then(response => response.json())
    .catch(error => {
      console.error('Error fetching sort data', error)
    })
  }
}
