function renderDev(apps) {
  const dev = document.getElementById("layout-dev");
  dev.innerHTML = `
    <table>
      <tr><th>Name</th><th>Bundle</th><th>Version</th><th>Action</th></tr>
      ${apps.map(app => `
        <tr>
          <td>${app.name}</td>
          <td>${app.bundleId}</td>
          <td>${app.latestVersion}</td>
          <td><button onclick="selectLibraryIPA('${app.id}')">Sign</button></td>
        </tr>
      `).join("")}
    </table>
  `;
}
