(() => {
    const form = document.getElementById("frmpersona");
    const tab = document.getElementById("tab");
    const buttons = Array.from(document.querySelectorAll("[role=tab]"));
    function activate(id, focus = false) {
        buttons.forEach(button => {
            const active = button.dataset.panel === id;
            button.setAttribute("aria-selected", String(active));
            button.tabIndex = active ? 0 : -1;
            document.getElementById(button.dataset.panel).hidden = !active;
            if (active && focus) button.focus();
        });
        tab.value = id;
    }
    document.querySelector("[role=tablist]").hidden = false;
    buttons.forEach((button, index) => {
        button.addEventListener("click", () => activate(button.dataset.panel));
        button.addEventListener("keydown", event => {
            let next;
            switch (event.key) {
                case "ArrowRight": next = (index + 1) % buttons.length; break;
                case "ArrowLeft": next = (index + buttons.length - 1) % buttons.length; break;
                case "Home": next = 0; break;
                case "End": next = buttons.length - 1; break;
                default: return;
            }
            event.preventDefault();
            activate(buttons[next].dataset.panel, true);
        });
    });
    activate(tab.value);
    form.addEventListener("invalid", event => {
        const panel = event.target.closest(".panel-pestana");
        if (panel) activate(panel.id);
    }, true);
    document.querySelectorAll(".ficha-nav a").forEach(link => link.addEventListener("click", () => {
        const url = new URL(link.href);
        url.searchParams.set("tab", tab.value);
        link.href = url.href;
    }));
    document.querySelectorAll("[data-confirmar]").forEach(button => button.addEventListener("click", event => {
        if (!window.confirm(button.dataset.confirmar)) event.preventDefault();
    }));
    const type = document.getElementById("Datos_TipoDocumento");
    const documentInput = document.getElementById("Datos_Documento");
    function setDocument() {
        const cedula = type.value === "CEDULA";
        document.getElementById("etiqueta-documento").textContent = cedula ? "Número de cédula" : "Número de pasaporte";
        documentInput.maxLength = cedula ? 10 : 15;
        documentInput.pattern = cedula ? "[0-9]{10}" : "[A-Za-z0-9]{1,15}";
        documentInput.inputMode = cedula ? "numeric" : "text";
    }
    type.addEventListener("change", () => { documentInput.value = ""; setDocument(); });
    setDocument();
    let previewUrl;
    document.getElementById("foto").addEventListener("change", event => {
        const file = event.target.files[0];
        if (!file) return;
        if (file.size > 2 * 1024 * 1024 || !["image/png", "image/jpeg"].includes(file.type)) {
            event.target.value = "";
            window.alert("Selecciona una foto PNG o JPG de hasta 2 MB.");
            return;
        }
        if (previewUrl) URL.revokeObjectURL(previewUrl);
        previewUrl = URL.createObjectURL(file);
        document.getElementById("vista-foto").src = previewUrl;
    });
})();
