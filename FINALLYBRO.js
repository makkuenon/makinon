window.onload = () => {
  setLayout(localStorage.getItem("preferredLayout") || "grid");
  loadLibrary();
  loadCerts();
};
