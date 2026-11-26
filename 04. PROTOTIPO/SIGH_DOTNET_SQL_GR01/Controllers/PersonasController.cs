using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Diagnostics;
using System.Drawing;
using System.Drawing.Imaging;
using System.IO;
using System.Linq;
using System.Text.RegularExpressions;
using System.Web;
using System.Web.Helpers;
using System.Web.Mvc;
using System.Web.UI;
using SighDotNet.Models;

namespace SighDotNet.Controllers
{
    [Authorize]
    [OutputCache(NoStore = true, Duration = 0, VaryByParam = "*", Location = OutputCacheLocation.None)]
    public sealed class PersonasController : Controller
    {
        private readonly CatalogoPersonas catalogo = new CatalogoPersonas();
        private static string Pestana(string tab) => tab == "identificacion" ? tab : "generales";

        [HttpGet, Route("persona")]
        public ActionResult Index(string codigo, string modo, string nav, string tab, string aviso)
        {
            codigo = (codigo ?? "").Trim().ToUpperInvariant();
            if (codigo.Length > 10) return new HttpStatusCodeResult(400);
            Persona actual = null;
            if (modo != "nuevo")
                actual = string.IsNullOrEmpty(nav) ? catalogo.Buscar(codigo) : catalogo.Navegar(nav, codigo);
            if (actual == null && codigo.Length > 0 && modo != "nuevo")
            {
                Response.StatusCode = 404;
                Response.TrySkipIisCustomErrors = true;
                ModelState.AddModelError("", "La persona no existe.");
            }
            string mensaje = aviso == "guardado" ? "Persona guardada correctamente." : aviso == "borrado" ? "Persona eliminada." : null;
            return Mostrar(actual ?? new Persona(), tab, actual == null && modo != "nuevo", modo == "listar", mensaje);
        }

        [HttpPost, Route("persona"), ValidateAntiForgeryToken]
        public ActionResult Guardar([Bind(Prefix = "Datos", Include = "Codigo,Apellidos,Nombres,Genero,EstadoCivil,FechaNacimiento,CargasFamiliares,Discapacidad,TipoDocumento,Documento,Email")] Persona datos,
            string accion, string tab, HttpPostedFileBase foto)
        {
            datos.Codigo = (datos.Codigo ?? "").Trim().ToUpperInvariant();
            tab = Pestana(tab);
            if (datos.Codigo.Length > 10 || (accion != "guardar" && accion != "borrar")) return new HttpStatusCodeResult(400);
            Persona anterior = string.IsNullOrEmpty(datos.Codigo) ? null : catalogo.Buscar(datos.Codigo);
            if (!string.IsNullOrEmpty(datos.Codigo) && anterior == null) return HttpNotFound("La persona no existe.");
            if (accion == "borrar")
            {
                if (anterior == null) return new HttpStatusCodeResult(400);
                try
                {
                    if (!catalogo.Eliminar(datos.Codigo)) return HttpNotFound();
                    BorrarFotoNueva(anterior.Foto);
                    return RedirectToAction("Index", new { tab, aviso = "borrado" });
                }
                catch (SqlException ex) when (ex.Number == 547)
                {
                    ModelState.Clear();
                    ModelState.AddModelError("", "La persona tiene registros asociados y no se puede eliminar.");
                    Response.StatusCode = 409;
                    Response.TrySkipIisCustomErrors = true;
                    return Mostrar(anterior, tab, false, false);
                }
            }
            datos.Foto = anterior?.Foto;
            if (!catalogo.Generos().Any(x => x.Value == datos.Genero)) ModelState.AddModelError("Datos.Genero", "Selecciona el sexo.");
            if (!catalogo.EstadosCiviles().Any(x => x.Value == datos.EstadoCivil)) ModelState.AddModelError("Datos.EstadoCivil", "Selecciona el estado civil.");
            if (datos.FechaNacimiento.HasValue && (datos.FechaNacimiento.Value.Date > DateTime.Today || datos.FechaNacimiento.Value.Year < 1753))
                ModelState.AddModelError("Datos.FechaNacimiento", "La fecha debe estar entre 1753 y hoy.");
            string patron = datos.TipoDocumento == "CEDULA" ? @"\A[0-9]{10}\z" : @"\A[A-Za-z0-9]{1,15}\z";
            if (!Regex.IsMatch(datos.Documento ?? "", patron)) ModelState.AddModelError("Datos.Documento", "Ingresa una cédula de 10 dígitos o un pasaporte de hasta 15 letras o números.");
            if (!ModelState.IsValid) return Invalido(datos, tab);
            string nuevaFoto = null;
            try
            {
                nuevaFoto = GuardarFoto(foto);
                string codigo = catalogo.Guardar(datos, nuevaFoto);
                if (codigo == null)
                {
                    BorrarFotoNueva(nuevaFoto);
                    return HttpNotFound("La persona ya no existe.");
                }
                return RedirectToAction("Index", new { tab, aviso = "guardado" });
            }
            catch (ArgumentException ex)
            {
                BorrarFotoNueva(nuevaFoto);
                ModelState.AddModelError("foto", ex.Message);
                return Invalido(datos, tab);
            }
            catch
            {
                BorrarFotoNueva(nuevaFoto);
                throw;
            }
        }

