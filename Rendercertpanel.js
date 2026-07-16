function renderCertPanel(certs) {
  const panel = document.getElementById("cert-panel");
  panel.innerHTML = certs.map(c => `
    <div class="cert-item">
      <span>${c.name}</span>
      <button onclick="deleteCert('${c.id}')">Delete</button>
    </div>
  `).join("");
}
