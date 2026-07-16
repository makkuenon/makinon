function setLayout(type) {
  ["grid", "list", "dev"].forEach(l => {
    document.getElementById(`layout-${l}`).classList.add("hidden");
  });
  document.getElementById(`layout-${type}`).classList.remove("hidden");
  localStorage.setItem("preferredLayout", type);
}
