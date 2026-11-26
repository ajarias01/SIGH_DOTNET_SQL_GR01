using System;
using System.ComponentModel.DataAnnotations;

namespace SighDotNet.Models
{
    public sealed class Persona
    {
        [StringLength(10)] public string Codigo { get; set; }
        [Required(ErrorMessage = "Este campo es obligatorio."), StringLength(50, ErrorMessage = "Admite hasta 50 caracteres.")] public string Apellidos { get; set; }
        [Required(ErrorMessage = "Este campo es obligatorio."), StringLength(50, ErrorMessage = "Admite hasta 50 caracteres.")] public string Nombres { get; set; }
        [Required(ErrorMessage = "Este campo es obligatorio."), StringLength(1)] public string Genero { get; set; }
        [Required(ErrorMessage = "Este campo es obligatorio."), StringLength(1)] public string EstadoCivil { get; set; }
        [Required(ErrorMessage = "Este campo es obligatorio."), DataType(DataType.Date)] public DateTime? FechaNacimiento { get; set; }
        [Range(0, 99, ErrorMessage = "Las cargas familiares deben estar entre 0 y 99.")] public int CargasFamiliares { get; set; }
        public bool Discapacidad { get; set; }
        [Required(ErrorMessage = "Este campo es obligatorio."), RegularExpression("CEDULA|PASAPORTE")] public string TipoDocumento { get; set; } = "CEDULA";
        [Required(ErrorMessage = "Este campo es obligatorio."), StringLength(15)] public string Documento { get; set; }
        [StringLength(50, ErrorMessage = "Admite hasta 50 caracteres."), EmailAddress(ErrorMessage = "Ingresa un correo electrónico válido.")] public string Email { get; set; }
        public string Foto { get; set; }
    }
}
