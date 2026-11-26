using System.Configuration;
using System.Data.SqlClient;
using System.Diagnostics;
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
    public sealed class DepartamentosController : Controller
    {
        private const string PatronCodigo = @"\A[A-Z0-9]{1,3}\z";
        private static readonly CatalogoDepartamentos catalogo = new CatalogoDepartamentos();

        [HttpGet]
        [Route("departamentos")]
        public ActionResult Index(string modo, string codigo)
        {
            if (modo == "editar" || modo == "eliminar")
            {
                codigo = Departamento.NormalizarCodigo(codigo);
                var actual = Regex.IsMatch(codigo, PatronCodigo) ? catalogo.Buscar(codigo) : null;
                return actual == null
                    ? Mostrar("crear", null, 404, "El departamento no existe.")
                    : Mostrar(modo, actual);
            }

            return Mostrar("crear", null);
        }

        [HttpPost]
        [Route("departamentos")]
        [ValidateAntiForgeryToken]
        public ActionResult Guardar(string modo, string codigo, string descripcion)
        {
            if (modo != "crear" && modo != "editar" && modo != "eliminar")
            {
                return new HttpStatusCodeResult(400);
            }

            codigo = Departamento.NormalizarCodigo(codigo);
            descripcion = string.IsNullOrWhiteSpace(descripcion) ? null : descripcion.Trim();
            var departamento = new Departamento(codigo, descripcion);
            if (!Regex.IsMatch(codigo, PatronCodigo))
            {
                return Mostrar("crear", departamento, 400, "El código debe tener de 1 a 3 letras o números.");
            }
            if (modo != "eliminar" && descripcion != null && Encoding.UTF32.GetByteCount(descripcion) / 4 > 50)
            {
                return Mostrar(modo, departamento, 400, "La descripción debe tener hasta 50 caracteres.");
            }

            if (modo == "crear")
            {
                return catalogo.Crear(departamento) ? RedirectToAction(nameof(Index))
                    : Mostrar(modo, departamento, 409, "Ese código ya está registrado.");
            }
            try
            {
                bool guardado = modo == "editar" ? catalogo.Editar(departamento) : catalogo.Eliminar(codigo);
                return guardado ? RedirectToAction(nameof(Index))
                    : Mostrar("crear", null, 404, "El departamento no existe.");
            }
            catch (SqlException ex) when (modo == "eliminar" && ex.Number == 547)
            {
                return Mostrar(modo, departamento, 409, "El departamento tiene registros asociados y no se puede eliminar.");
            }
        }

        protected override void OnException(ExceptionContext filterContext)
        {
            if (filterContext.Exception is HttpAntiForgeryException)
            {
                Response.TrySkipIisCustomErrors = true;
                filterContext.Result = new HttpStatusCodeResult(400);
                filterContext.ExceptionHandled = true;
            }
            else if (filterContext.Exception is SqlException || filterContext.Exception is ConfigurationErrorsException)
            {
                Trace.TraceError("Error al acceder al catálogo de departamentos: {0}", filterContext.Exception);
                Response.StatusCode = 503;
                Response.TrySkipIisCustomErrors = true;
                filterContext.Result = Content("No se pudo acceder a los departamentos. Revisa la conexión con SQL Server.", "text/plain");
                filterContext.ExceptionHandled = true;
            }
        }

        private ActionResult Mostrar(string modo, Departamento departamento, int estado = 200, string error = null)
        {
            Response.StatusCode = estado;
            Response.TrySkipIisCustomErrors = true;
            return View("Index", new DepartamentosVista
            {
                Departamentos = catalogo.Listar(),
                Departamento = departamento,
                Modo = modo,
                Error = error
            });
        }
    }
}
