using System.Configuration;
using System.Data.SqlClient;
using System.Diagnostics;
using System.Web.Helpers;
using System.Web.Mvc;
using System.Web.Security;
using System.Web.UI;
using SighDotNet.Models;

namespace SighDotNet.Controllers
{
    [OutputCache(NoStore = true, Duration = 0, VaryByParam = "*", Location = OutputCacheLocation.None)]
    public sealed class AccesoController : Controller
    {
        private readonly AutenticacionBD autenticacion = new AutenticacionBD();

        [HttpGet]
        [Route("")]
        public ActionResult Acceso()
        {
            if (User.Identity.IsAuthenticated)
            {
                return RedirectToAction(nameof(Inicio));
            }

            return View(new AccesoFormulario());
        }

        [HttpPost]
        [Route("login")]
        [ValidateAntiForgeryToken]
        public ActionResult Ingresar(AccesoFormulario formulario)
        {
            if (!ModelState.IsValid)
            {
                Response.StatusCode = 400;
                Response.TrySkipIisCustomErrors = true;
                return Error(formulario.Nombre, "Ingresa un usuario y una contraseña válidos.");
            }

            Usuario usuario;
            try
            {
                usuario = autenticacion.Autenticar(formulario.Nombre, formulario.Clave);
            }
            catch (SqlException ex)
            {
                Trace.TraceError("Error de SQL Server al autenticar: {0}", ex);
                return BaseDeDatosNoDisponible(formulario.Nombre);
            }
            catch (ConfigurationErrorsException ex)
            {
                Trace.TraceError("Error de configuración al autenticar: {0}", ex);
                return BaseDeDatosNoDisponible(formulario.Nombre);
            }
            if (usuario == null)
            {
                return Error(formulario.Nombre, "Usuario o contraseña incorrectos.");
            }

            FormsAuthentication.SetAuthCookie(usuario.Nombre, false);
            return RedirectToAction(nameof(Inicio));
        }

        [Authorize]
        [HttpGet]
        [Route("inicio")]
        public ActionResult Inicio() => View();

        [Authorize]
        [HttpPost]
        [Route("salir")]
        [ValidateAntiForgeryToken]
        public ActionResult Salir()
        {
            FormsAuthentication.SignOut();
            return RedirectToAction(nameof(Acceso));
        }

        protected override void OnException(ExceptionContext filterContext)
        {
            if (filterContext.Exception is HttpAntiForgeryException)
            {
                Response.TrySkipIisCustomErrors = true;
                filterContext.Result = new HttpStatusCodeResult(400);
                filterContext.ExceptionHandled = true;
            }
        }

        private ActionResult BaseDeDatosNoDisponible(string nombre)
        {
            Response.StatusCode = 503;
            Response.TrySkipIisCustomErrors = true;
            return Error(nombre, "No se pudo conectar con el servicio de acceso. Inténtalo de nuevo más tarde.");
        }

        private ActionResult Error(string nombre, string mensaje)
        {
            ViewData["Error"] = mensaje;
            return View(nameof(Acceso), new AccesoFormulario { Nombre = nombre ?? "" });
        }
    }
}
