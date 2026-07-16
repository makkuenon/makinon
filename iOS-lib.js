async function loadLibrary() {
  const res = await fetch("/api/apps");
  const apps = await res.json();

  renderGrid(apps);
  renderList(apps);
  renderDev(apps);
}
