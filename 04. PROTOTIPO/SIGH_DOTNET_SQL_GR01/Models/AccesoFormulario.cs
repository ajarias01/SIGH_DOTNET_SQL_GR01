using System.ComponentModel.DataAnnotations;

namespace SighDotNet.Models
{
    public sealed class AccesoFormulario
    {
        [Required]
        [StringLength(64)]
        public string Nombre { get; set; } = "";

        [Required]
        [StringLength(128)]
        public string Clave { get; set; } = "";
    }
}
