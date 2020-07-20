// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.
import "../css/app.scss"

// webpack automatically bundles all modules in your
// entry points. Those entry points can be configured
// in "webpack.config.js".
//
// Import deps with the dep name or local files with a relative path, for example:
//
//     import {Socket} from "phoenix"
//     import socket from "./socket"
//
import "phoenix_html"
import {Socket} from "phoenix"
import NProgress from "nprogress"
import {LiveSocket} from "phoenix_live_view"
import { mountMap, updateMap } from "./map"
import { mountView, updateView } from "./view"

function extractLocation(element) {
  return {
    lat: element.getAttribute("data-lat"),
    lng: element.getAttribute("data-lng"),
    alt: element.getAttribute("data-alt"),
    bearing: element.getAttribute("data-bearing"),
    pitch: element.getAttribute("data-pitch")
  }
}

const mapState = {}
const viewState = {}

let Hooks = {}
Hooks.Map = {
  mounted() {
    const location = extractLocation(this.el)
    mountMap(mapState, location)
    mountView(viewState, location)
  },
  updated() {
    const location = extractLocation(this.el)
    updateMap(mapState, location)
    updateView(viewState, location)
  }
}

let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")
let liveSocket =
  new LiveSocket(
    "/live",
    Socket,
    { params: { _csrf_token: csrfToken }, hooks: Hooks }
  )

// Show progress bar on live navigation and form submits
window.addEventListener("phx:page-loading-start", info => NProgress.start())
window.addEventListener("phx:page-loading-stop", info => NProgress.done())

// connect if there are any LiveViews on the page
liveSocket.connect()

// expose liveSocket on window for web console debug logs and latency simulation:
liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)
window.liveSocket = liveSocket
