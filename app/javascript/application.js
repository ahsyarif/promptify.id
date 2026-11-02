// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import { initSearch } from "lib/search"
import { initBookmarks } from "lib/bookmarks"
import { initClipboard } from "lib/clipboard"
import { initNav, initFlash, initLightbox, initBackLink } from "lib/ui"
import { initPayment } from "lib/payment"

// Modules are deferred, so the DOM is already parsed here.
initNav()
initFlash()
initSearch()
initBookmarks()
initClipboard()
initLightbox()
initBackLink()
initPayment()
