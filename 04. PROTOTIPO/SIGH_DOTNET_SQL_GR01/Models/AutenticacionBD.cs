using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Security.Cryptography;

namespace SighDotNet.Models
{
    public sealed class AutenticacionBD
    {
        private const string Sql = @"
            SELECT XEUSU_LOGIN, XEUSU_PASWD, XEUSU_SALT, XEEST_CODIGO, PEPER_CODIGO
            FROM dbo.XEUSU_USUAR WHERE XEUSU_LOGIN = @nombre";

        public Usuario Autenticar(string nombre, string clave)
        {
            if (string.IsNullOrWhiteSpace(nombre) || nombre.Length > 64
                || string.IsNullOrEmpty(clave) || clave.Length > 128)
            {
                return null;
            }

            var configuracion = ConfigurationManager.ConnectionStrings["SighBD"];
            if (configuracion == null || string.IsNullOrWhiteSpace(configuracion.ConnectionString))
            {
                throw new ConfigurationErrorsException("Falta la conexión SighBD en Web.config.");
            }

            using (var conexion = new SqlConnection(configuracion.ConnectionString))
            using (var comando = new SqlCommand(Sql, conexion))
            {
                comando.Parameters.Add("@nombre", SqlDbType.VarChar, 64).Value = nombre.Trim();
                conexion.Open();

                using (var lector = comando.ExecuteReader(CommandBehavior.SingleRow))
                {
                    if (!lector.Read())
                    {
                        return null;
                    }

                    // Java guarda 16 bytes de sal y 32 bytes de hash en hexadecimal.
                    var sal = LeerHexadecimal(lector["XEUSU_SALT"] as string, 16);
                    var hash = LeerHexadecimal(lector["XEUSU_PASWD"] as string, 32);
                    if (sal == null || hash == null)
                    {
                        return null;
                    }

                    byte[] derivada;
                    using (var pbkdf2 = new Rfc2898DeriveBytes(clave, sal, 210000, HashAlgorithmName.SHA256))
                    {
                        derivada = pbkdf2.GetBytes(hash.Length);
                    }

                    int diferencia = 0;
                    for (int i = 0; i < hash.Length; i++)
                    {
                        diferencia |= hash[i] ^ derivada[i];
                    }

                    var estado = Convert.ToString(lector["XEEST_CODIGO"]);
                    var usuario = new Usuario(Convert.ToString(lector["XEUSU_LOGIN"]),
                        estado.Length == 1 ? estado[0] : '\0', Convert.ToString(lector["PEPER_CODIGO"]));
                    return diferencia == 0 && usuario.Activo ? usuario : null;
                }
            }
        }

        private static byte[] LeerHexadecimal(string valor, int longitud)
        {
            if (valor == null || valor.Length != longitud * 2)
            {
                return null;
            }

            var bytes = new byte[longitud];
            for (int i = 0; i < bytes.Length; i++)
            {
                int alto = DigitoHexadecimal(valor[i * 2]);
                int bajo = DigitoHexadecimal(valor[i * 2 + 1]);
                if (alto < 0 || bajo < 0)
                {
                    return null;
                }
                bytes[i] = (byte)((alto << 4) | bajo);
            }
            return bytes;
        }

        private static int DigitoHexadecimal(char valor)
        {
            if (valor >= '0' && valor <= '9') return valor - '0';
            if (valor >= 'a' && valor <= 'f') return valor - 'a' + 10;
            if (valor >= 'A' && valor <= 'F') return valor - 'A' + 10;
            return -1;
        }
    }
}
