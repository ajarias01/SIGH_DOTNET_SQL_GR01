using System.Web.Mvc;

namespace SighDotNet.Models
{
    public sealed class PersonaVista
    {
        public Persona Datos { get; set; }
        public Persona[] Personas { get; set; }
        public SelectListItem[] Generos { get; set; }
        public SelectListItem[] EstadosCiviles { get; set; }
        public string Tab { get; set; }
        public string Aviso { get; set; }
        public bool Bloqueado { get; set; }
    }
}