        [HttpGet, Route("persona/foto")]
        public ActionResult Foto(string codigo)
        {
            if (string.IsNullOrEmpty(codigo) || codigo.Length > 10) return HttpNotFound();
            var persona = catalogo.Buscar(codigo);
            if (persona == null) return HttpNotFound();
            if (Regex.IsMatch(persona.Foto ?? "", @"\A[a-f0-9]{32}\.png\z"))
            {
                string ruta = Path.Combine(Server.MapPath("~/App_Data/Fotos"), persona.Foto);
                if (System.IO.File.Exists(ruta)) return File(ruta, "image/png");
            }
            return File(Server.MapPath("~/Resources/persona.svg"), "image/svg+xml");
        }

        private ActionResult Invalido(Persona datos, string tab)
        {
            Response.StatusCode = 400;
            Response.TrySkipIisCustomErrors = true;
            if (ModelState.Any(x => x.Value.Errors.Count > 0 && (x.Key == "Datos.Documento" || x.Key == "Datos.TipoDocumento" || x.Key == "Datos.Email")))
                tab = "identificacion";
            return Mostrar(datos, tab, false, false);
        }

        private ActionResult Mostrar(Persona datos, string tab, bool bloqueado, bool listar, string aviso = null) => View("Index", new PersonaVista
        {
            Datos = datos, Generos = catalogo.Generos(), EstadosCiviles = catalogo.EstadosCiviles(),
            Personas = listar ? catalogo.Listar() : Array.Empty<Persona>(), Tab = Pestana(tab), Bloqueado = bloqueado, Aviso = aviso
        });

        private string GuardarFoto(HttpPostedFileBase foto)
        {
            if (foto == null || foto.ContentLength == 0) return null;
            if (foto.ContentLength > 2 * 1024 * 1024) throw new ArgumentException("La foto no puede superar 2 MB.");
            using (var imagen = LeerImagen(foto))
            {
                if (imagen.Width > 4000 || imagen.Height > 4000) throw new ArgumentException("La foto admite hasta 4000 × 4000 píxeles.");
                string nombre = Guid.NewGuid().ToString("N") + ".png";
                string carpeta = Server.MapPath("~/App_Data/Fotos");
                Directory.CreateDirectory(carpeta);
                try
                {
                    using (var copia = new Bitmap(imagen))
                        copia.Save(Path.Combine(carpeta, nombre), ImageFormat.Png);
                }
                catch
                {
                    System.IO.File.Delete(Path.Combine(carpeta, nombre));
                    throw;
                }
                return nombre;
            }
        }

        private static Image LeerImagen(HttpPostedFileBase foto)
        {
            Image imagen;
            try { imagen = Image.FromStream(foto.InputStream, false, true); }
            catch (Exception ex) when (ex is ArgumentException || ex is OutOfMemoryException)
            { throw new ArgumentException("Selecciona una imagen PNG o JPG válida."); }
            if (imagen.RawFormat.Guid != ImageFormat.Png.Guid && imagen.RawFormat.Guid != ImageFormat.Jpeg.Guid)
            {
                imagen.Dispose();
                throw new ArgumentException("Solo se admiten imágenes PNG o JPG.");
            }
            return imagen;
        }

        private void BorrarFotoNueva(string nombre)
        {
            if (!Regex.IsMatch(nombre ?? "", @"\A[a-f0-9]{32}\.png\z")) return;
            try { System.IO.File.Delete(Path.Combine(Server.MapPath("~/App_Data/Fotos"), nombre)); }
            catch (Exception ex) when (ex is IOException || ex is UnauthorizedAccessException)
            { Trace.TraceWarning("No se pudo retirar la foto: {0}", ex.Message); }
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
                Trace.TraceError("Error al acceder a personas: {0}", filterContext.Exception);
                filterContext.Result = new HttpStatusCodeResult(503, "No se pudo acceder al servicio de personas.");
                filterContext.ExceptionHandled = true;
            }
            Response.TrySkipIisCustomErrors = true;
        }
    }
}
