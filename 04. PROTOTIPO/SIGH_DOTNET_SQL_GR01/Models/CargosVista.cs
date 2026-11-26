using System.Collections.Generic;

namespace SighDotNet.Models
{
    public sealed class CargosVista
    {
        public Departamento[] Departamentos { get; set; }
        public Cargo[] Cargos { get; set; }
        public Cargo Cargo { get; set; }
        public string Modo { get; set; }
        public Dictionary<string, string> Siguientes { get; set; }
        public string Filtro { get; set; }
        public string Error { get; set; }
    }
}
