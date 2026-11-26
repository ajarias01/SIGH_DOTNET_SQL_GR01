-- Ejecutar completo desde SSMS en la instancia configurada en Web.config.
USE [master];
GO
IF DB_ID(N'sigh_gr01') IS NULL
    EXEC(N'CREATE DATABASE [sigh_gr01]');
GO
USE [sigh_gr01];
GO
SET XACT_ABORT ON;
BEGIN TRANSACTION;

IF OBJECT_ID(N'dbo.PEDEP_DEPAR', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.PEDEP_DEPAR (
        PEDEP_CODIGO char(3) NOT NULL,
        PEDEP_DESCRIP varchar(50) NULL,
        CONSTRAINT PK_PEDEP_DEPAR PRIMARY KEY (PEDEP_CODIGO)
    );

    INSERT INTO dbo.PEDEP_DEPAR (PEDEP_CODIGO, PEDEP_DESCRIP) VALUES
        ('DIR', N'Dirección General y Médica'),
        ('ADM', N'Admisión y Gestión de Pacientes'),
        ('MED', N'Servicio Médico y Consulta Externa'),
        ('ENF', N'Servicio de Enfermería'),
        ('LAB', N'Laboratorio Clínico y Patología'),
        ('FAR', N'Farmacia Hospitalaria y Almacén'),
        ('FIN', N'Finanzas, Caja y Facturación'),
        ('SIS', N'Tecnologías de la Información');
END;

COMMIT TRANSACTION;
GO
