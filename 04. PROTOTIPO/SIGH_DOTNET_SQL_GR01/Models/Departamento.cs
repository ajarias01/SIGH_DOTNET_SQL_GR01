namespace SighDotNet.Models
{
    // PEDEP_DEPAR: PEDEP_CODIGO y PEDEP_DESCRIP.
    public sealed class Departamento
    {
        public Departamento(string codigo, string descripcion)
        {
            Codigo = codigo;
            Descripcion = descripcion;
        }

        public string Codigo { get; }
        public string Descripcion { get; }

        public static string NormalizarCodigo(string codigo) => (codigo ?? "").Trim().ToUpperInvariant();
    }
}
