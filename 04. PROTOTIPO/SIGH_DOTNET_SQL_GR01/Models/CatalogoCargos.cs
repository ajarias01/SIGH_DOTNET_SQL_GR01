using System;
using System.Collections.Generic;
using System.Linq;
using System.Data;
using System.Data.SqlClient;

namespace SighDotNet.Models
{
    public sealed class CatalogoCargos
    {
        public Cargo[] Listar(string departamento)
        {
            const string seleccionar = @"
                SELECT c.PECAR_CODIGO, c.PECAR_DESCRI, c.PEDEP_CODIGO, d.PEDEP_DESCRIP
                FROM dbo.PECAR_CARGO c
                INNER JOIN dbo.PEDEP_DEPAR d ON d.PEDEP_CODIGO = c.PEDEP_CODIGO";
            string sql = seleccionar;
            if (!string.IsNullOrEmpty(departamento))
            {
                sql += " WHERE c.PEDEP_CODIGO = @departamento";
            }
            sql += " ORDER BY c.PEDEP_CODIGO, c.PECAR_CODIGO";
            var cargos = new List<Cargo>();
            using (var conexion = CatalogoDepartamentos.Conectar())
            using (var comando = new SqlCommand(sql, conexion))
            {
                if (!string.IsNullOrEmpty(departamento))
                {
                    comando.Parameters.Add("@departamento", SqlDbType.Char, 3).Value = departamento;
                }
                conexion.Open();
                using (var lector = comando.ExecuteReader())
                {
                    while (lector.Read())
                    {
                        cargos.Add(new Cargo
                        {
                            Codigo = lector.GetString(0).TrimEnd(),
                            Descripcion = lector.IsDBNull(1) ? null : lector.GetString(1),
                            Departamento = lector.GetString(2).TrimEnd(),
                            DepartamentoDescripcion = lector.IsDBNull(3) ? null : lector.GetString(3)
                        });
                    }
                }
            }
            return cargos.ToArray();
        }

        public Cargo Buscar(string departamento, string codigo) =>
            Listar(departamento).SingleOrDefault(c => c.Codigo == codigo);

        public Dictionary<string, string> Siguientes()
        {
            var siguientes = new Dictionary<string, string>();
            using (var conexion = CatalogoDepartamentos.Conectar())
            using (var comando = new SqlCommand(@"SELECT d.PEDEP_CODIGO,
                COALESCE(MAX(CASE WHEN RTRIM(c.PECAR_CODIGO) NOT LIKE '%[^0-9]%'
                    THEN TRY_CONVERT(int,c.PECAR_CODIGO) END),0)+1
                FROM dbo.PEDEP_DEPAR d LEFT JOIN dbo.PECAR_CARGO c ON c.PEDEP_CODIGO=d.PEDEP_CODIGO
                GROUP BY d.PEDEP_CODIGO", conexion))
            {
                conexion.Open();
                using (var lector = comando.ExecuteReader())
                    while (lector.Read())
                    {
                        int siguiente = lector.GetInt32(1);
                        siguientes.Add(lector.GetString(0).TrimEnd(), siguiente > 999 ? "" : siguiente.ToString("D3"));
                    }
            }
            return siguientes;
        }

        public string Crear(Cargo cargo)
        {
            using (var conexion = CatalogoDepartamentos.Conectar())
            {
                conexion.Open();
                using (var transaccion = conexion.BeginTransaction(IsolationLevel.Serializable))
                {
                    // Serializa la asignación de códigos dentro de cada departamento.
                    using (var departamento = new SqlCommand(@"SELECT PEDEP_CODIGO FROM dbo.PEDEP_DEPAR WITH (UPDLOCK,HOLDLOCK)
                        WHERE PEDEP_CODIGO=@departamento", conexion, transaccion))
                    {
                        departamento.Parameters.Add("@departamento", SqlDbType.Char, 3).Value = cargo.Departamento;
                        if (departamento.ExecuteScalar() == null) return null;
                    }
                    int siguiente;
                    using (var numero = new SqlCommand(@"SELECT COALESCE(MAX(TRY_CONVERT(int,PECAR_CODIGO)),0)+1
                        FROM dbo.PECAR_CARGO WITH (UPDLOCK,HOLDLOCK) WHERE PEDEP_CODIGO=@departamento
                        AND RTRIM(PECAR_CODIGO) NOT LIKE '%[^0-9]%'", conexion, transaccion))
                    {
                        numero.Parameters.Add("@departamento", SqlDbType.Char, 3).Value = cargo.Departamento;
                        siguiente = Convert.ToInt32(numero.ExecuteScalar());
                    }
                    if (siguiente > 999) return null;
                    string codigo = siguiente.ToString("D3");
                    using (var comando = new SqlCommand(@"INSERT INTO dbo.PECAR_CARGO
                        (PEDEP_CODIGO,PECAR_CODIGO,PECAR_DESCRI) VALUES (@departamento,@codigo,@descripcion)", conexion, transaccion))
                    {
                        Parametros(comando, cargo.Departamento, codigo, cargo.Descripcion);
                        comando.ExecuteNonQuery();
                    }
                    transaccion.Commit();
                    return codigo;
                }
            }
        }

        public bool Editar(Cargo cargo) => Ejecutar(@"UPDATE dbo.PECAR_CARGO SET PECAR_DESCRI=@descripcion
            WHERE PEDEP_CODIGO=@departamento AND PECAR_CODIGO=@codigo", cargo.Departamento, cargo.Codigo, cargo.Descripcion);

        public bool Eliminar(string departamento, string codigo) => Ejecutar(@"DELETE FROM dbo.PECAR_CARGO
            WHERE PEDEP_CODIGO=@departamento AND PECAR_CODIGO=@codigo", departamento, codigo, null);

        private static bool Ejecutar(string sql, string departamento, string codigo, string descripcion)
        {
            using (var conexion = CatalogoDepartamentos.Conectar())
            using (var comando = new SqlCommand(sql, conexion))
            {
                Parametros(comando, departamento, codigo, descripcion);
                conexion.Open();
                return comando.ExecuteNonQuery() == 1;
            }
        }

        private static void Parametros(SqlCommand comando, string departamento, string codigo, string descripcion)
        {
            comando.Parameters.Add("@departamento", SqlDbType.Char, 3).Value = departamento;
            comando.Parameters.Add("@codigo", SqlDbType.Char, 3).Value = codigo;
            comando.Parameters.Add("@descripcion", SqlDbType.VarChar, 50).Value = (object)descripcion ?? DBNull.Value;
        }
    }
}
