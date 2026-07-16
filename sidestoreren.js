function renderList(apps) {
  const list = document.getElementById("layout-list");
  list.innerHTML = apps.map(app => `
    <div class="app-row">
      <span>${app.name}</span>
      <button class="btn btn-ghost" onclick="selectLibraryIPA('${app.id}')">Sign</button>
    </div>
  `).join("");
}
