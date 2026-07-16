let selectedIPAFile = null;
let selectedIPAId = null;

function selectLibraryIPA(id) {
  selectedIPAId = id;
  selectedIPAFile = null;
  log(`Selected library IPA: ${id}`);
}

document.getElementById("ipaInput").onchange = e => {
  selectedIPAFile = e.target.files[0];
  selectedIPAId = null;
  log(`Selected local IPA: ${selectedIPAFile.name}`);
};
