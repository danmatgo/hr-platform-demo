import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = []

  connect() {
    this.dir = {}
  }

  sort(event) {
    const key = event.currentTarget.dataset.tableKey
    const tbody = this.element.querySelector('tbody')
    const rows = Array.from(tbody.querySelectorAll('tr'))
    const idx = Array.from(this.element.querySelectorAll('thead th')).indexOf(event.currentTarget)
    const dir = this.dir[key] === 'asc' ? 'desc' : 'asc'
    this.dir[key] = dir

    rows.sort((a, b) => {
      const av = a.children[idx].textContent.trim()
      const bv = b.children[idx].textContent.trim()
      const na = parseFloat(av.replace(/[^0-9.-]/g, ''))
      const nb = parseFloat(bv.replace(/[^0-9.-]/g, ''))
      const isNum = !Number.isNaN(na) && !Number.isNaN(nb)
      if (isNum) {
        return dir === 'asc' ? na - nb : nb - na
      }
      return dir === 'asc' ? av.localeCompare(bv) : bv.localeCompare(av)
    })

    rows.forEach(r => tbody.appendChild(r))
  }
}
