using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web.Mvc;

namespace SighDotNet.Models
{
    public sealed class CatalogoPersonas
    {
        private const string Seleccionar = @"SELECT PEPER_CODIGO, PEPER_APELLI, PEPER_NOMBRE,
            PEGEN_CODIGO, PEESC_CODIGO, PEPER_FECNAC, PEPER_CARFAM, PEPER_DISCAPACIDAD,
            PEPER_CEDULA, PEPER_PASAPO, PEPER_EMAIL, PEPER_FOTO FROM dbo.PEPER_PERSO";

        public Persona[] Listar() => Consultar(Seleccionar + " ORDER BY PEPER_CODIGO", null);
        public Persona Buscar(string codigo) => Consultar(Seleccionar + " WHERE PEPER_CODIGO=@codigo", codigo).SingleOrDefault();

        public Persona Navegar(string nav, string codigo)
        {
            string condicion;
            switch (nav)
            {
                case "primero": condicion = " ORDER BY PEPER_CODIGO"; break;
                case "ultimo": condicion = " ORDER BY PEPER_CODIGO DESC"; break;
                case "anterior": condicion = " WHERE PEPER_CODIGO < @codigo ORDER BY PEPER_CODIGO DESC"; break;
                case "siguiente": condicion = " WHERE PEPER_CODIGO > @codigo ORDER BY PEPER_CODIGO"; break;
                default: return Buscar(codigo);
            }
            return Consultar(Seleccionar.Replace("SELECT ", "SELECT TOP (1) ") + condicion, codigo).FirstOrDefault() ?? Buscar(codigo);
        }

        public SelectListItem[] Generos() => Opciones("SELECT PEGEN_CODIGO, PEGEN_DESCRI FROM dbo.PEGEN_GENERO ORDER BY PEGEN_CODIGO");
        public SelectListItem[] EstadosCiviles() => Opciones("SELECT PEESC_CODIGO, PEESC_DESCRI FROM dbo.PEESC_CIVIL ORDER BY PEESC_CODIGO");

        private static SelectListItem[] Opciones(string sql)
        {
            var opciones = new List<SelectListItem>();
            using (var conexion = CatalogoDepartamentos.Conectar())
            using (var comando = new SqlCommand(sql, conexion))
            {
                conexion.Open();
                using (var lector = comando.ExecuteReader())
                    while (lector.Read()) opciones.Add(new SelectListItem { Value = lector.GetString(0).TrimEnd(), Text = Convert.ToString(lector[1]) });
            }
            return opciones.ToArray();
        }

        private static Persona[] Consultar(string sql, string codigo)
        {
            var lista = new List<Persona>();
            using (var conexion = CatalogoDepartamentos.Conectar())
            using (var comando = new SqlCommand(sql, conexion))
            {
                comando.Parameters.Add("@codigo", SqlDbType.Char, 10).Value = codigo ?? "";
                conexion.Open();
                using (var lector = comando.ExecuteReader())
                    while (lector.Read())
                        lista.Add(new Persona
                        {
                            Codigo = lector.GetString(0).TrimEnd(), Apellidos = lector.GetString(1), Nombres = lector.GetString(2),
                            Genero = lector.GetString(3).TrimEnd(), EstadoCivil = lector.GetString(4).TrimEnd(),
                            FechaNacimiento = lector.GetDateTime(5), CargasFamiliares = Convert.ToInt32(lector[6]),
                            Discapacidad = Convert.ToString(lector[7]) == "S",
                            TipoDocumento = string.IsNullOrEmpty(Convert.ToString(lector[8])) && !string.IsNullOrEmpty(Convert.ToString(lector[9])) ? "PASAPORTE" : "CEDULA",
                            Documento = string.IsNullOrEmpty(Convert.ToString(lector[8])) ? Convert.ToString(lector[9]) : Convert.ToString(lector[8]),
                            Email = Convert.ToString(lector[10]), Foto = Convert.ToString(lector[11])
                        });
            }
            return lista.ToArray();
        }

