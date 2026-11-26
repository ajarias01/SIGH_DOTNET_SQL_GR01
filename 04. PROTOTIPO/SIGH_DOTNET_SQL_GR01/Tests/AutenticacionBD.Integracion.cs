using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Security.Cryptography;
using SighDotNet.Models;

internal static class PruebasAutenticacion
{
    private static int verificaciones;

    private static void Comprobar(bool condicion, string caso)
    {
        if (!condicion) throw new Exception("Falló: " + caso);
        verificaciones++;
        Console.WriteLine("OK: " + caso);
    }

    private static void Ejecutar(SqlConnection conexion, string sql, string nombre, string hash, string sal)
    {
        using (var comando = new SqlCommand(sql, conexion))
        {
            comando.Parameters.Add("@nombre", SqlDbType.VarChar, 64).Value = nombre;
            comando.Parameters.Add("@hash", SqlDbType.VarChar, 64).Value = hash;
            comando.Parameters.Add("@sal", SqlDbType.Char, 32).Value = sal;
            comando.ExecuteNonQuery();
        }
    }

    private static int Main()
    {
        try
        {
            var autenticacion = new AutenticacionBD();
            var demo = autenticacion.Autenticar("sullivan", "Sulley2026!");
            Comprobar(demo != null && demo.Nombre == "sullivan" && demo.CodigoPersona == "PER-DEMO01",
                "la cuenta importada de Java inicia sesión");
            Comprobar(autenticacion.Autenticar("  SULLIVAN  ", "Sulley2026!") != null,
                "se recortan espacios y se respeta el login sin distinción de mayúsculas");
            Comprobar(autenticacion.Autenticar("sullivan", "incorrecta") == null, "contraseña incorrecta");
            Comprobar(autenticacion.Autenticar("no_existe_" + Guid.NewGuid().ToString("N"), "prueba") == null,
                "usuario inexistente");
            Comprobar(autenticacion.Autenticar("' OR 1=1 --", "prueba") == null, "consulta parametrizada");
            Comprobar(autenticacion.Autenticar(null, "prueba") == null
                && autenticacion.Autenticar("sullivan", null) == null
                && autenticacion.Autenticar(new string('x', 65), "prueba") == null
                && autenticacion.Autenticar("sullivan", new string('x', 129)) == null, "límites de entrada");

            string nombre = "prueba_" + Guid.NewGuid().ToString("N");
            const string clave = "Contraseña-漢-🔐";
            var salBytes = new byte[16];
            using (var azar = RandomNumberGenerator.Create()) azar.GetBytes(salBytes);
            string sal = BitConverter.ToString(salBytes).Replace("-", "");
            string hash;
            using (var pbkdf2 = new Rfc2898DeriveBytes(clave, salBytes, 210000, HashAlgorithmName.SHA256))
                hash = BitConverter.ToString(pbkdf2.GetBytes(32)).Replace("-", "");

            using (var conexion = new SqlConnection(ConfigurationManager.ConnectionStrings["SighBD"].ConnectionString))
            {
                conexion.Open();
                try
                {
                    Ejecutar(conexion, @"INSERT INTO dbo.XEUSU_USUAR
                        (XEUSU_PASWD, XEUSU_LOGIN, XEUSU_SALT, XEEST_CODIGO, PEPER_CODIGO,
                         XEUSU_FECCRE, XEUSU_FECMOD, XEUSU_PIEFIR)
                        VALUES (@hash, @nombre, @sal, 'A', 'PER-DEMO01', GETDATE(), GETDATE(), 'Prueba temporal')",
                        nombre, hash, sal);
                    Comprobar(autenticacion.Autenticar(nombre, clave) != null, "contraseña Unicode y hexadecimal en mayúsculas");
                    Ejecutar(conexion, "UPDATE dbo.XEUSU_USUAR SET XEEST_CODIGO = 'I' WHERE XEUSU_LOGIN = @nombre", nombre, hash, sal);
                    Comprobar(autenticacion.Autenticar(nombre, clave) == null, "usuario inactivo rechazado");
                    Ejecutar(conexion, "UPDATE dbo.XEUSU_USUAR SET XEEST_CODIGO = 'B' WHERE XEUSU_LOGIN = @nombre", nombre, hash, sal);
                    Comprobar(autenticacion.Autenticar(nombre, clave) == null, "usuario bloqueado rechazado");
                    Ejecutar(conexion, "UPDATE dbo.XEUSU_USUAR SET XEEST_CODIGO = 'A', XEUSU_SALT = @sal WHERE XEUSU_LOGIN = @nombre",
                        nombre, hash, new string('z', 32));
                    Comprobar(autenticacion.Autenticar(nombre, clave) == null, "sal malformada rechazada");
                    Ejecutar(conexion, "UPDATE dbo.XEUSU_USUAR SET XEUSU_SALT = @sal, XEUSU_PASWD = @hash WHERE XEUSU_LOGIN = @nombre",
                        nombre, new string('z', 64), sal);
                    Comprobar(autenticacion.Autenticar(nombre, clave) == null, "hash malformado rechazado");
                }
                finally
                {
                    Ejecutar(conexion, "DELETE FROM dbo.XEUSU_USUAR WHERE XEUSU_LOGIN = @nombre", nombre, hash, sal);
                }
            }

            Console.WriteLine("Correcto: " + verificaciones + " verificaciones. Se eliminó la cuenta temporal.");
            return 0;
        }
        catch (Exception ex)
        {
            Console.Error.WriteLine(ex);
            return 1;
        }
    }
}
