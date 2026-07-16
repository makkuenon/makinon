async function signIPA() {
  if (!selectedIPAFile && !selectedIPAId) {
    return log("Select an IPA first.");
  }

  const certId = document.getElementById("certSelect").value;

  const form = new FormData();
  if (selectedIPAFile) form.append("ipa", selectedIPAFile);
  if (selectedIPAId) form.append("ipaId", selectedIPAId);

  form.append("certId", certId);
  form.append("mode", document.getElementById("signMode").value);
  form.append("flags", JSON.stringify({
    thinArm64: document.getElementById("flagArm64").checked,
    stripWatch: document.getElementById("flagWatch").checked,
    cleanPlugins: document.getElementById("flagPlugins").checked
  }));

  startProgress("Signing IPA…");

  const res = await fetch("/api/sign", { method: "POST", body: form });
  const json = await res.json();

  finishProgress("Done!");

  showResult(json);
}
