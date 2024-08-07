import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  static targets = ['globus', 'sortKey']

  //Initialize map functions
  //
  //
  async connect () {
    try {
      //Readonly MapBox API key.
      //Set mobile or desktop view
      const mobileSettings = {
        center: [139.749888, 35.649098],
        zoom: 9.4,
        pitch: 20
      }
      const desktopSettings = {
        center: [139.749888, 35.639098],
        zoom: 10.4,
        pitch: 20
      }
      const viewSettings =
        window.innerWidth < 769 ? mobileSettings : desktopSettings
      const mapboxKey =
        'pk.eyJ1IjoidGltY2hhcDk2IiwiYSI6ImNseXdmb3YzNjFpY3oyanM2bG52M2JpOXMifQ.5q9X3hm62kg4VRhZBR18hQ'

      //Check for sort params
      const initialSortVal = await this.getSearchParams()

      await this.mapInitialize(viewSettings, mapboxKey)

      //This is a mapbox function
      //On map load perform the following operations
      let sortValid = await this.sortValid(initialSortVal)
      this.map.on('load', () => {
        //Call map load to add 1. geojson source, 2. map fog 3. initial layers
        this.mapLoad()
        // If url contains sort val add to map
        if(sortValid) {
          this.addSortLayers(initialSortVal, '-sort')
        }
      })
    } catch (error) {
      console.error('An error occurred:', error)
    }
  }

  async getSearchParams () {
    const url = new URL(window.location.href)
    const initialSortVal = url.searchParams.get('sort')
    return initialSortVal
  }

  async mapInitialize (viewSetting, mapboxKey) {
    mapboxgl.accessToken = mapboxKey // Set the Mapbox access token
    this.map = new mapboxgl.Map({
      container: 'map', // Set the map container
      style: 'mapbox://styles/timchap96/cleky3zxc000g01mxat00cwa8', // Set the map style
      zoom: viewSetting.zoom, // Set the initial zoom level
      center: viewSetting.center, // Set the initial center coordinates
      pitch: viewSetting.pitch,
      projection: 'globe', // Set the map projection to globe
      attributionControl: 'false'
    })
  }

  async mapLoad () {
    // Add source for ward shapes
    this.map.addSource('wards', {
      type: 'geojson',
      data: 'tokyo.geojson'
    })
    this.map.setFog({
      color: 'rgb(186, 210, 235)', // Lower atmosphere
      'high-color': 'rgb(36, 92, 223)', // Upper atmosphere
      'horizon-blend': 0.02, // Atmosphere thickness (default 0.2 at low zooms)
      'space-color': 'rgb(11, 11, 25)', // Background color
      'star-intensity': 0.6 // Background star brightness (default 0.35 at low zooms )
    })
    ;(this.hoveredStateId = null), this.addLayers('white', 'black', '')
  }

  async addLayers (baseColor, hoverColor, type) {
    this.removeSortLayers()
    let firstSymbolId = this.findLabels()

    this.map.addLayer(
      {
        id: `wards${type}-fill`,
        type: 'fill',
        source: 'wards',
        layout: {
          visibility: 'visible' // Set the layer visibility to "visible"
        },
        paint: {
          'fill-color': [
            'case',
            ['boolean', ['feature-state', 'hover'], false],
            hoverColor,
            baseColor
          ],
          'fill-opacity': 1
        }
      },
      firstSymbolId //This variable makes sure that the ward titles appear above the fill layers
    )
    this.map.addLayer(
      {
        id: `wards${type}-outline`,
        type: 'line',
        source: 'wards',
        layout: {},
        paint: {
          'line-color': 'black',
          'line-width': 3,
          'line-opacity': 0.7
        }
      },
      firstSymbolId
    )
  }

  findLabels () {
    //This function finds the ward title layer
    const layers = this.map.getStyle().layers
    // Find the index of the first symbol layer in the map style.
    let firstSymbolId
    for (const layer of layers) {
      if (layer.type === 'symbol') {
        firstSymbolId = layer.id
        break
      }
    }
    return firstSymbolId
  }

  //
  //

  //Sort functions
  //
  //

  async sortValid(sortVal) {
    const validSortVals = ["one_ldk_sort_color", "two_ldk_sort_color", "three_ldk_sort_color", "safety_sort_color", "pet_sort_color", "international_schools_sort_color"]
    let validSort = false
    validSortVals.forEach((val) => {
      if(sortVal === val) {
        validSort = true
        return validSort
      }
    })
    return validSort
  }

  async sort (event) {
    const sortVal = event.target.dataset.sortSortValue
    if(this.sortValid(sortVal)) {
      this.addSortLayers(sortVal, '-sort')
    }
  }

  async addSortLayers (sortVal, type) {
    //remove any previously added sort layers
    this.removeSortLayers()
    const firstSymbolId = this.findLabels()
    //Add sort fill layers to map
    this.addSortLayersToMap(sortVal, type, firstSymbolId)

  }

  addSortLayersToMap (sortVal, type, firstSymbolId) {
    this.map.addLayer(
      {
        id: `wards${type}-fill`,
        type: 'fill',
        source: 'wards',
        layout: {
          visibility: 'visible'
        },
        paint: {
          'fill-color': [
            'case',
            ['boolean', ['feature-state', 'hover'], false],
            ['get', 'hover-color'],
            ['get', `${sortVal}`]
          ],
          'fill-opacity': 1
        }
      },
      firstSymbolId
    )
    this.map.addLayer(
      {
        id: `wards${type}-outline`,
        type: 'line',
        source: 'wards',
        layout: {},
        paint: {
          'line-color': 'black',
          'line-width': 3,
          'line-opacity': 0.7
        }
      },
      firstSymbolId
    )
  }

  removeSortLayers () {
    if (this.map.getLayer('wards-sort-fill')) {
      // Check if a layer called "ward-sort-fill" already exists in the map
      this.map.removeLayer('wards-sort-fill') // If it does, remove it
      this.map.removeLayer('wards-sort-outline')
    }
  }
  //
  //
}
