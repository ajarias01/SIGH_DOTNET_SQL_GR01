-- Ejecutar en SSMS conectado al motor SQL Server con permiso para crear bases.
-- Adaptación del módulo de acceso de sigh_gr001.sql (MariaDB).
-- Crea solo las cinco tablas necesarias para el login, sin borrar datos.
USE [master];
GO
IF DB_ID(N'sigh_gr01') IS NULL
    EXEC(N'CREATE DATABASE [sigh_gr01]');
GO
USE [sigh_gr01];
GO
SET QUOTED_IDENTIFIER ON;
SET ANSI_NULLS ON;
SET ANSI_PADDING ON;
SET ANSI_WARNINGS ON;
SET ARITHABORT ON;
SET CONCAT_NULL_YIELDS_NULL ON;
SET NUMERIC_ROUNDABORT OFF;
SET XACT_ABORT ON;
BEGIN TRY
    BEGIN TRANSACTION;

    IF OBJECT_ID(N'dbo.XEEST_ESTAD', N'U') IS NULL
        CREATE TABLE dbo.XEEST_ESTAD (
            XEEST_CODIGO char(1) NOT NULL CONSTRAINT PK_XEEST_ESTAD PRIMARY KEY,
            XEEST_DESCRI varchar(50) NOT NULL
        );

    IF OBJECT_ID(N'dbo.PEGEN_GENERO', N'U') IS NULL
        CREATE TABLE dbo.PEGEN_GENERO (
            PEGEN_CODIGO char(1) NOT NULL CONSTRAINT PK_PEGEN_GENERO PRIMARY KEY,
            PEGEN_DESCRI varchar(50) NULL
        );

    IF OBJECT_ID(N'dbo.PEESC_CIVIL', N'U') IS NULL
        CREATE TABLE dbo.PEESC_CIVIL (
            PEESC_CODIGO char(1) NOT NULL CONSTRAINT PK_PEESC_CIVIL PRIMARY KEY,
            PEESC_DESCRI varchar(50) NULL
        );

    IF OBJECT_ID(N'dbo.PEPER_PERSO', N'U') IS NULL
        CREATE TABLE dbo.PEPER_PERSO (
            PEPER_CODIGO char(10) NOT NULL CONSTRAINT PK_PEPER_PERSO PRIMARY KEY,
            PEGEN_CODIGO char(1) NOT NULL,
            PEESC_CODIGO char(1) NOT NULL,
            PEPER_APELLI varchar(50) NOT NULL,
            PEPER_NOMBRE varchar(50) NOT NULL,
            PEPER_FECNAC date NOT NULL,
            PEPER_CEDULA varchar(10) NULL,
            PEPER_PASAPO varchar(15) NULL,
            PEPER_EMAIL varchar(50) NULL,
            PEPER_CARFAM numeric(2,0) NOT NULL DEFAULT 0,
            PEPER_FOTO varchar(100) NOT NULL DEFAULT 'default.png',
            PEPER_DISCAPACIDAD char(1) NOT NULL DEFAULT 'N',
            CONSTRAINT FK_PR_PEGEN_PEPER FOREIGN KEY (PEGEN_CODIGO)
                REFERENCES dbo.PEGEN_GENERO (PEGEN_CODIGO),
            CONSTRAINT FK_PR_PEESC_PEPER FOREIGN KEY (PEESC_CODIGO)
                REFERENCES dbo.PEESC_CIVIL (PEESC_CODIGO)
        );

    IF OBJECT_ID(N'dbo.XEUSU_USUAR', N'U') IS NULL
        CREATE TABLE dbo.XEUSU_USUAR (
            XEUSU_PASWD varchar(64) NOT NULL CONSTRAINT PK_XEUSU_USUAR PRIMARY KEY,
            XEUSU_LOGIN varchar(64) COLLATE Latin1_General_100_CI_AS NOT NULL,
            XEUSU_SALT char(32) NOT NULL,
            XEEST_CODIGO char(1) NOT NULL,
            PEPER_CODIGO char(10) NOT NULL,
            XEUSU_FECCRE datetime NOT NULL,
            XEUSU_FECMOD datetime NOT NULL,
            XEUSU_PIEFIR varchar(100) NOT NULL,
            CONSTRAINT FK_XR_XEEST_XEUSU FOREIGN KEY (XEEST_CODIGO)
                REFERENCES dbo.XEEST_ESTAD (XEEST_CODIGO),
            CONSTRAINT FK_XR_PEPER_XEUSU FOREIGN KEY (PEPER_CODIGO)
                REFERENCES dbo.PEPER_PERSO (PEPER_CODIGO)
        );

    -- Compatibilidad con el DDL antiguo del repositorio: conserva sus cuentas.
    -- Estas necesitan asignación de login y restablecimiento PBKDF2 para acceder.
    IF COL_LENGTH(N'dbo.XEUSU_USUAR', N'XEUSU_LOGIN') IS NULL
        EXEC(N'ALTER TABLE dbo.XEUSU_USUAR ADD XEUSU_LOGIN varchar(64)
            COLLATE Latin1_General_100_CI_AS NULL;');
    IF COL_LENGTH(N'dbo.XEUSU_USUAR', N'XEUSU_SALT') IS NULL
        EXEC(N'ALTER TABLE dbo.XEUSU_USUAR ADD XEUSU_SALT char(32) NULL;');

    IF NOT EXISTS (SELECT 1 FROM sys.indexes
        WHERE object_id = OBJECT_ID(N'dbo.XEUSU_USUAR') AND name = N'UX_XEUSU_LOGIN')
        EXEC(N'CREATE UNIQUE INDEX UX_XEUSU_LOGIN ON dbo.XEUSU_USUAR (XEUSU_LOGIN)
            WHERE XEUSU_LOGIN IS NOT NULL;');

    INSERT INTO dbo.XEEST_ESTAD (XEEST_CODIGO, XEEST_DESCRI)
        SELECT codigo, descripcion FROM (VALUES
            ('A', 'Activo'), ('B', 'Bloqueado'), ('I', 'Inactivo')
        ) AS estados(codigo, descripcion)
        WHERE NOT EXISTS (SELECT 1 FROM dbo.XEEST_ESTAD WHERE XEEST_CODIGO = codigo);

    IF NOT EXISTS (SELECT 1 FROM dbo.PEGEN_GENERO WHERE PEGEN_CODIGO = 'M')
        INSERT INTO dbo.PEGEN_GENERO (PEGEN_CODIGO, PEGEN_DESCRI) VALUES ('M', 'Masculino');
    IF NOT EXISTS (SELECT 1 FROM dbo.PEESC_CIVIL WHERE PEESC_CODIGO = 'S')
        INSERT INTO dbo.PEESC_CIVIL (PEESC_CODIGO, PEESC_DESCRI) VALUES ('S', 'Soltero');
    IF NOT EXISTS (SELECT 1 FROM dbo.PEPER_PERSO WHERE PEPER_CODIGO = 'PER-DEMO01')
        INSERT INTO dbo.PEPER_PERSO
            (PEPER_CODIGO, PEGEN_CODIGO, PEESC_CODIGO, PEPER_APELLI, PEPER_NOMBRE, PEPER_FECNAC)
        VALUES ('PER-DEMO01', 'M', 'S', 'Sullivan', 'James', '20000101');

    -- SQL dinámico permite usar las columnas recién agregadas al DDL antiguo.
    -- Conserva las cuentas existentes, incluso si se desactiva la de prueba.
    EXEC(N'
        IF NOT EXISTS (SELECT 1 FROM dbo.XEUSU_USUAR WHERE XEUSU_LOGIN = ''sullivan'')
        BEGIN
            IF EXISTS (SELECT 1 FROM dbo.XEUSU_USUAR
                WHERE XEUSU_PASWD = ''628132eae65b02df0004f3c6c557a3bee55d61f568e5ab1b453dc2b51d2580a2'')
                THROW 50001, ''El hash de prueba ya pertenece a otra cuenta; no se modificó.'', 1;

            INSERT INTO dbo.XEUSU_USUAR
                (XEUSU_PASWD, XEUSU_LOGIN, XEUSU_SALT, XEEST_CODIGO,
                 PEPER_CODIGO, XEUSU_FECCRE, XEUSU_FECMOD, XEUSU_PIEFIR)
            VALUES
                (''628132eae65b02df0004f3c6c557a3bee55d61f568e5ab1b453dc2b51d2580a2'',
                 ''sullivan'', ''6ed25772c7ee425ca620e646abdf944a'', ''A'',
                 ''PER-DEMO01'', ''2026-11-04T17:39:07'', ''2026-11-04T17:39:07'', ''Usuario de prueba'');
        END;
    ');

    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
    THROW;
END CATCH;
GO
