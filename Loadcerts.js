async function loadCerts() {
  const res = await fetch("/api/certs");
  const certs = await res.json();

  const select = document.getElementById("certSelect");
  select.innerHTML = certs.map(c => `
    <option value="${c.id}">${c.name} (${c.type})</option>
  `).join("");

  renderCertPanel(certs);
}
