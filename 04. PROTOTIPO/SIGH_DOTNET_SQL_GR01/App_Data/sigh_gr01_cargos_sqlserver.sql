-- Ejecutar después del script de departamentos en la instancia de Web.config.
USE [sigh_gr01];
GO
SET XACT_ABORT ON;
BEGIN TRANSACTION;
IF OBJECT_ID(N'dbo.PECAR_CARGO', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.PECAR_CARGO (
        PEDEP_CODIGO char(3) NOT NULL,
        PECAR_CODIGO char(3) NOT NULL,
        PECAR_DESCRI varchar(50) NULL,
        CONSTRAINT PK_PECAR_CARGO PRIMARY KEY (PEDEP_CODIGO, PECAR_CODIGO),
        CONSTRAINT FK_PR_PEDEP_PECAR FOREIGN KEY (PEDEP_CODIGO)
            REFERENCES dbo.PEDEP_DEPAR (PEDEP_CODIGO)
    );
    INSERT INTO dbo.PECAR_CARGO (PEDEP_CODIGO, PECAR_CODIGO, PECAR_DESCRI)
    SELECT v.departamento, v.codigo, v.descripcion
    FROM (VALUES
('DIR', '001', N'Director General'),
('DIR', '002', N'Director Médico'),
('ADM', '001', N'Jefe de Admisión'),
('ADM', '002', N'Recepcionista Asistencial'),
('MED', '001', N'Médico General'),
('MED', '002', N'Médico Especialista'),
('MED', '003', N'Cirujano Principal'),
('ENF', '001', N'Enfermero/a Jefe'),
('ENF', '002', N'Enfermero/a de Triaje'),
('LAB', '001', N'Bioquímico / Responsable Técnico'),
('LAB', '002', N'Tecnólogo de Laboratorio'),
('FAR', '001', N'Químico Farmacéutico'),
('FAR', '002', N'Auxiliar de Farmacia'),
('FIN', '001', N'Jefe de Facturación'),
('FIN', '002', N'Cajero / Recaudador'),
('SIS', '001', N'Administrador de Base de Datos y Sistemas')
    ) v(departamento, codigo, descripcion)
    INNER JOIN dbo.PEDEP_DEPAR d ON d.PEDEP_CODIGO = v.departamento;
END;
COMMIT TRANSACTION;
GO
