namespace SighDotNet.Models
{
    public sealed class DepartamentosVista
    {
        public Departamento[] Departamentos { get; set; }
        public Departamento Departamento { get; set; }
        public string Modo { get; set; }
        public string Error { get; set; }
    }
}
