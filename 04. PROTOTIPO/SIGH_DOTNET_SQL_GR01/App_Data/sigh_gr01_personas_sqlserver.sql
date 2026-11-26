-- Ejecutar después del script de login. Conserva los catálogos y las personas existentes.
USE [sigh_gr01];
GO
SET XACT_ABORT ON;
BEGIN TRANSACTION;
INSERT INTO dbo.PEGEN_GENERO (PEGEN_CODIGO, PEGEN_DESCRI)
SELECT codigo, descripcion FROM (VALUES ('M','Masculino'),('F','Femenino'),('O','Otro / No especificado')) v(codigo,descripcion)
WHERE NOT EXISTS (SELECT 1 FROM dbo.PEGEN_GENERO d WHERE d.PEGEN_CODIGO=v.codigo);
INSERT INTO dbo.PEESC_CIVIL (PEESC_CODIGO, PEESC_DESCRI)
SELECT codigo, descripcion FROM (VALUES ('S','Soltero/a'),('C','Casado/a'),('D','Divorciado/a'),('V','Viudo/a'),('U',N'Unión de Hecho')) v(codigo,descripcion)
WHERE NOT EXISTS (SELECT 1 FROM dbo.PEESC_CIVIL d WHERE d.PEESC_CODIGO=v.codigo);
COMMIT TRANSACTION;
GO
