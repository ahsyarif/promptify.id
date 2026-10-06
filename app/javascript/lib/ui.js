// Small UI behaviours: mobile nav, flash auto-dismiss, image lightbox, back link.
import { $, $$ } from "lib/utils"

export function initNav() {
  const toggle = $("[data-nav-toggle]")
  const nav = $("[data-nav]")
  if (!toggle || !nav) return

  const setOpen = (open) => {
    nav.classList.toggle("is-open", open)
    toggle.setAttribute("aria-expanded", String(open))
  }

  toggle.addEventListener("click", () => setOpen(!nav.classList.contains("is-open")))
  document.addEventListener("click", (event) => {
    if (!nav.contains(event.target) && !toggle.contains(event.target)) setOpen(false)
  })
  document.addEventListener("keydown", (event) => {
    if (event.key === "Escape") setOpen(false)
  })
}

export function initFlash() {
  $$("[data-flash]").forEach((flash) => {
    setTimeout(() => {
      flash.classList.add("is-hiding")
      setTimeout(() => flash.remove(), 300)
    }, 4000)
  })
}

export function initLightbox() {
  const dialog = $("[data-lightbox]")
  const opener = $("[data-lightbox-open]")
  if (!dialog || !opener) return
  const img = $("[data-lightbox-img]", dialog)

  opener.addEventListener("click", () => {
    const source = $("img", opener)
    img.src = source.dataset.lightboxSrc || source.src
    img.alt = source.alt
    dialog.showModal()
  })
  // Click anywhere (backdrop, image or ✕) closes it; Esc is handled natively.
  dialog.addEventListener("click", () => dialog.close())
}

// If we came from the library, go "back" so search/filter/scroll state is kept.
export function initBackLink() {
  const link = $("[data-back-link]")
  if (!link) return
  link.addEventListener("click", (event) => {
    try {
      const ref = new URL(document.referrer)
      const fromLibrary = ref.origin === location.origin &&
        (ref.pathname === "/" || ref.pathname.startsWith("/categories/") || ref.pathname === "/prompts")
      if (fromLibrary && history.length > 1) {
        event.preventDefault()
        history.back()
      }
    } catch { /* no referrer → follow the link */ }
  })
}
