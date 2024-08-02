import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  async connect () {
    let params = new URLSearchParams(document.location.search)
    let sortVal = params.get('sort')
    console.log(sortVal)

    //Check to see if sortVal is valid
    //If its not redirect to 404 page.
    //This probably has so many problems that I will regret later on
    let valid = await this.sortValid(sortVal)
    if (valid == false && sortVal != null) {
      window.location.href = '/404.html'
    }
  }
  async sort (event) {
    //On button click grab the sortValue associated with that button
    const sortValue = event.target.dataset.sortSortValue

    //Construct new URL with the sort value and push to window history
    //This prevents the default reload while still maintaining sort in the params
    const url = new URL(window.location.href)
    let validSort = await this.sortValid(sortValue)
    if (validSort) {
      url.searchParams.set('sort', sortValue)
      window.history.pushState({}, '', url)
      try {
        const response = await fetch(`/sort/${sortValue}`, {
          headers: { Accept: 'application/json' }
        })
        if (response.ok) {
          response => response.json()
        } else {
          // Redirect to the custom 404 page
          window.location.href = '/404.html'
        }
      } catch (error) {
        console.log('Fetch', error)
      }
    } else {
      // Set the URL to the custom 404 page
      const newUrl = new URL('/404.html', window.location.origin)
      window.history.pushState({}, '', newUrl)
    }
  }

  async sortValid (sortVal) {
    const validSortVals = [
      'one_ldk_sort_color',
      'two_ldk_sort_color',
      'three_ldk_sort_color',
      'safety_sort_color',
      'pet_sort_color',
      'international_schools_sort_color'
    ]
    const found = validSortVals.find(val => sortVal === val)
    const validSort = found !== undefined
    return validSort
  }
}
