// Live search, category chips, sorting and "load more" — all progressive
// enhancement over plain links/forms that work without JavaScript.
import { $, $$, debounce, parseHTML } from "lib/utils"

export function initSearch() {
  const form = $("[data-search-form]")
  const results = $("[data-results]")
  if (!form || !results) return

  const input = $("[data-search-input]", form)
  const categoryField = $("[data-search-category]", form)
  const sortSelect = $("[data-search-sort]")
  const chips = $("[data-category-chips]")
  const heroTitle = $(".hero__title")
  const heroSubtitle = $(".hero__subtitle")
  const defaults = { title: heroTitle?.textContent.trim(), subtitle: heroSubtitle?.textContent.trim() }
  if (!categoryField.value) $$("[data-category]", chips).find((c) => !c.dataset.category)?.setAttribute("data-default", "")

  let inflight

  const currentUrl = ({ page } = {}) => {
    const params = new URLSearchParams()
    const q = input.value.trim()
    if (q) params.set("q", q)
    if (sortSelect && sortSelect.value !== "newest") params.set("sort", sortSelect.value)
    if (page) params.set("page", page)
    const category = categoryField.value
    const path = category ? `/categories/${encodeURIComponent(category)}` : "/"
    const qs = params.toString()
    return qs ? `${path}?${qs}` : path
  }

  async function fetchFragment(url) {
    inflight?.abort()
    inflight = new AbortController()
    const response = await fetch(url, {
      headers: { "X-Requested-With": "XMLHttpRequest", Accept: "text/html" },
      signal: inflight.signal
    })
    if (!response.ok) throw new Error(`Request failed: ${response.status}`)
    return response.text()
  }

  async function refresh({ history = "replace" } = {}) {
    const url = currentUrl()
    form.classList.add("is-loading")
    results.classList.add("is-loading")
    try {
      results.innerHTML = await fetchFragment(url)
      if (history === "push") window.history.pushState({}, "", url)
      else if (history === "replace") window.history.replaceState({}, "", url)
    } catch (error) {
      if (error.name !== "AbortError") window.location.href = url // graceful fallback
    } finally {
      form.classList.remove("is-loading")
      results.classList.remove("is-loading")
    }
  }

  function setActiveCategory(slug) {
    categoryField.value = slug
    let active
    $$("[data-category]", chips).forEach((chip) => {
      const isActive = chip.dataset.category === slug
      chip.classList.toggle("is-active", isActive)
      if (isActive) active = chip
    })
    active?.scrollIntoView({ block: "nearest", inline: "nearest", behavior: "smooth" })

    // Keep hero heading in sync with the selected category.
    if (heroTitle) heroTitle.textContent = active?.dataset.title || defaults.title
    if (heroSubtitle) heroSubtitle.textContent = active?.dataset.description || defaults.subtitle
    document.title = active?.dataset.title ? `${active.dataset.title} · Promptify` : "Promptify — AI image prompt library"
  }

  // Typing → debounced live search.
  input.addEventListener("input", debounce(() => refresh(), 250))

  // Enter → search immediately, no full page reload.
  form.addEventListener("submit", (event) => {
    event.preventDefault()
    refresh()
  })

  // Category chips.
  chips?.addEventListener("click", (event) => {
    const chip = event.target.closest("[data-category]")
    if (!chip || event.metaKey || event.ctrlKey) return
    event.preventDefault()
    setActiveCategory(chip.dataset.category)
    refresh({ history: "push" })
  })

  // Sort select.
  sortSelect?.addEventListener("change", () => refresh({ history: "push" }))

  // "Load more" and "Clear filters" live inside the swapped fragment → delegate.
  results.addEventListener("click", async (event) => {
    const more = event.target.closest("[data-load-more]")
    if (more) {
      event.preventDefault()
      more.textContent = "Loading…"
      more.setAttribute("aria-busy", "true")
      try {
        const fragment = parseHTML(await fetchFragment(more.href))
        $("[data-grid]", results).append(...$$("[data-grid] > *", fragment))
        const nextWrap = $("[data-load-more-wrap]", fragment)
        const wrap = $("[data-load-more-wrap]", results)
        nextWrap ? wrap.replaceWith(nextWrap) : wrap.remove()
      } catch (error) {
        if (error.name !== "AbortError") window.location.href = more.href
      }
      return
    }

    if (event.target.closest("[data-clear-filters]")) {
      event.preventDefault()
      input.value = ""
      if (sortSelect) sortSelect.value = "newest"
      setActiveCategory("")
      refresh({ history: "push" })
    }
  })

  // Back/forward buttons → restore state from the URL.
  window.addEventListener("popstate", () => {
    const params = new URLSearchParams(window.location.search)
    const match = window.location.pathname.match(/^\/categories\/([^/]+)/)
    input.value = params.get("q") || ""
    if (sortSelect) sortSelect.value = params.get("sort") || "newest"
    setActiveCategory(match ? decodeURIComponent(match[1]) : "")
    refresh({ history: "none" })
  })

  // "/" focuses search (like GitHub, YouTube…), Escape clears it.
  document.addEventListener("keydown", (event) => {
    const typing = /^(INPUT|TEXTAREA|SELECT)$/.test(document.activeElement?.tagName)
    if (event.key === "/" && !typing && !event.metaKey && !event.ctrlKey) {
      event.preventDefault()
      input.focus()
      input.select()
    } else if (event.key === "Escape" && document.activeElement === input && input.value) {
      input.value = ""
      refresh()
    }
  })
}
