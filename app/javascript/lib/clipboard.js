// Copy-to-clipboard for any element with a data-copy="text" attribute.
import { toast } from "lib/utils"

async function writeText(text) {
  if (navigator.clipboard && window.isSecureContext) {
    return navigator.clipboard.writeText(text)
  }
  // Fallback for non-secure contexts (e.g. LAN IP during development).
  const textarea = Object.assign(document.createElement("textarea"), { value: text })
  textarea.style.cssText = "position:fixed;opacity:0"
  document.body.append(textarea)
  textarea.select()
  document.execCommand("copy")
  textarea.remove()
}

export function initClipboard() {
  document.addEventListener("click", async (event) => {
    const trigger = event.target.closest("[data-copy]")
    if (!trigger) return
    event.preventDefault()

    try {
      await writeText(trigger.dataset.copy)
      toast("Copied to clipboard")
      const label = trigger.querySelector("span")
      if (label && !trigger.dataset.originalLabel) {
        trigger.dataset.originalLabel = label.textContent
        label.textContent = "Copied"
        setTimeout(() => {
          label.textContent = trigger.dataset.originalLabel
          delete trigger.dataset.originalLabel
        }, 1500)
      }
    } catch {
      toast("Couldn't copy — select the text manually")
    }
  })
}
