using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;

namespace SighDotNet.Models
{
    public sealed class CatalogoDepartamentos
    {
        private const string Seleccionar = "SELECT PEDEP_CODIGO, PEDEP_DESCRIP FROM dbo.PEDEP_DEPAR";

        public Departamento[] Listar() => Consultar(Seleccionar + " ORDER BY PEDEP_CODIGO");

        public Departamento Buscar(string codigo) =>
            Consultar(Seleccionar + " WHERE PEDEP_CODIGO = @codigo", Codigo(codigo)).SingleOrDefault();

        public bool Crear(Departamento departamento)
        {
            try
            {
                return Ejecutar("INSERT INTO dbo.PEDEP_DEPAR (PEDEP_CODIGO, PEDEP_DESCRIP) VALUES (@codigo, @descripcion)",
                    Codigo(departamento.Codigo), Descripcion(departamento.Descripcion));
            }
            catch (SqlException ex) when (ex.Number == 2601 || ex.Number == 2627)
            {
                return false;
            }
        }

        public bool Editar(Departamento departamento) =>
            Ejecutar("UPDATE dbo.PEDEP_DEPAR SET PEDEP_DESCRIP = @descripcion WHERE PEDEP_CODIGO = @codigo",
                Codigo(departamento.Codigo), Descripcion(departamento.Descripcion));

        public bool Eliminar(string codigo) =>
            Ejecutar("DELETE FROM dbo.PEDEP_DEPAR WHERE PEDEP_CODIGO = @codigo", Codigo(codigo));

        private static Departamento[] Consultar(string sql, SqlParameter parametro = null)
        {
            var departamentos = new List<Departamento>();
            using (var conexion = Conectar())
            using (var comando = new SqlCommand(sql, conexion))
            {
                if (parametro != null) comando.Parameters.Add(parametro);
                conexion.Open();
                using (var lector = comando.ExecuteReader())
                {
                    while (lector.Read())
                    {
                        departamentos.Add(new Departamento(lector.GetString(0).TrimEnd(),
                            lector.IsDBNull(1) ? null : lector.GetString(1)));
                    }
                }
            }
            return departamentos.ToArray();
        }

        private static bool Ejecutar(string sql, params SqlParameter[] parametros)
        {
            using (var conexion = Conectar())
            using (var comando = new SqlCommand(sql, conexion))
            {
                comando.Parameters.AddRange(parametros);
                conexion.Open();
                return comando.ExecuteNonQuery() > 0;
            }
        }

        internal static SqlConnection Conectar()
        {
            var configuracion = ConfigurationManager.ConnectionStrings["SighBD"];
            if (configuracion == null || string.IsNullOrWhiteSpace(configuracion.ConnectionString))
            {
                throw new ConfigurationErrorsException("Falta la conexiÃ³n SighBD en Web.config.");
            }
            return new SqlConnection(configuracion.ConnectionString);
        }

        private static SqlParameter Codigo(string valor) =>
            new SqlParameter("@codigo", SqlDbType.Char, 3) { Value = valor };

        private static SqlParameter Descripcion(string valor) =>
            new SqlParameter("@descripcion", SqlDbType.VarChar, 50) { Value = (object)valor ?? System.DBNull.Value };
    }
}
