function showResult(result) {
  log("Signed IPA ready.");
  log("Download: " + result.signedIpaUrl);
  log("OTA: " + result.otaUrl);

  document.getElementById("downloadBtn").onclick = () => {
    window.location = result.signedIpaUrl;
  };

  document.getElementById("otaBtn").onclick = () => {
    navigator.clipboard.writeText(result.otaUrl);
    log("OTA link copied.");
  };

  document.getElementById("manifestBtn").onclick = () => {
    log("Manifest: " + result.manifestUrl);
  };
}