        public string Guardar(Persona persona, string foto)
        {
            bool nuevo = string.IsNullOrEmpty(persona.Codigo);
            using (var conexion = CatalogoDepartamentos.Conectar())
            {
                conexion.Open();
                using (var transaccion = conexion.BeginTransaction(IsolationLevel.Serializable))
                {
                    string codigo = persona.Codigo;
                    if (nuevo)
                    {
                        using (var siguiente = new SqlCommand(@"SELECT COALESCE(MAX(TRY_CONVERT(int, SUBSTRING(PEPER_CODIGO,5,6))),0)+1
                            FROM dbo.PEPER_PERSO WITH (UPDLOCK,HOLDLOCK)
                            WHERE PEPER_CODIGO LIKE 'PER-[0-9][0-9][0-9][0-9][0-9][0-9]'", conexion, transaccion))
                        {
                            int numero = Convert.ToInt32(siguiente.ExecuteScalar());
                            if (numero > 999999) throw new InvalidOperationException("Se agotaron los códigos de personas.");
                            codigo = "PER-" + numero.ToString("D6");
                        }
                    }
                    string sql = nuevo ? @"INSERT INTO dbo.PEPER_PERSO
                        (PEPER_CODIGO,PEPER_APELLI,PEPER_NOMBRE,PEGEN_CODIGO,PEESC_CODIGO,PEPER_FECNAC,PEPER_CARFAM,
                         PEPER_DISCAPACIDAD,PEPER_CEDULA,PEPER_PASAPO,PEPER_EMAIL,PEPER_FOTO)
                        VALUES (@codigo,@apellidos,@nombres,@genero,@civil,@fecha,@cargas,@discapacidad,@cedula,@pasaporte,@email,COALESCE(@foto,'default.png'))"
                        : @"UPDATE dbo.PEPER_PERSO SET PEPER_APELLI=@apellidos, PEPER_NOMBRE=@nombres, PEGEN_CODIGO=@genero,
                        PEESC_CODIGO=@civil, PEPER_FECNAC=@fecha, PEPER_CARFAM=@cargas, PEPER_DISCAPACIDAD=@discapacidad,
                        PEPER_CEDULA=@cedula, PEPER_PASAPO=@pasaporte, PEPER_EMAIL=@email, PEPER_FOTO=COALESCE(@foto,PEPER_FOTO)
                        WHERE PEPER_CODIGO=@codigo";
                    using (var comando = new SqlCommand(sql, conexion, transaccion))
                    {
                        Texto(comando, "@codigo", codigo, 10); Texto(comando, "@apellidos", persona.Apellidos.Trim(), 50);
                        Texto(comando, "@nombres", persona.Nombres.Trim(), 50); Texto(comando, "@genero", persona.Genero, 1);
                        Texto(comando, "@civil", persona.EstadoCivil, 1); Texto(comando, "@discapacidad", persona.Discapacidad ? "S" : "N", 1);
                        Texto(comando, "@cedula", persona.TipoDocumento == "CEDULA" ? persona.Documento.Trim() : null, 10);
                        Texto(comando, "@pasaporte", persona.TipoDocumento == "PASAPORTE" ? persona.Documento.Trim() : null, 15);
                        Texto(comando, "@email", persona.Email, 50); Texto(comando, "@foto", foto, 100);
                        comando.Parameters.Add("@fecha", SqlDbType.Date).Value = persona.FechaNacimiento.Value.Date;
                        comando.Parameters.Add("@cargas", SqlDbType.Int).Value = persona.CargasFamiliares;
                        if (comando.ExecuteNonQuery() == 0) return null;
                    }
                    transaccion.Commit();
                    return codigo;
                }
            }
        }

        public bool Eliminar(string codigo)
        {
            using (var conexion = CatalogoDepartamentos.Conectar())
            using (var comando = new SqlCommand("DELETE FROM dbo.PEPER_PERSO WHERE PEPER_CODIGO=@codigo", conexion))
            {
                Texto(comando, "@codigo", codigo, 10);
                conexion.Open();
                return comando.ExecuteNonQuery() == 1;
            }
        }

        private static void Texto(SqlCommand comando, string nombre, string valor, int longitud) =>
            comando.Parameters.Add(nombre, SqlDbType.VarChar, longitud).Value = string.IsNullOrWhiteSpace(valor) ? (object)DBNull.Value : valor.Trim();
    }
}
