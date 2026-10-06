// Bookmark toggling via fetch. Each bookmark button is a real <form>, so it
// still works with JS disabled; here we intercept submit and call the JSON API.
import { $, $$, csrfToken, toast } from "lib/utils"

function applyState(promptId, bookmarked) {
  $$(`[data-bookmark-form][data-prompt-id="${promptId}"]`).forEach((form) => {
    const button = $("button", form)
    button.setAttribute("aria-pressed", String(bookmarked))
    button.setAttribute("aria-label", bookmarked ? "Remove from saved" : "Save prompt")
    const label = $("[data-bookmark-label]", button)
    if (label) label.textContent = bookmarked ? "Saved" : "Save"

    // Keep the no-JS fallback in sync (Rails uses a hidden _method field).
    let methodField = $('input[name="_method"]', form)
    if (bookmarked) {
      if (!methodField) {
        methodField = Object.assign(document.createElement("input"), { type: "hidden", name: "_method" })
        form.prepend(methodField)
      }
      methodField.value = "delete"
    } else {
      methodField?.remove()
    }
  })
}

function removeFromSavedPage(promptId) {
  const grid = $("[data-remove-on-unsave]")
  const card = grid && $(`[data-card][data-prompt-id="${promptId}"]`, grid)
  if (!card) return
  card.classList.add("is-removing")
  setTimeout(() => {
    card.remove()
    if (!grid.children.length) $("[data-saved-empty]").hidden = false
  }, 300)
}

export function initBookmarks() {
  document.addEventListener("submit", async (event) => {
    const form = event.target.closest("[data-bookmark-form]")
    if (!form) return
    event.preventDefault()

    const button = $("button", form)
    const promptId = form.dataset.promptId
    const wasSaved = button.getAttribute("aria-pressed") === "true"
    button.classList.add("is-busy")

    try {
      const response = await fetch(form.action, {
        method: wasSaved ? "DELETE" : "POST",
        headers: { Accept: "application/json", "X-CSRF-Token": csrfToken() },
        credentials: "same-origin"
      })

      if (response.status === 401) {
        const { login_url } = await response.json()
        window.location.href = login_url
        return
      }
      if (!response.ok) throw new Error(`Bookmark failed: ${response.status}`)

      const data = await response.json()
      applyState(promptId, data.bookmarked)

      $$(`[data-bookmarks-count="${promptId}"]`).forEach((el) => (el.textContent = data.bookmarks_count))
      $$("[data-saved-count]").forEach((el) => (el.textContent = data.saved_total))

      if (data.bookmarked) {
        button.classList.remove("pop")
        void button.offsetWidth // restart animation
        button.classList.add("pop")
        toast("Saved to your collection")
      } else {
        toast("Removed from saved")
        removeFromSavedPage(promptId)
      }
    } catch (error) {
      console.error(error)
      toast("Something went wrong — please try again")
    } finally {
      button.classList.remove("is-busy")
    }
  })
}
