using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Diagnostics;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using System.Web.Helpers;
using System.Web.Mvc;
using System.Web.UI;
using SighDotNet.Models;

namespace SighDotNet.Controllers
{
    [Authorize]
    [OutputCache(NoStore = true, Duration = 0, VaryByParam = "*", Location = OutputCacheLocation.None)]
    public sealed class CargosController : Controller
    {
        private readonly CatalogoDepartamentos departamentos = new CatalogoDepartamentos();
        private readonly CatalogoCargos cargos = new CatalogoCargos();
        private static bool CodigoValido(string codigo) => Regex.IsMatch(codigo, @"\A[A-Z0-9]{1,3}\z");

        [HttpGet, Route("cargos")]
        public ActionResult Index(string filtro, string modo, string depto, string codigo)
        {
            if (string.IsNullOrEmpty(modo) || modo == "crear") return Mostrar(filtro, "crear", null);
            if (modo != "editar" && modo != "eliminar") return new HttpStatusCodeResult(400);
            depto = Departamento.NormalizarCodigo(depto);
            codigo = Departamento.NormalizarCodigo(codigo);
            var actual = CodigoValido(depto) && CodigoValido(codigo) ? cargos.Buscar(depto, codigo) : null;
            return actual == null ? Mostrar(filtro, "crear", null, 404, "El cargo no existe.") : Mostrar(filtro, modo, actual);
        }

        [HttpPost, Route("cargos"), ValidateAntiForgeryToken]
        public ActionResult Guardar(string modo, string departamento, string codigo, string descripcion, string filtro)
        {
            if (modo != "crear" && modo != "editar" && modo != "eliminar") return new HttpStatusCodeResult(400);
            departamento = Departamento.NormalizarCodigo(departamento);
            codigo = Departamento.NormalizarCodigo(codigo);
            descripcion = string.IsNullOrWhiteSpace(descripcion) ? null : descripcion.Trim();
            var cargo = new Cargo { Departamento = departamento, Codigo = codigo, Descripcion = descripcion };
            if (!CodigoValido(departamento) || departamentos.Buscar(departamento) == null)
                return Mostrar(filtro, "crear", cargo, 400, "Selecciona un departamento válido.");
            if (modo != "crear" && !CodigoValido(codigo))
                return Mostrar(filtro, "crear", cargo, 400, "El código del cargo no es válido.");
            if (modo != "eliminar" && descripcion != null && Encoding.UTF32.GetByteCount(descripcion) / 4 > 50)
                return Mostrar(filtro, modo, cargo, 400, "La descripción debe tener hasta 50 caracteres.");
            try
            {
                bool guardado;
                if (modo == "crear")
                {
                    guardado = cargos.Crear(cargo) != null;
                    if (!guardado) return Mostrar(filtro, modo, cargo, 409, "No se pudo generar el código. Revisa el departamento o sus códigos disponibles.");
                }
                else
                {
                    guardado = modo == "editar" ? cargos.Editar(cargo) : cargos.Eliminar(departamento, codigo);
                }
                return guardado ? RedirectToAction("Index", new { filtro = Departamento.NormalizarCodigo(filtro) })
                    : Mostrar(filtro, "crear", null, 404, "El cargo no existe.");
            }
            catch (SqlException ex) when (ex.Number == 547)
            {
                return Mostrar(filtro, modo, cargo, 409, "No se puede completar la operación porque hay registros relacionados.");
            }
        }

        private ActionResult Mostrar(string filtro, string modo, Cargo cargo, int estado = 200, string error = null)
        {
            filtro = Departamento.NormalizarCodigo(filtro);
            var opciones = departamentos.Listar();
            bool valido = filtro.Length == 0 || opciones.Any(d => d.Codigo == filtro);
            if (!valido) { estado = 400; error = "Selecciona un departamento de la lista."; }
            Response.StatusCode = estado;
            Response.TrySkipIisCustomErrors = true;
            return View("Index", new CargosVista
            {
                Departamentos = opciones, Cargos = valido ? cargos.Listar(filtro) : Array.Empty<Cargo>(),
                Filtro = filtro, Error = error, Cargo = cargo, Modo = modo, Siguientes = cargos.Siguientes()
            });
        }

        protected override void OnException(ExceptionContext filterContext)
        {
            if (filterContext.Exception is HttpAntiForgeryException)
            {
                filterContext.Result = new HttpStatusCodeResult(400);
                filterContext.ExceptionHandled = true;
            }
            else if (filterContext.Exception is SqlException || filterContext.Exception is ConfigurationErrorsException)
            {
                Trace.TraceError("Error al acceder a cargos: {0}", filterContext.Exception);
                filterContext.Result = new HttpStatusCodeResult(503, "No se pudo acceder al servicio de cargos.");
                filterContext.ExceptionHandled = true;
            }
            Response.TrySkipIisCustomErrors = true;
        }
    }
}
