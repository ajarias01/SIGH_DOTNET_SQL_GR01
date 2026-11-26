const boton = document.querySelector(".ver-clave");

if (boton) {
    const clave = document.getElementById(boton.getAttribute("aria-controls"));
    boton.hidden = false;
    boton.addEventListener("click", () => {
        const visible = clave.type === "password";
        clave.type = visible ? "text" : "password";
        boton.textContent = visible ? "Ocultar" : "Mostrar";
    });
}
