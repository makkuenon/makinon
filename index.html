<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>SideSigner Hub</title>
<meta name="viewport" content="width=device-width, initial-scale=1">
<style>
/* Minimal GD-themed styling */
:root {
  --bg:#05060a;--bg-alt:#0b0d14;--accent:#4af3ff;--text:#f5f7ff;--muted:#8b90a5;--radius:14px;
}
body{margin:0;background:radial-gradient(circle at top,#15192b 0,#05060a 55%);color:var(--text);font-family:-apple-system,system-ui,sans-serif;padding:20px;}
.page{max-width:1200px;margin:auto;}
.grid{display:grid;grid-template-columns:2fr 1fr;gap:20px;}
.card{background:var(--bg-alt);border-radius:var(--radius);border:1px solid #1b1f2f;padding:16px;box-shadow:0 18px 40px rgba(0,0,0,.45);}
.btn{padding:8px 14px;border-radius:999px;border:none;cursor:pointer;font-size:13px;}
.btn-primary{background:var(--accent);color:#020308;font-weight:600;}
.btn-ghost{background:transparent;border:1px solid #262b3f;color:var(--muted);}
.console{background:#05060a;border:1px solid #1b1f2f;padding:10px;font-family:monospace;font-size:12px;height:160px;overflow-y:auto;}
.app-list{max-height:220px;overflow-y:auto;margin-top:10px;}
.app-item{display:flex;justify-content:space-between;align-items:center;padding:6px 0;border-bottom:1px solid #15192b;font-size:13px;}
</style>
</head>
<body>
<div class="page">

<h2>SideSigner Hub</h2>

<div class="grid">
  <!-- Signing panel -->
  <section class="card">
    <h3>Sign IPA</h3>

    <label>IPA source</label><br>
    <button class="btn btn-ghost" id="uploadIpaBtn">Upload IPA</button>
    <button class="btn btn-ghost" id="pickFromLibraryBtn">Pick from library</button>
    <input type="file" id="ipaInput" accept=".ipa" hidden>

    <p id="selectedIpaLabel" style="font-size:12px;color:var(--muted);margin-top:6px;">No IPA selected.</p>

    <label>Certificate</label><br>
    <select id="certSelect" style="margin-top:4px;width:100%;"></select>

    <label style="margin-top:10px;">Signing mode</label><br>
    <select id="signMode" style="margin-top:4px;width:100%;">
      <option value="free">Apple ID (7 days)</option>
      <option value="dev">Developer (1 year)</option>
      <option value="enterprise">Enterprise</option>
    </select>

    <button class="btn btn-primary" id="signBtn" style="margin-top:12px;">Sign</button>

    <div class="console" id="consoleLog" style="margin-top:12px;">Ready.</div>
  </section>

  <!-- IPA library panel -->
  <aside class="card">
    <h3>IPA Library</h3>
    <input type="text" id="searchInput" placeholder="Search apps…" style="width:100%;padding:6px;border-radius:8px;border:1px solid #262b3f;background:#05060a;color:var(--text);font-size:13px;">
    <div class="app-list" id="appList"></div>
  </aside>
</div>

<script>
const consoleLog = document.getElementById('consoleLog');
const ipaInput = document.getElementById('ipaInput');
const selectedIpaLabel = document.getElementById('selectedIpaLabel');
let selectedIpaFile = null;
let selectedLibraryIpaId = null;

function log(msg){
  consoleLog.textContent += '\\n' + msg;
  consoleLog.scrollTop = consoleLog.scrollHeight;
}

/* Load certs from server */
async function loadCerts(){
  const res = await fetch('/api/certs');
  const data = await res.json();
  const select = document.getElementById('certSelect');
  select.innerHTML = '';
  data.forEach(c=>{
    const opt = document.createElement('option');
    opt.value = c.id;
    opt.textContent = `${c.name} (${c.type})`;
    select.appendChild(opt);
  });
}

/* Load apps from server */
async function loadApps(query=''){
  const res = await fetch('/api/apps?search=' + encodeURIComponent(query));
  const data = await res.json();
  const list = document.getElementById('appList');
  list.innerHTML = '';
  data.forEach(app=>{
    const row = document.createElement('div');
    row.className = 'app-item';
    row.innerHTML = `
      <span>${app.name}</span>
      <button class="btn btn-ghost" data-id="${app.id}">Use</button>
    `;
    list.appendChild(row);
  });
}

/* IPA source: upload */
document.getElementById('uploadIpaBtn').onclick = () => ipaInput.click();
ipaInput.onchange = e => {
  selectedLibraryIpaId = null;
  selectedIpaFile = e.target.files[0];
  selectedIpaLabel.textContent = 'Local IPA: ' + selectedIpaFile.name;
  log('Selected local IPA: ' + selectedIpaFile.name);
};

/* IPA source: library */
document.getElementById('pickFromLibraryBtn').onclick = () => {
  log('Pick an IPA from the library on the right.');
};

document.getElementById('appList').onclick = e => {
  const btn = e.target.closest('button[data-id]');
  if (!btn) return;
  selectedIpaFile = null;
  selectedLibraryIpaId = btn.dataset.id;
  selectedIpaLabel.textContent = 'Library IPA: ' + selectedLibraryIpaId;
  log('Selected library IPA ID: ' + selectedLibraryIpaId);
};

/* Search */
document.getElementById('searchInput').oninput = e => {
  loadApps(e.target.value);
};

/* Sign button */
document.getElementById('signBtn').onclick = async () => {
  if (!selectedIpaFile && !selectedLibraryIpaId){
    return log('Select an IPA (upload or library).');
  }
  const certId = document.getElementById('certSelect').value;
  if (!certId) return log('Select a certificate.');

  log('Starting signing…');

  const form = new FormData();
  if (selectedIpaFile){
    form.append('ipa', selectedIpaFile);
  } else {
    form.append('ipaId', selectedLibraryIpaId);
  }
  form.append('certId', certId);
  form.append('mode', document.getElementById('signMode').value);
  form.append('flags', JSON.stringify({thinArm64:true}));

  const res = await fetch('/api/sign', { method:'POST', body:form });
  if (!res.ok){
    log('Error: ' + res.status);
    return;
  }
  const json = await res.json();
  log('Signed IPA ready.');
  log('Download: ' + json.signedIpaUrl);
  log('OTA: ' + json.otaUrl);
};
loadCerts();
loadApps();
</script>
</body>
</html>
