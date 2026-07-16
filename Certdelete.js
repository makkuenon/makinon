async function deleteCert(id) {
  await fetch(`/api/certs/${id}`, { method: "DELETE" });
  loadCerts();
}
