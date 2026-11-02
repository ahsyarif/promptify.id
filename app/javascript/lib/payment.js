// Polls payment status while a QRIS code is shown; reloads once it leaves "pending"
// (paid → server redirects home with a notice; expired → page shows retry).
import { $ } from "lib/utils"

export function initPayment() {
  const el = $("[data-payment]")
  if (!el) return
  const startedAt = Date.now()
  const timer = setInterval(async () => {
    if (Date.now() - startedAt > 20 * 60 * 1000) return clearInterval(timer)
    try {
      const response = await fetch(el.dataset.paymentUrl, { headers: { Accept: "application/json" }, credentials: "same-origin" })
      if (!response.ok) return
      const { status } = await response.json()
      if (status !== "pending") {
        clearInterval(timer)
        window.location.reload()
      }
    } catch (error) {
      console.error(error)
    }
  }, 3000)
}
