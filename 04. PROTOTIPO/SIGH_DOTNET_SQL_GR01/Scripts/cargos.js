(() => {
    const filtro = document.getElementById("filtro");
    filtro.addEventListener("change", () => filtro.form.requestSubmit());
    const departamento = document.getElementById("departamento");
    const codigo = document.getElementById("codigo");
    if (departamento && codigo && departamento.tagName === "SELECT") {
        function actualizarCodigo() {
            const opcion = departamento.selectedOptions[0];
            codigo.value = opcion.dataset.siguiente || "";
            codigo.placeholder = departamento.value ? "Sin códigos disponibles" : "Elige un departamento";
        }
        departamento.addEventListener("change", actualizarCodigo);
        actualizarCodigo();
    }
})();
