namespace SighDotNet.Models
{
    // Proyección de XEUSU_USUAR: XEUSU_PASWD, XEEST_CODIGO y PEPER_CODIGO.
    public sealed class Usuario
    {
        public Usuario(string nombre, char estado, string codigoPersona)
        {
            Nombre = nombre;
            Estado = estado;
            CodigoPersona = codigoPersona;
        }

        public string Nombre { get; }
        public char Estado { get; }
        public string CodigoPersona { get; }
        public bool Activo => Estado == 'A';
    }
}
