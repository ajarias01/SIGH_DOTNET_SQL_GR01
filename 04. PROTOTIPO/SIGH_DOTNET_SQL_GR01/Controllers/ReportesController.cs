using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Diagnostics;
using System.Globalization;
using System.IO;
using System.Text.RegularExpressions;
using System.Web.Mvc;
using System.Web.UI;
using Microsoft.Reporting.WebForms;
using SighDotNet.Models;

namespace SighDotNet.Controllers
{
    [Authorize]
    [OutputCache(NoStore = true, Duration = 0, VaryByParam = "*", Location = OutputCacheLocation.None)]
    public sealed class ReportesController : Controller
    {
        [HttpGet, Route("reporte")]
        public ActionResult Pdf(string r, string departamento, string codigo)
        {
            var origen = new DatosReporte();
            DataTable datos;
            string plantilla, nombre;
            string filtro = "";
            switch (r)
            {
                case "departamentos":
                    datos = origen.Departamentos(); plantilla = "Departamentos"; nombre = "departamentos.pdf"; break;
                case "cargos":
                    departamento = Departamento.NormalizarCodigo(departamento);
                    if (departamento.Length > 0 && (!Regex.IsMatch(departamento, @"\A[A-Z0-9]{1,3}\z") || new CatalogoDepartamentos().Buscar(departamento) == null))
                        return new HttpStatusCodeResult(400, "Departamento inválido.");
                    datos = origen.Cargos(departamento); plantilla = "Cargos"; nombre = "cargos.pdf";
                    filtro = departamento.Length == 0 ? "Todos los departamentos" : "Departamento " + departamento;
                    break;
                case "personas":
                    datos = origen.Personas(); plantilla = "Personas"; nombre = "personas.pdf"; break;
                case "ficha":
                    codigo = (codigo ?? "").Trim().ToUpperInvariant();
                    if (!Regex.IsMatch(codigo, @"\A[A-Z0-9-]{1,10}\z")) return HttpNotFound();
                    datos = origen.Personas(codigo);
                    if (datos.Rows.Count == 0) return HttpNotFound("La persona no existe.");
                    CargarFoto(datos.Rows[0]);
                    plantilla = "FichaPersona"; nombre = "ficha-" + codigo + ".pdf"; break;
                default: return HttpNotFound("Reporte desconocido.");
            }
            using (datos)
            using (var reporte = new LocalReport())
            {
                reporte.ReportPath = Server.MapPath("~/Reportes/" + plantilla + ".rdlc");
                reporte.DataSources.Add(new ReportDataSource("Datos", datos));
                var fecha = TimeZoneInfo.ConvertTimeFromUtc(DateTime.UtcNow, TimeZoneInfo.FindSystemTimeZoneById("SA Pacific Standard Time"));
                reporte.SetParameters(new[]
                {
                    new ReportParameter("Usuario", User.Identity.Name),
                    new ReportParameter("Fecha", fecha.ToString("dd/MM/yyyy HH:mm", CultureInfo.InvariantCulture)),
                    new ReportParameter("Filtro", filtro)
                });
                string mime, codificacion, extension;
                string[] streams;
                Warning[] avisos;
                byte[] pdf = reporte.Render("PDF", null, out mime, out codificacion, out extension, out streams, out avisos);
                foreach (var aviso in avisos) Trace.TraceWarning("Reporte {0}: {1}", plantilla, aviso.Message);
                Response.AddHeader("Content-Disposition", "inline; filename=\"" + nombre + "\"");
                Response.AddHeader("X-Content-Type-Options", "nosniff");
                return File(pdf, "application/pdf");
            }
        }

        private void CargarFoto(DataRow persona)
        {
            string archivo = Convert.ToString(persona["ArchivoFoto"]);
            if (!Regex.IsMatch(archivo, @"\A[a-f0-9]{32}\.png\z")) return;
            string ruta = Path.Combine(Server.MapPath("~/App_Data/Fotos"), archivo);
            try { persona["Foto"] = System.IO.File.ReadAllBytes(ruta); }
            catch (IOException) { Trace.TraceWarning("No se encontró la foto para el reporte de {0}.", persona["Codigo"]); }
        }

        protected override void OnException(ExceptionContext filterContext)
        {
            Trace.TraceError("Error al generar el reporte: {0}", filterContext.Exception);
            int estado = filterContext.Exception is SqlException || filterContext.Exception is ConfigurationErrorsException ? 503 : 500;
            filterContext.Result = new HttpStatusCodeResult(estado, "No se pudo generar el reporte.");
            filterContext.ExceptionHandled = true;
            Response.TrySkipIisCustomErrors = true;
        }
    }
}
