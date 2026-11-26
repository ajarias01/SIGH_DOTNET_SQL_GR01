using System;
using System.Data;
using System.Linq;

namespace SighDotNet.Models
{
    public sealed class DatosReporte
    {
        public DataTable Departamentos()
        {
            var tabla = new DataTable("Datos");
            tabla.Columns.Add("Codigo"); tabla.Columns.Add("Descripcion");
            foreach (var d in new CatalogoDepartamentos().Listar()) tabla.Rows.Add(d.Codigo, d.Descripcion);
            return tabla;
        }

        public DataTable Cargos(string departamento)
        {
            var tabla = new DataTable("Datos");
            tabla.Columns.Add("Codigo"); tabla.Columns.Add("Descripcion"); tabla.Columns.Add("Departamento"); tabla.Columns.Add("DepartamentoDescripcion");
            foreach (var c in new CatalogoCargos().Listar(departamento))
                tabla.Rows.Add(c.Departamento + "-" + c.Codigo, c.Descripcion, c.Departamento, c.DepartamentoDescripcion);
            return tabla;
        }

        public DataTable Personas(string codigo = null)
        {
            var catalogo = new CatalogoPersonas();
            var tabla = new DataTable("Datos");
            foreach (string nombre in new[] { "Codigo", "Apellidos", "Nombres", "Sexo", "EstadoCivil", "Documento", "TipoDocumento", "Email", "Discapacidad", "ArchivoFoto" })
                tabla.Columns.Add(nombre);
            tabla.Columns.Add("FechaNacimiento", typeof(DateTime));
            tabla.Columns.Add("CargasFamiliares", typeof(int));
            tabla.Columns.Add("Foto", typeof(byte[]));
            var generos = catalogo.Generos().ToDictionary(x => x.Value, x => x.Text);
            var estados = catalogo.EstadosCiviles().ToDictionary(x => x.Value, x => x.Text);
            var personas = codigo == null ? catalogo.Listar() : new[] { catalogo.Buscar(codigo) };
            foreach (var persona in personas.Where(x => x != null).OrderBy(x => x.Apellidos).ThenBy(x => x.Nombres))
            {
                string sexo, civil;
                generos.TryGetValue(persona.Genero, out sexo); estados.TryGetValue(persona.EstadoCivil, out civil);
                tabla.Rows.Add(persona.Codigo, persona.Apellidos, persona.Nombres, sexo, civil, persona.Documento,
                    string.IsNullOrEmpty(persona.Documento) ? "" : persona.TipoDocumento == "CEDULA" ? "Cédula" : "Pasaporte",
                    persona.Email, persona.Discapacidad ? "Sí" : "No", persona.Foto,
                    (object)persona.FechaNacimiento ?? DBNull.Value, persona.CargasFamiliares, DBNull.Value);
            }
            return tabla;
        }
    }
}
