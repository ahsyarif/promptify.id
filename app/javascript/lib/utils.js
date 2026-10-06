// Small shared helpers used by the feature modules.

export const $ = (selector, root = document) => root.querySelector(selector)
export const $$ = (selector, root = document) => [...root.querySelectorAll(selector)]

export function csrfToken() {
  return $('meta[name="csrf-token"]')?.content
}

export function debounce(fn, wait = 250) {
  let timer
  return (...args) => {
    clearTimeout(timer)
    timer = setTimeout(() => fn(...args), wait)
  }
}

// Parse an HTML string into a detached fragment we can query.
export function parseHTML(html) {
  const template = document.createElement("template")
  template.innerHTML = html.trim()
  return template.content
}

let toastTimer
export function toast(message) {
  const el = $("[data-toast]")
  if (!el) return
  el.textContent = message
  el.hidden = false
  // Next frame so the transition runs after un-hiding.
  requestAnimationFrame(() => el.classList.add("is-visible"))
  clearTimeout(toastTimer)
  toastTimer = setTimeout(() => {
    el.classList.remove("is-visible")
    setTimeout(() => (el.hidden = true), 200)
  }, 2000)
}
