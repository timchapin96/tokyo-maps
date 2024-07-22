import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  static targets = ['globus', 'sortKey']

  //Readonly MapBox API key.

  //Initialize map functions
  //
  //
  async connect () {
    const mapboxKey =
      'pk.eyJ1IjoidGltY2hhcDk2IiwiYSI6ImNseXdmb3YzNjFpY3oyanM2bG52M2JpOXMifQ.5q9X3hm62kg4VRhZBR18hQ'

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

    this.mapInitialize(viewSettings, mapboxKey)
    this.mapLoad()

    // this.userStep()
    // this.hover()
    // this.#addUserToMap()
  }

  mapInitialize (viewSetting, mapboxKey) {
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

  mapLoad () {
    this.map.on('load', () => {
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
    })
  }

  addLayers (baseColor, hoverColor, type) {
    // this.removeSortLayers()
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
  sort (event) {
    const sortVal = event.target.dataset.sortSortValue
    console.log(sortVal)
    this.addSortLayers(sortVal, '-sort')
  }

  addSortLayers (sortVal, type) {
    //remove any previously added sort layers
    this.removeSortLayers()
    let firstSymbolId = this.findLabels()

    //Add sort fill layers to map
    this.map.addLayer(
      {
        id: `wards${type}-fill`, // Add a new layer with ID "ward-sort-fill"
        type: 'fill', // The layer type is "fill", which will fill with a color
        source: 'wards',
        layout: {
          visibility: 'visible' // Set the layer visibility to "visible"
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
    //Add outline layer
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
