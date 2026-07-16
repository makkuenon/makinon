function renderGrid(apps) {
  const grid = document.getElementById("layout-grid");
  grid.innerHTML = apps.map(app => `
    <div class="app-card">
      <img src="${app.icon}" class="app-icon">
      <div class="app-name">${app.name}</div>
      <button class="btn" onclick="selectLibraryIPA('${app.id}')">Sign</button>
    </div>
  `).join("");
}
