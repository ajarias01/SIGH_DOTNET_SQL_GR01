-- =============================================================================
-- DDL - Data Definition Language
-- Sistema: Sistema Integral de Gestión Hospitalaria (SIGH)
-- Base de datos: gestion_hospitalaria_sigh
-- Motor: MySQL 8 / InnoDB (compatible con MariaDB 10.6 o superior)
-- Grupo 1 - Desarrollo Web Avanzado
-- =============================================================================

CREATE DATABASE IF NOT EXISTS gestion_hospitalaria_sigh
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE gestion_hospitalaria_sigh;
SET NAMES utf8mb4;

-- =============================================================================
-- ELIMINACIÓN DE TABLAS EXISTENTES (ORDEN INVERSO A DEPENDENCIAS FK)
-- =============================================================================
SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS FCAJU_AJUS;
DROP TABLE IF EXISTS FCDOC_DFAC;
DROP TABLE IF EXISTS FCPAG_PAGO;
DROP TABLE IF EXISTS CARGO_FACTURABLE;
DROP TABLE IF EXISTS FCCUE_CUENT;
DROP TABLE IF EXISTS TARIFA_SERVICIO;
DROP TABLE IF EXISTS QUPRO_PRQUI;
DROP TABLE IF EXISTS ASIGNACION_CAMA;
DROP TABLE IF EXISTS HOTRA_TRASL;
DROP TABLE IF EXISTS HOSPITALIZACION;
DROP TABLE IF EXISTS CAMA;
DROP TABLE IF EXISTS HABITACION;
DROP TABLE IF EXISTS UNIDAD_HOSPITALARIA;
DROP TABLE IF EXISTS FADIS_DISPE;
DROP TABLE IF EXISTS FAMOV_MOVIN;
DROP TABLE IF EXISTS FALOT_LOTE;
DROP TABLE IF EXISTS CLPRE_PRESC;
DROP TABLE IF EXISTS FAMED_MEDIC;
DROP TABLE IF EXISTS IMORD_ORDIM;
DROP TABLE IF EXISTS LARES_RESLA;
DROP TABLE IF EXISTS LAORD_ORDEN;
DROP TABLE IF EXISTS CLDOC_DOCLI;
DROP TABLE IF EXISTS CLALR_ALERG;
DROP TABLE IF EXISTS CLDIA_DIAGN;
DROP TABLE IF EXISTS CLATE_ATENC;
DROP TABLE IF EXISTS CITA;
DROP TABLE IF EXISTS AGENDA;
DROP TABLE IF EXISTS CONSULTORIO;
DROP TABLE IF EXISTS PAPAC_PACIE;
DROP TABLE IF EXISTS PEPRO_PROFE;
DROP TABLE IF EXISTS PEESP_ESPEC;
DROP TABLE IF EXISTS SEAUD_EVEN;
DROP TABLE IF EXISTS XEUXP_USUPE;
DROP TABLE IF EXISTS XEUSU_USUAR;
DROP TABLE IF EXISTS PEPER_PERSO;
DROP TABLE IF EXISTS PECAR_CARGO;
DROP TABLE IF EXISTS PEESC_CIVIL;
DROP TABLE IF EXISTS PEGEN_GENERO;
DROP TABLE IF EXISTS PEDEP_DEPAR;
DROP TABLE IF EXISTS XEOXP_OPCPE;
DROP TABLE IF EXISTS XEOPC_OPCIO;
DROP TABLE IF EXISTS XEPER_PERFI;
DROP TABLE IF EXISTS XESIS_SISTE;
DROP TABLE IF EXISTS XEEST_ESTAD;

SET FOREIGN_KEY_CHECKS = 1;

-- =============================================================================
-- 1. SUBSISTEMA SEGURIDAD Y AUDITORÍA (SUSE)
-- =============================================================================

-- Estados generales del sistema (A: Activo, I: Inactivo, B: Bloqueado, etc.)
CREATE TABLE XEEST_ESTAD (
    XEEST_CODIGO       CHAR(1)         NOT NULL COMMENT 'Código del estado de la entidad',
    XEEST_DESCRI       VARCHAR(50)     NOT NULL COMMENT 'Descripción del estado',
    PRIMARY KEY (XEEST_CODIGO)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Entidad utilizada para gestionar el estado de las diferentes tablas';

-- Sistemas y módulos de la aplicación
CREATE TABLE XESIS_SISTE (
    XESIS_CODIGO       CHAR(1)         NOT NULL COMMENT 'Código identificador del subsistema',
    XESIS_DESCRI       VARCHAR(50)     NOT NULL COMMENT 'Descripción del subsistema',
    PRIMARY KEY (XESIS_CODIGO)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Entidad utilizada para realizar la gestión de los diferentes subsistemas';

-- Perfiles o roles de seguridad
CREATE TABLE XEPER_PERFI (
    XEPER_CODIGO       CHAR(8)         NOT NULL COMMENT 'Código identificador del perfil',
    XEPER_DESCRI       VARCHAR(100)    NOT NULL COMMENT 'Descripción del perfil',
    XEPER_OBSER        TEXT            NULL COMMENT 'Observaciones del perfil',
    PRIMARY KEY (XEPER_CODIGO)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Entidad utilizada para realizar la gestión de los diferentes perfiles';

-- Opciones de menú accesibles en el sistema
CREATE TABLE XEOPC_OPCIO (
    XEOPC_CODIGO       CHAR(3)         NOT NULL COMMENT 'Código de la opción del sistema',
    XESIS_CODIGO       CHAR(1)         NOT NULL COMMENT 'Código del subsistema al que pertenece',
    XEOPC_DESCRI       VARCHAR(100)    NOT NULL COMMENT 'Descripción o etiqueta de la opción de menú',
    PRIMARY KEY (XEOPC_CODIGO),
    CONSTRAINT FK_XR_XESIS_XEOPC FOREIGN KEY (XESIS_CODIGO) REFERENCES XESIS_SISTE (XESIS_CODIGO) ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Entidad utilizada para realizar el registro de las diferentes opciones de un sistema';

-- Matriz de permisos: opciones asignadas a cada perfil
CREATE TABLE XEOXP_OPCPE (
    XEOPC_CODIGO       CHAR(3)         NOT NULL COMMENT 'Código de la opción del sistema',
    XEPER_CODIGO       CHAR(8)         NOT NULL COMMENT 'Código del perfil asignado',
    XEOXP_FECASI       DATE            NOT NULL COMMENT 'Fecha de asignación de la opción al perfil',
    XEOXP_FECRET       DATE            NULL COMMENT 'Fecha de retiro de la opción',
    PRIMARY KEY (XEOPC_CODIGO, XEPER_CODIGO, XEOXP_FECASI),
    CONSTRAINT FK_XR_XEOPC_XEOXP FOREIGN KEY (XEOPC_CODIGO) REFERENCES XEOPC_OPCIO (XEOPC_CODIGO) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT FK_XR_XEPER_XEOXP FOREIGN KEY (XEPER_CODIGO) REFERENCES XEPER_PERFI (XEPER_CODIGO) ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Entidad utilizada para llevar el registro de las opciones que pertenecen a un perfil';

-- =============================================================================
-- 2. SUBSISTEMA PERSONAL Y TALENTO HUMANO (SUPE)
-- =============================================================================

-- Departamentos institucionales
CREATE TABLE PEDEP_DEPAR (
    PEDEP_CODIGO       CHAR(3)         NOT NULL COMMENT 'Código del departamento',
    PEDEP_DESCRIP      VARCHAR(50)     NULL COMMENT 'Descripción del departamento',
    PRIMARY KEY (PEDEP_CODIGO)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Entidad utilizada para realizar la gestión de los diferentes departamentos de la empresa';

-- Catálogo de géneros
CREATE TABLE PEGEN_GENERO (
    PEGEN_CODIGO       CHAR(1)         NOT NULL COMMENT 'Código del género (M, F, O)',
    PEGEN_DESCRI       VARCHAR(50)     NULL COMMENT 'Descripción del género',
    PRIMARY KEY (PEGEN_CODIGO)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Entidad utilizada para gestionar el género de una persona';

-- Catálogo de estado civil
CREATE TABLE PEESC_CIVIL (
    PEESC_CODIGO       CHAR(1)         NOT NULL COMMENT 'Código del estado civil (S, C, D, V, U)',
    PEESC_DESCRI       VARCHAR(50)     NULL COMMENT 'Descripción del estado civil',
    PRIMARY KEY (PEESC_CODIGO)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Entidad utilizada para la gestión del estado civil de una persona';

-- Cargos laborales por departamento
CREATE TABLE PECAR_CARGO (
    PEDEP_CODIGO       CHAR(3)         NOT NULL COMMENT 'Código del departamento asociado',
    PECAR_CODIGO       CHAR(3)         NOT NULL COMMENT 'Código del cargo dentro del departamento',
    PECAR_DESCRI       VARCHAR(50)     NULL COMMENT 'Descripción del cargo',
    PRIMARY KEY (PEDEP_CODIGO, PECAR_CODIGO),
    CONSTRAINT FK_PR_PEDEP_PECAR FOREIGN KEY (PEDEP_CODIGO) REFERENCES PEDEP_DEPAR (PEDEP_CODIGO) ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Entidad utilizada para realizar la gestión de los cargos que pertenecerán a un departamento';

-- Registro de personas naturales
CREATE TABLE PEPER_PERSO (
    PEPER_CODIGO       CHAR(10)        NOT NULL COMMENT 'Código único identificador de la persona',
    PEGEN_CODIGO       CHAR(1)         NOT NULL COMMENT 'Código del género',
    PEESC_CODIGO       CHAR(1)         NOT NULL COMMENT 'Código del estado civil',
    PEPER_APELLI       VARCHAR(50)     NOT NULL COMMENT 'Apellidos de la persona',
    PEPER_NOMBRE       VARCHAR(50)     NOT NULL COMMENT 'Nombres de la persona',
    PEPER_FECNAC       DATE            NOT NULL COMMENT 'Fecha de nacimiento',
    PEPER_CEDULA       VARCHAR(10)     NULL COMMENT 'Número de cédula de identidad ecuatoriana',
    PEPER_PASAPO       VARCHAR(15)     NULL COMMENT 'Número de pasaporte o identificación extranjera',
    PEPER_EMAIL        VARCHAR(50)     NULL COMMENT 'Correo electrónico de contacto',
    PEPER_CARFAM       NUMERIC(2,0)    NOT NULL DEFAULT 0 COMMENT 'Número de cargas familiares',
    PEPER_FOTO         VARCHAR(100)    NOT NULL DEFAULT 'default.png' COMMENT 'Ruta o nombre de la foto de perfil',
    PEPER_DISCAPACIDAD CHAR(1)         NOT NULL DEFAULT 'N' COMMENT 'Indicador de discapacidad (S/N)',
    PRIMARY KEY (PEPER_CODIGO),
    UNIQUE KEY AK_PEPER_CEDULA (PEPER_CEDULA),
    CONSTRAINT FK_PR_PEGEN_PEPER FOREIGN KEY (PEGEN_CODIGO) REFERENCES PEGEN_GENERO (PEGEN_CODIGO) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT FK_PR_PEESC_PEPER FOREIGN KEY (PEESC_CODIGO) REFERENCES PEESC_CIVIL (PEESC_CODIGO) ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Entidad utilizada para gestionar las personas que harán uso del sistema';

-- Usuarios del sistema vinculados a una persona
CREATE TABLE XEUSU_USUAR (
    XEUSU_PASWD        VARCHAR(64)     NOT NULL COMMENT 'Identificador de acceso o login/hash seguro',
    XEEST_CODIGO       CHAR(1)         NOT NULL COMMENT 'Estado del usuario (A activo, I inactivo, B bloqueado)',
    PEPER_CODIGO       CHAR(10)        NOT NULL COMMENT 'Persona asociada al usuario',
    XEUSU_FECCRE       DATETIME        NOT NULL COMMENT 'Fecha y hora de creación de la cuenta',
    XEUSU_FECMOD       DATETIME        NOT NULL COMMENT 'Fecha y hora de última modificación',
    XEUSU_PIEFIR       VARCHAR(100)    NOT NULL COMMENT 'Pie de firma digital o leyenda de responsabilidad',
    PRIMARY KEY (XEUSU_PASWD),
    UNIQUE KEY AK_XEUSU_PEPER (PEPER_CODIGO),
    CONSTRAINT FK_XR_XEEST_XEUSU FOREIGN KEY (XEEST_CODIGO) REFERENCES XEEST_ESTAD (XEEST_CODIGO) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT FK_XR_PEPER_XEUSU FOREIGN KEY (PEPER_CODIGO) REFERENCES PEPER_PERSO (PEPER_CODIGO) ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Entidad relacionada para gestionar los usuarios que ingresan al sistema';

-- Asignación de perfiles a usuarios
CREATE TABLE XEUXP_USUPE (
    XEUSU_PASWD        VARCHAR(64)     NOT NULL COMMENT 'Usuario del sistema',
    XEPER_CODIGO       CHAR(8)         NOT NULL COMMENT 'Perfil asignado al usuario',
    XEUXP_FECASI       DATE            NOT NULL COMMENT 'Fecha de asignación del perfil al usuario',
    XEUXP_FECRET       DATE            NULL COMMENT 'Fecha de retiro del perfil',
    PRIMARY KEY (XEUSU_PASWD, XEPER_CODIGO, XEUXP_FECASI),
    CONSTRAINT FK_XR_XEUSU_XEUXP FOREIGN KEY (XEUSU_PASWD) REFERENCES XEUSU_USUAR (XEUSU_PASWD) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT FK_XR_XEPER_XEUXP FOREIGN KEY (XEPER_CODIGO) REFERENCES XEPER_PERFI (XEPER_CODIGO) ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Entidad utilizada para realizar el registro de los diferentes usuarios que pertenecen a un perfil';

-- Bitácora y eventos de auditoría institucional
CREATE TABLE SEAUD_EVEN (
    SEAUD_CODIGO       INT             AUTO_INCREMENT NOT NULL COMMENT 'Identificador único del evento de auditoría',
    PEPER_CODIGO       CHAR(10)        NULL COMMENT 'Persona o autor que ejecuta la acción',
    SEAUD_FECHA        DATETIME        NOT NULL COMMENT 'Fecha y hora exacta del evento registrado',
    SEAUD_MODULO       VARCHAR(30)     NOT NULL COMMENT 'Módulo del sistema origen del evento',
    SEAUD_ACCION       VARCHAR(50)     NOT NULL COMMENT 'Acción realizada (LOGIN, INSERT, UPDATE, DELETE, etc.)',
    SEAUD_ENTID        VARCHAR(60)     NULL COMMENT 'Entidad o tabla afectada',
    SEAUD_IDOBJ        VARCHAR(60)     NULL COMMENT 'Identificador del objeto afectado',
    SEAUD_RESULT       VARCHAR(20)     NOT NULL COMMENT 'Resultado de la operación (EXITO, FALLO, ALERTA)',
    SEAUD_JUSTIF       VARCHAR(300)    NULL COMMENT 'Justificación de la operación sensible',
    SEAUD_ORIGEN       VARCHAR(45)     NULL COMMENT 'Dirección IP o terminal de origen',
    SEAUD_DETALL       TEXT            NULL COMMENT 'Detalle completo del evento en formato estructurado',
    PRIMARY KEY (SEAUD_CODIGO),
    CONSTRAINT FK_PERSONA_EVENTO_AUDITORIA FOREIGN KEY (PEPER_CODIGO) REFERENCES PEPER_PERSO (PEPER_CODIGO) ON UPDATE CASCADE ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Evento relevante de acceso u operación sensible, con actor, resultado y contexto';

-- Especialidades de salud
CREATE TABLE PEESP_ESPEC (
    PEESP_CODIGO       INT             AUTO_INCREMENT NOT NULL COMMENT 'Identificador de la especialidad',
    PEESP_NOMBRE       VARCHAR(60)     NOT NULL COMMENT 'Nombre de la especialidad médica',
    PEESP_ESTADO       CHAR(1)         NOT NULL DEFAULT 'A' COMMENT 'Estado de la especialidad: A activo, I inactivo',
    PRIMARY KEY (PEESP_CODIGO),
    UNIQUE KEY AK_PEESP_NOMBRE (PEESP_NOMBRE)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Especialidades médicas';

-- Profesionales de salud (médicos, enfermeros, especialistas)
CREATE TABLE PEPRO_PROFE (
    PEPRO_CODIGO       INT             AUTO_INCREMENT NOT NULL COMMENT 'Identificador único del profesional de salud',
    PEPER_CODIGO       CHAR(10)        NOT NULL COMMENT 'Persona asociada al profesional',
    PEESP_CODIGO       INT             NOT NULL COMMENT 'Especialidad principal del profesional',
    PEPRO_REGPRO       VARCHAR(20)     NOT NULL COMMENT 'Número de registro del profesional de salud (ACESS/MSP)',
    PEPRO_AGENDA       TEXT            NULL COMMENT 'Configuración o disponibilidad general de agenda',
    PRIMARY KEY (PEPRO_CODIGO),
    UNIQUE KEY AK_PEPRO_PEPER (PEPER_CODIGO),
    UNIQUE KEY AK_PEPRO_REGPRO (PEPRO_REGPRO),
    CONSTRAINT FK_PERSONA_PROFESIONAL FOREIGN KEY (PEPER_CODIGO) REFERENCES PEPER_PERSO (PEPER_CODIGO) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT FK_ESPECIALIDAD_PROFESIONAL FOREIGN KEY (PEESP_CODIGO) REFERENCES PEESP_ESPEC (PEESP_CODIGO) ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Profesionales de salud';

-- =============================================================================
-- 3. SUBSISTEMA GESTIÓN HOSPITALARIA (SUGH) - ADMISIÓN Y CITAS
-- =============================================================================

-- Registro único de pacientes
CREATE TABLE PAPAC_PACIE (
    PAPAC_CODIGO       INT             AUTO_INCREMENT NOT NULL COMMENT 'Identificador único del paciente',
    PAPAC_NUMHC        VARCHAR(12)     NOT NULL COMMENT 'Número único de historia clínica del paciente',
    PAPAC_TIPDOC       CHAR(1)         NOT NULL COMMENT 'Tipo de documento: C cédula, P pasaporte, R refugiado, X provisional',
    PAPAC_NUMDOC       VARCHAR(20)     NULL COMMENT 'Número de identificación del paciente',
    PAPAC_NOMBRE       VARCHAR(60)     NOT NULL COMMENT 'Nombres del paciente',
    PAPAC_APELLI       VARCHAR(60)     NOT NULL COMMENT 'Apellidos del paciente',
    PAPAC_FECNAC       DATE            NULL COMMENT 'Fecha de nacimiento',
    PAPAC_SEXO         CHAR(1)         NOT NULL COMMENT 'Sexo biológico del paciente: M masculino, F femenino',
    PAPAC_DIRECC       VARCHAR(200)    NULL COMMENT 'Dirección domiciliaria del paciente',
    PAPAC_TELEF        VARCHAR(15)     NULL COMMENT 'Teléfono de contacto',
    PAPAC_EMAIL        VARCHAR(100)    NULL COMMENT 'Correo electrónico',
    PAPAC_CONEME       VARCHAR(100)    NULL COMMENT 'Nombre del contacto de emergencia',
    PAPAC_TELEME       VARCHAR(15)     NULL COMMENT 'Teléfono del contacto de emergencia',
    PAPAC_PROVIS       TINYINT(1)      NOT NULL DEFAULT 0 COMMENT 'Indicador de paciente provisional/NN (1=Sí, 0=No)',
    PAPAC_ESTADO       CHAR(1)         NOT NULL DEFAULT 'A' COMMENT 'Estado del paciente: A activo, I inactivo',
    PAPAC_FECREG       DATETIME        NOT NULL COMMENT 'Fecha y hora de registro en el hospital',
    PRIMARY KEY (PAPAC_CODIGO),
    UNIQUE KEY AK_PAPAC_NUMHC (PAPAC_NUMHC),
    UNIQUE KEY AK_PAPAC_NUMDOC (PAPAC_NUMDOC)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Registro único de pacientes';

-- Consultorios físicos para atención
CREATE TABLE CONSULTORIO (
    CONS_CODIGO        INT             AUTO_INCREMENT NOT NULL COMMENT 'Identificador del consultorio',
    CONS_NOMBRE        VARCHAR(80)     NOT NULL COMMENT 'Nombre o código visible del consultorio',
    CONS_UBICACION     VARCHAR(120)    NULL COMMENT 'Ubicación física (piso, ala, bloque)',
    CONS_ESTADO        CHAR(1)         NOT NULL DEFAULT 'A' COMMENT 'Estado del consultorio: A activo, I inactivo, M mantenimiento',
    PRIMARY KEY (CONS_CODIGO),
    UNIQUE KEY AK_CONS_NOMBRE (CONS_NOMBRE)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Consultorios habilitados para la programación de agendas médicas';

-- Agendas médicas programadas por profesional y consultorio
CREATE TABLE AGENDA (
    AGEN_CODIGO        INT             AUTO_INCREMENT NOT NULL COMMENT 'Identificador de la agenda médica',
    PEPRO_CODIGO       INT             NOT NULL COMMENT 'Profesional de salud asignado',
    PEESP_CODIGO       INT             NOT NULL COMMENT 'Especialidad programada',
    CONS_CODIGO        INT             NOT NULL COMMENT 'Consultorio asignado para la agenda',
    AGEN_DIASEM        TINYINT         NOT NULL COMMENT 'Día de la semana (1=Lunes a 7=Domingo)',
    AGEN_HORINI        TIME            NOT NULL COMMENT 'Hora de inicio de la jornada',
    AGEN_HORFIN        TIME            NOT NULL COMMENT 'Hora de finalización de la jornada',
    AGEN_DURACION      SMALLINT        NOT NULL DEFAULT 20 COMMENT 'Duración de cada turno en minutos',
    AGEN_DESDE         DATE            NOT NULL COMMENT 'Fecha de inicio de vigencia de la agenda',
    AGEN_HASTA         DATE            NULL COMMENT 'Fecha de fin de vigencia',
    AGEN_ESTADO        CHAR(1)         NOT NULL DEFAULT 'A' COMMENT 'Estado de la agenda: A activa, I inactiva, S suspendida',
    PRIMARY KEY (AGEN_CODIGO),
    CONSTRAINT FK_PROFESIONAL_AGENDA FOREIGN KEY (PEPRO_CODIGO) REFERENCES PEPRO_PROFE (PEPRO_CODIGO) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT FK_ESPECIALIDAD_AGENDA FOREIGN KEY (PEESP_CODIGO) REFERENCES PEESP_ESPEC (PEESP_CODIGO) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT FK_CONSULTORIO_AGENDA FOREIGN KEY (CONS_CODIGO) REFERENCES CONSULTORIO (CONS_CODIGO) ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Disponibilidad por profesional, especialidad, consultorio y periodo, requerida por la gestión de citas';

-- Citas médicas
CREATE TABLE CITA (
    PACIT_CODIGO       INT             AUTO_INCREMENT NOT NULL COMMENT 'Identificador único de la cita médica',
    PAPAC_CODIGO       INT             NOT NULL COMMENT 'Paciente asociado a la cita',
    PEPRO_CODIGO       INT             NOT NULL COMMENT 'Profesional de salud asignado',
    AGEN_CODIGO        INT             NULL COMMENT 'Agenda programada origen de la cita',
    PACIT_FECHA        DATE            NOT NULL COMMENT 'Fecha agendada para la cita',
    PACIT_HORA         TIME            NOT NULL COMMENT 'Hora agendada para la cita',
    PACIT_MOTIVO       VARCHAR(200)    NOT NULL COMMENT 'Motivo de consulta indicado al agendar',
    PACIT_ESTADO       VARCHAR(15)     NOT NULL DEFAULT 'PROGRAMADA' COMMENT 'PROGRAMADA, CONFIRMADA, ATENDIDA, CANCELADA, NO_ASISTIO',
    PACIT_HORLLE       DATETIME        NULL COMMENT 'Hora real de llegada del paciente (triaje/sala)',
    PACIT_MOTCAM       VARCHAR(200)    NULL COMMENT 'Motivo de cambio o cancelación de la cita',
    PACIT_FECREG       DATETIME        NOT NULL COMMENT 'Fecha y hora de registro de la cita',
    PACIT_CONSUL       VARCHAR(80)     NULL COMMENT 'Consultorio o sala asignada',
    PRIMARY KEY (PACIT_CODIGO),
    CONSTRAINT FK_PACIENTE_CITA FOREIGN KEY (PAPAC_CODIGO) REFERENCES PAPAC_PACIE (PAPAC_CODIGO) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT FK_PROFESIONAL_CITA FOREIGN KEY (PEPRO_CODIGO) REFERENCES PEPRO_PROFE (PEPRO_CODIGO) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT FK_AGENDA_CITA FOREIGN KEY (AGEN_CODIGO) REFERENCES AGENDA (AGEN_CODIGO) ON UPDATE CASCADE ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Citas médicas';

-- =============================================================================
-- 4. SUBSISTEMA GESTIÓN HOSPITALARIA (SUGH) - ATENCIÓN, HISTORIA CLÍNICA Y EMERGENCIAS
-- =============================================================================

-- Atenciones clínicas (Consulta externa y Emergencias)
CREATE TABLE CLATE_ATENC (
    CLATE_CODIGO       INT             AUTO_INCREMENT NOT NULL COMMENT 'Identificador único de la atención clínica',
    PAPAC_CODIGO       INT             NOT NULL COMMENT 'Paciente atendido',
    PEPRO_CODIGO       INT             NOT NULL COMMENT 'Profesional médico responsable',
    PACIT_CODIGO       INT             NULL COMMENT 'Cita médica asociada si proviene de consulta agendada',
    CLATE_TIPO         VARCHAR(12)     NOT NULL COMMENT 'Tipo de atención: CONSULTA o EMERGENCIA',
    CLATE_FECHA        DATETIME        NOT NULL COMMENT 'Fecha y hora de inicio de la atención',
    CLATE_MOTIVO       VARCHAR(300)    NOT NULL COMMENT 'Motivo de consulta y enfermedad actual',
    CLATE_SINTOM       TEXT            NULL COMMENT 'Síntomas referidos y anamnesis',
    CLATE_EXPLOR       TEXT            NULL COMMENT 'Hallazgos de la exploración física',
    CLATE_INDICA       TEXT            NULL COMMENT 'Indicaciones generales y plan terapéutico',
    CLATE_TRIAJE       TINYINT         NULL COMMENT 'Nivel de triaje Manchester (1 Rojo, 2 Naranja, 3 Amarillo, 4 Verde, 5 Azul)',
    CLATE_DISPOS       VARCHAR(20)     NULL COMMENT 'Destino del paciente: ALTA, HOSPITALIZACION, OBSERVACION, REFERENCIA',
    CLATE_PROREV       DATE            NULL COMMENT 'Fecha sugerida para próxima revisión o control',
    CLATE_ESTADO       VARCHAR(15)     NOT NULL DEFAULT 'EN_ELABORACION' COMMENT 'EN_ELABORACION, FINALIZADA, ANULADA',
    CLATE_FECFIN       DATETIME        NULL COMMENT 'Fecha y hora de cierre de la atención médica',
    CLATE_PRESIS       INT             NULL COMMENT 'Signos vitales: Presión arterial sistólica (mmHg)',
    CLATE_PREDIA       INT             NULL COMMENT 'Signos vitales: Presión arterial diastólica (mmHg)',
    CLATE_FCARD        INT             NULL COMMENT 'Signos vitales: Frecuencia cardíaca (lpm)',
    CLATE_FRESP        INT             NULL COMMENT 'Signos vitales: Frecuencia respiratoria (rpm)',
    CLATE_TEMP         DECIMAL(5,2)    NULL COMMENT 'Signos vitales: Temperatura corporal (°C)',
    CLATE_SATUR        DECIMAL(5,2)    NULL COMMENT 'Signos vitales: Saturación de oxígeno SpO2 (%)',
    CLATE_PESO         DECIMAL(6,2)    NULL COMMENT 'Signos vitales: Peso corporal (kg)',
    CLATE_TALLA        DECIMAL(5,2)    NULL COMMENT 'Signos vitales: Talla o estatura (cm)',
    PRIMARY KEY (CLATE_CODIGO),
    CONSTRAINT FK_PACIENTE_ATENCION FOREIGN KEY (PAPAC_CODIGO) REFERENCES PAPAC_PACIE (PAPAC_CODIGO) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT FK_PROFESIONAL_ATENCION FOREIGN KEY (PEPRO_CODIGO) REFERENCES PEPRO_PROFE (PEPRO_CODIGO) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT FK_CITA_ATENCION FOREIGN KEY (PACIT_CODIGO) REFERENCES CITA (PACIT_CODIGO) ON UPDATE CASCADE ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Atenciones de consulta externa y emergencia';

-- Diagnósticos médicos CIE-10 vinculados a una atención
CREATE TABLE CLDIA_DIAGN (
    CLDIA_CODIGO       INT             AUTO_INCREMENT NOT NULL COMMENT 'Identificador del diagnóstico',
    CLATE_CODIGO       INT             NOT NULL COMMENT 'Atención médica asociada',
    CLDIA_CIE10        VARCHAR(8)      NOT NULL COMMENT 'Código internacional CIE-10 (ej: J00, I10, E11)',
    CLDIA_DESCRI       VARCHAR(200)    NOT NULL COMMENT 'Descripción del diagnóstico clínico',
    CLDIA_TIPO         VARCHAR(12)     NOT NULL DEFAULT 'PRESUNTIVO' COMMENT 'Tipo: PRESUNTIVO o DEFINITIVO',
    PRIMARY KEY (CLDIA_CODIGO),
    CONSTRAINT FK_ATENCION_DIAGNOSTICO FOREIGN KEY (CLATE_CODIGO) REFERENCES CLATE_ATENC (CLATE_CODIGO) ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Diagnósticos CIE-10 de una atención';

-- Alergias y reacciones adversas del paciente
CREATE TABLE CLALR_ALERG (
    CLALR_CODIGO       INT             AUTO_INCREMENT NOT NULL COMMENT 'Identificador de la alerta de alergia',
    PAPAC_CODIGO       INT             NOT NULL COMMENT 'Paciente afectado',
    CLALR_ALERGE       VARCHAR(12)     NOT NULL COMMENT 'Código o tipo del alérgeno (MEDICAMENTO, ALIMENTO, AMBIENTAL)',
    CLALR_REACCI       VARCHAR(300)    NOT NULL COMMENT 'Descripción de la reacción alérgica adversa',
    CLALR_VERIFI       TINYINT(1)      NOT NULL DEFAULT 1 COMMENT 'Estado de verificación médica (1=Verificada, 0=Sospecha)',
    CLALR_FECREG       DATETIME        NOT NULL COMMENT 'Fecha y hora de registro de la alergia',
    CLALR_FUENTE       VARCHAR(120)    NULL COMMENT 'Fuente de la información (Paciente, Familiar, Prueba)',
    PRIMARY KEY (CLALR_CODIGO),
    CONSTRAINT FK_PACIENTE_ALERGIA FOREIGN KEY (PAPAC_CODIGO) REFERENCES PAPAC_PACIE (PAPAC_CODIGO) ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Alergia o reacción adversa conocida del paciente, con fuente y estado de verificación';

-- Documentos clínicos adjuntos
CREATE TABLE CLDOC_DOCLI (
    CLDOC_CODIGO       INT             AUTO_INCREMENT NOT NULL COMMENT 'Identificador del documento clínico adjunto',
    CLATE_CODIGO       INT             NOT NULL COMMENT 'Atención médica a la que pertenece',
    PEPER_CODIGO       CHAR(10)        NULL COMMENT 'Persona o profesional autor del documento',
    CLDOC_PREDEC       INT             NULL COMMENT 'Documento predecesor en caso de versión o adenda',
    CLDOC_TIPO         VARCHAR(30)     NOT NULL COMMENT 'Tipo de documento (INFORME, CONSENTIMIENTO, EPICRISIS, ADENDA)',
    CLDOC_TITULO       VARCHAR(150)    NOT NULL COMMENT 'Título o resumen descriptivo del documento',
    CLDOC_URI          VARCHAR(500)    NOT NULL COMMENT 'Ruta física o URI de almacenamiento seguro',
    CLDOC_HASH         CHAR(64)        NOT NULL COMMENT 'Hash SHA-256 para verificación de integridad',
    CLDOC_FECHA        DATETIME        NOT NULL COMMENT 'Fecha y hora de registro del documento',
    CLDOC_CONTEN       TEXT            NULL COMMENT 'Contenido textual estructurado o resumen clínico',
    PRIMARY KEY (CLDOC_CODIGO),
    CONSTRAINT FK_ATENCION_DOCLI FOREIGN KEY (CLATE_CODIGO) REFERENCES CLATE_ATENC (CLATE_CODIGO) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT FK_PERSONA_DOCLI FOREIGN KEY (PEPER_CODIGO) REFERENCES PEPER_PERSO (PEPER_CODIGO) ON UPDATE CASCADE ON DELETE SET NULL,
    CONSTRAINT FK_DOCLI_PREDEC FOREIGN KEY (CLDOC_PREDEC) REFERENCES CLDOC_DOCLI (CLDOC_CODIGO) ON UPDATE CASCADE ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Documento adjunto a una atención clínica, con metadatos, integridad y trazabilidad';

-- =============================================================================
-- 5. SUBSISTEMA GESTIÓN HOSPITALARIA (SUGH) - LABORATORIO E IMAGENOLOGÍA
-- =============================================================================

-- Órdenes de exámenes de laboratorio
CREATE TABLE LAORD_ORDEN (
    LAORD_CODIGO       INT             AUTO_INCREMENT NOT NULL COMMENT 'Identificador de la orden de laboratorio',
    CLATE_CODIGO       INT             NOT NULL COMMENT 'Atención médica origen de la orden',
    LAORD_PRIORI       VARCHAR(10)     NOT NULL DEFAULT 'RUTINA' COMMENT 'Prioridad: RUTINA o URGENTE',
    LAORD_FECSOL       DATETIME        NOT NULL COMMENT 'Fecha y hora de la solicitud médica',
    LAORD_ESTADO       VARCHAR(20)     NOT NULL DEFAULT 'REGISTRADA' COMMENT 'REGISTRADA, MUESTRA_RECIBIDA, EN_PROCESO, VALIDADA, ANULADA',
    LAORD_CODMUE       VARCHAR(20)     NULL COMMENT 'Código de barras o identificador de muestra',
    LAORD_FECMUE       DATETIME        NULL COMMENT 'Fecha y hora de toma o recepción de muestra',
    LAORD_INCIDE       VARCHAR(300)    NULL COMMENT 'Incidencias con la muestra (hemólisis, coagulación, etc.)',
    LAORD_TIPMUE       VARCHAR(40)     NULL COMMENT 'Tipo de muestra biológica (SANGRE, ORINA, HECES, LCR)',
    PRIMARY KEY (LAORD_CODIGO),
    CONSTRAINT FK_ATENCION_ORDENLAB FOREIGN KEY (CLATE_CODIGO) REFERENCES CLATE_ATENC (CLATE_CODIGO) ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Órdenes de laboratorio clínico';

-- Resultados y validación de exámenes de laboratorio
CREATE TABLE LARES_RESLA (
    LADET_CODIGO       INT             AUTO_INCREMENT NOT NULL COMMENT 'Identificador del resultado de la prueba',
    LAORD_CODIGO       INT             NOT NULL COMMENT 'Orden de laboratorio asociada',
    LADET_RESULT       VARCHAR(100)    NULL COMMENT 'Valor cuantitativo o cualitativo del resultado',
    LADET_CRITIC       TINYINT(1)      NOT NULL DEFAULT 0 COMMENT 'Indicador de valor de alerta/pánico (1=Sí, 0=No)',
    LADET_VERSIO       INT             NOT NULL DEFAULT 1 COMMENT 'Versión del resultado en caso de rectificación',
    LADET_ESTADO       VARCHAR(15)     NOT NULL DEFAULT 'PENDIENTE' COMMENT 'PENDIENTE, PRELIMINAR, VALIDADO, RECTIFICADO',
    LADET_FECRES       DATETIME        NULL COMMENT 'Fecha y hora de procesamiento técnico',
    AUD_AUTOR          CHAR(10)        NULL COMMENT 'Personal de laboratorio que valida el resultado',
    LADET_FECVAL       DATETIME        NULL COMMENT 'Fecha y hora de validación clínica',
    LARES_NOMEXA       VARCHAR(120)    NULL COMMENT 'Nombre del parámetro o examen analizado',
    PRIMARY KEY (LADET_CODIGO),
    CONSTRAINT FK_ORDEN_DETALLE_LAB FOREIGN KEY (LAORD_CODIGO) REFERENCES LAORD_ORDEN (LAORD_CODIGO) ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Resultado asociado a una prueba solicitada dentro de una orden de laboratorio, con estado y validación';

-- Órdenes e informes de imagenología
CREATE TABLE IMORD_ORDIM (
    IMORD_CODIGO       INT             AUTO_INCREMENT NOT NULL COMMENT 'Identificador de la orden de imagen',
    CLATE_CODIGO       INT             NOT NULL COMMENT 'Atención médica asociada',
    PEPRO_CODIGO       INT             NOT NULL COMMENT 'Médico solicitante',
    IMINF_CODINF       INT             NULL COMMENT 'Médico radiólogo que valida el informe',
    IMORD_TIPO         VARCHAR(50)     NOT NULL COMMENT 'Modalidad (RAYOS_X, ECOGRAFIA, TOMOGRAFIA, RESONANCIA)',
    IMORD_REGION       VARCHAR(50)     NULL COMMENT 'Región anatómica a explorar (Tórax, Abdomen, Cráneo, etc.)',
    IMORD_PRIORI       VARCHAR(15)     NOT NULL DEFAULT 'RUTINA' COMMENT 'Prioridad: RUTINA o URGENTE',
    IMORD_INDIC        TEXT            NOT NULL COMMENT 'Sospecha e indicación clínica del estudio',
    IMORD_FECSOL       DATETIME        NOT NULL COMMENT 'Fecha y hora de solicitud',
    IMORD_FECPRO       DATETIME        NULL COMMENT 'Fecha programada para la toma de la imagen',
    IMORD_ESTADO       VARCHAR(15)     NOT NULL DEFAULT 'SOLICITADA' COMMENT 'SOLICITADA, AGENDADA, REALIZADA, INFORMADA, ANULADA',
    IMINF_HALLA        TEXT            NULL COMMENT 'Descripción técnica de los hallazgos radiológicos',
    IMINF_CONCL        TEXT            NULL COMMENT 'Conclusión diagnóstica del radiólogo',
    IMINF_FECVAL       DATETIME        NULL COMMENT 'Fecha y hora de validación del informe radiológico',
    IMINF_ESTADO       VARCHAR(15)     NULL COMMENT 'Estado del informe (PRELIMINAR, DEFINITIVO)',
    IMINF_URI          VARCHAR(500)    NULL COMMENT 'Ubicación PACS o repositorio de archivos DICOM/PDF',
    PRIMARY KEY (IMORD_CODIGO),
    CONSTRAINT FK_ATENCION_ORDEN_IMAGEN FOREIGN KEY (CLATE_CODIGO) REFERENCES CLATE_ATENC (CLATE_CODIGO) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT FK_PROFESIONAL_ORDEN_IMAGEN FOREIGN KEY (PEPRO_CODIGO) REFERENCES PEPRO_PROFE (PEPRO_CODIGO) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT FK_PROFESIONAL_INFORME_IMAGEN FOREIGN KEY (IMINF_CODINF) REFERENCES PEPRO_PROFE (PEPRO_CODIGO) ON UPDATE CASCADE ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Solicitud, ejecución e informe validado de un estudio de diagnóstico por imagen';

-- =============================================================================
-- 6. SUBSISTEMA GESTIÓN HOSPITALARIA (SUGH) - FARMACIA E INVENTARIO
-- =============================================================================

-- Catálogo de medicamentos institucionales
CREATE TABLE FAMED_MEDIC (
    FAMED_CODIGO       INT             AUTO_INCREMENT NOT NULL COMMENT 'Identificador del medicamento',
    FAMED_CODIGOM      VARCHAR(20)     NOT NULL COMMENT 'Código institucional o barra del medicamento',
    FAMED_NOMBRE       VARCHAR(100)    NOT NULL COMMENT 'Nombre comercial o descriptivo del producto',
    FAMED_PRIACT       VARCHAR(100)    NOT NULL COMMENT 'Principio activo (DCI)',
    FAMED_PRESEN       VARCHAR(50)     NOT NULL COMMENT 'Forma farmacéutica (Tableta, Jarabe, Ampolla)',
    FAMED_CONCEN       VARCHAR(30)     NOT NULL COMMENT 'Concentración (ej: 500 mg, 1 g, 10 mg/ml)',
    FAMED_UNIDAD       VARCHAR(15)     NOT NULL COMMENT 'Unidad de medida (tableta, ampolla, frasco)',
    FAMED_STKMIN       INT             NOT NULL DEFAULT 10 COMMENT 'Nivel mínimo de stock para alerta de reposición',
    FAMED_PRECIO       DECIMAL(10,2)   NOT NULL DEFAULT 0.00 COMMENT 'Precio de venta al público institucional',
    FAMED_ESTADO       CHAR(1)         NOT NULL DEFAULT 'A' COMMENT 'Estado del medicamento: A activo, I inactivo',
    PRIMARY KEY (FAMED_CODIGO),
    UNIQUE KEY AK_FAMED_CODIGOM (FAMED_CODIGOM)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Catálogo de medicamentos';

-- Prescripciones médicas
CREATE TABLE CLPRE_PRESC (
    CLPRE_CODIGO       INT             AUTO_INCREMENT NOT NULL COMMENT 'Identificador de la prescripción',
    CLATE_CODIGO       INT             NOT NULL COMMENT 'Atención médica asociada',
    FAMED_CODIGO       INT             NOT NULL COMMENT 'Medicamento prescrito',
    CLPRE_DOSIS        VARCHAR(40)     NOT NULL COMMENT 'Dosis indicada (ej: 1 comprimido, 10 ml)',
    CLPRE_VIA          VARCHAR(20)     NOT NULL COMMENT 'Vía de administración (ORAL, INTRAVENOSA, INTRAMUSCULAR)',
    CLPRE_FRECUE       VARCHAR(40)     NOT NULL COMMENT 'Frecuencia de administración (ej: cada 8 horas)',
    CLPRE_DURACI       VARCHAR(40)     NOT NULL COMMENT 'Duración del tratamiento (ej: por 5 días)',
    CLPRE_CANTID       INT             NOT NULL COMMENT 'Cantidad total de unidades prescritas',
    CLPRE_CANDIS       INT             NOT NULL DEFAULT 0 COMMENT 'Cantidad de unidades efectivamente dispensadas',
    CLPRE_INSTRU       VARCHAR(300)    NULL COMMENT 'Instrucciones adicionales para el paciente',
    CLPRE_JUSTIF       VARCHAR(300)    NULL COMMENT 'Justificación ante alertas de interacción o alergia',
    CLPRE_ESTADO       VARCHAR(15)     NOT NULL DEFAULT 'VIGENTE' COMMENT 'VIGENTE, DISPENSADA, PARCIAL, ANULADA',
    PRIMARY KEY (CLPRE_CODIGO),
    CONSTRAINT FK_ATENCION_PRESC FOREIGN KEY (CLATE_CODIGO) REFERENCES CLATE_ATENC (CLATE_CODIGO) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT FK_MEDICAMENTO_PRESC FOREIGN KEY (FAMED_CODIGO) REFERENCES FAMED_MEDIC (FAMED_CODIGO) ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Prescripciones médicas';

-- Lotes de medicamentos e inventario
CREATE TABLE FALOT_LOTE (
    FALOT_CODIGO       INT             AUTO_INCREMENT NOT NULL COMMENT 'Identificador del lote',
    FAMED_CODIGO       INT             NOT NULL COMMENT 'Medicamento al que corresponde el lote',
    FALOT_NUMERO       VARCHAR(30)     NOT NULL COMMENT 'Número o código del lote del fabricante',
    FALOT_FECCAD       DATE            NOT NULL COMMENT 'Fecha de caducidad del lote',
    FALOT_CANINI       INT             NOT NULL COMMENT 'Cantidad de unidades ingresadas inicialmente',
    FALOT_CANDIS       INT             NOT NULL COMMENT 'Cantidad de unidades actualmente disponibles',
    FALOT_FECING       DATETIME        NOT NULL COMMENT 'Fecha y hora de ingreso del lote al almacén',
    PRIMARY KEY (FALOT_CODIGO),
    CONSTRAINT FK_MEDICAMENTO_LOTE FOREIGN KEY (FAMED_CODIGO) REFERENCES FAMED_MEDIC (FAMED_CODIGO) ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Lotes de medicamentos';

-- Movimientos de inventario de farmacia (kardex)
CREATE TABLE FAMOV_MOVIN (
    FAMOV_CODIGO       INT             AUTO_INCREMENT NOT NULL COMMENT 'Identificador del movimiento de inventario',
    FALOT_CODIGO       INT             NOT NULL COMMENT 'Lote afectado por el movimiento',
    FAMOV_TIPO         VARCHAR(12)     NOT NULL COMMENT 'Tipo: INGRESO, EGRESO, AJUSTE, DISPENSACION, DEVOLUCION',
    FAMOV_CANTID       INT             NOT NULL COMMENT 'Cantidad de unidades afectadas',
    FAMOV_MOTIVO       VARCHAR(200)    NULL COMMENT 'Motivo o justificación del movimiento',
    AUD_AUTOR          CHAR(10)        NOT NULL COMMENT 'Usuario o personal responsable del movimiento',
    FAMOV_FECHA        DATETIME        NOT NULL COMMENT 'Fecha y hora exacta del movimiento',
    PRIMARY KEY (FAMOV_CODIGO),
    CONSTRAINT FK_LOTE_MOVIMIENTO FOREIGN KEY (FALOT_CODIGO) REFERENCES FALOT_LOTE (FALOT_CODIGO) ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Movimientos de inventario';

-- Registro de dispensaciones de farmacia
CREATE TABLE FADIS_DISPE (
    FADIS_CODIGO       INT             AUTO_INCREMENT NOT NULL COMMENT 'Identificador de la dispensación',
    CLPRE_CODIGO       INT             NOT NULL COMMENT 'Prescripción médica atendida',
    FALOT_CODIGO       INT             NOT NULL COMMENT 'Lote de donde se extrajo el medicamento',
    FADIS_CANTID       INT             NOT NULL COMMENT 'Cantidad de unidades entregadas',
    AUD_AUTOR          CHAR(10)        NOT NULL COMMENT 'Farmacéutico que realizó la entrega',
    FADIS_FECHA        DATETIME        NOT NULL COMMENT 'Fecha y hora de la entrega del medicamento',
    PRIMARY KEY (FADIS_CODIGO),
    CONSTRAINT FK_PRESC_DISPENSACION FOREIGN KEY (CLPRE_CODIGO) REFERENCES CLPRE_PRESC (CLPRE_CODIGO) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT FK_LOTE_DISPENSACION FOREIGN KEY (FALOT_CODIGO) REFERENCES FALOT_LOTE (FALOT_CODIGO) ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Dispensación de medicamentos';

-- =============================================================================
-- 7. SUBSISTEMA GESTIÓN HOSPITALARIA (SUGH) - HOSPITALIZACIÓN Y CAMAS
-- =============================================================================

-- Unidades asistenciales o pabellones hospitalarios
CREATE TABLE UNIDAD_HOSPITALARIA (
    UNHO_CODIGO        INT             AUTO_INCREMENT NOT NULL COMMENT 'Identificador de la unidad hospitalaria',
    UNHO_NOMBRE        VARCHAR(100)    NOT NULL COMMENT 'Nombre de la unidad (ej: Medicina Interna, Cuidados Intensivos, Pediatría)',
    UNHO_TIPO          VARCHAR(50)     NULL COMMENT 'Tipo de servicio (HOSPITALIZACION, CUIDADOS_CRITICOS, EMERGENCIAS)',
    UNHO_ESTADO        CHAR(1)         NOT NULL DEFAULT 'A' COMMENT 'Estado de la unidad: A activa, I inactiva',
    PRIMARY KEY (UNHO_CODIGO),
    UNIQUE KEY AK_UNHO_NOMBRE (UNHO_NOMBRE)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Servicio o unidad asistencial donde se encuentran las habitaciones y camas';

-- Habitaciones físicas de una unidad hospitalaria
CREATE TABLE HABITACION (
    HABI_CODIGO        INT             AUTO_INCREMENT NOT NULL COMMENT 'Identificador de la habitación',
    UNHO_CODIGO        INT             NOT NULL COMMENT 'Unidad hospitalaria a la que pertenece',
    HABI_NUMERO        VARCHAR(20)     NOT NULL COMMENT 'Número o identificador visible de la habitación (ej: H-101)',
    HABI_ESTADO        CHAR(1)         NOT NULL DEFAULT 'A' COMMENT 'Estado de la habitación: A activa, I inactiva, M mantenimiento',
    PRIMARY KEY (HABI_CODIGO),
    CONSTRAINT FK_UNIDAD_HABITACION FOREIGN KEY (UNHO_CODIGO) REFERENCES UNIDAD_HOSPITALARIA (UNHO_CODIGO) ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Habitación perteneciente a una unidad hospitalaria y contenedora de camas';

-- Camas hospitalarias
CREATE TABLE CAMA (
    HOCAM_CODIGO       INT             AUTO_INCREMENT NOT NULL COMMENT 'Identificador de la cama',
    HABI_CODIGO        INT             NOT NULL COMMENT 'Habitación donde está ubicada la cama',
    HOCAM_NUMERO       VARCHAR(20)     NOT NULL COMMENT 'Número de la cama (ej: CAMA-101-A)',
    HOCAM_ESTADO       VARCHAR(20)     NOT NULL DEFAULT 'DISPONIBLE' COMMENT 'DISPONIBLE, OCUPADA, LIMPIEZA, MANTENIMIENTO, RESERVADA',
    HOCAM_UNIDAD       VARCHAR(60)     NULL COMMENT 'Descripción o etiqueta de la unidad funcional',
    PRIMARY KEY (HOCAM_CODIGO),
    CONSTRAINT FK_HABITACION_CAMA FOREIGN KEY (HABI_CODIGO) REFERENCES HABITACION (HABI_CODIGO) ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Camas hospitalarias';

-- Episodios de hospitalización
CREATE TABLE HOSPITALIZACION (
    HOHOS_CODIGO       INT             AUTO_INCREMENT NOT NULL COMMENT 'Identificador del episodio de hospitalización',
    PAPAC_CODIGO       INT             NOT NULL COMMENT 'Paciente hospitalizado',
    PEPRO_CODIGO       INT             NOT NULL COMMENT 'Médico que autoriza el ingreso',
    HOCAM_CODIGO       INT             NOT NULL COMMENT 'Cama actual asignada al paciente',
    CLATE_CODIGO       INT             NULL COMMENT 'Atención de origen (consulta o emergencia)',
    HOHOS_FECING       DATETIME        NOT NULL COMMENT 'Fecha y hora de ingreso a hospitalización',
    HOHOS_DIAING       VARCHAR(200)    NOT NULL COMMENT 'Diagnóstico principal de ingreso',
    HOHOS_ALTMED       DATETIME        NULL COMMENT 'Fecha y hora del alta médica',
    HOHOS_ALTADM       DATETIME        NULL COMMENT 'Fecha y hora del alta administrativa / facturación',
    HOHOS_ESTADO       VARCHAR(15)     NOT NULL DEFAULT 'ACTIVA' COMMENT 'ACTIVA, ALTA_MEDICA, CERRADA, TRASLADADA',
    PRIMARY KEY (HOHOS_CODIGO),
    CONSTRAINT FK_PACIENTE_HOSPITALIZACION FOREIGN KEY (PAPAC_CODIGO) REFERENCES PAPAC_PACIE (PAPAC_CODIGO) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT FK_PROFESIONAL_HOSPITALIZACION FOREIGN KEY (PEPRO_CODIGO) REFERENCES PEPRO_PROFE (PEPRO_CODIGO) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT FK_CAMA_HOSPITALIZACION FOREIGN KEY (HOCAM_CODIGO) REFERENCES CAMA (HOCAM_CODIGO) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT FK_ATENCION_HOSPITALIZACION FOREIGN KEY (CLATE_CODIGO) REFERENCES CLATE_ATENC (CLATE_CODIGO) ON UPDATE CASCADE ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Episodios de hospitalización de pacientes';

-- Traslados de cama dentro de una hospitalización
CREATE TABLE HOTRA_TRASL (
    HOTRA_CODIGO       INT             AUTO_INCREMENT NOT NULL COMMENT 'Identificador del traslado de cama',
    HOHOS_CODIGO       INT             NOT NULL COMMENT 'Episodio de hospitalización asociado',
    HOCAM_ORIGEN       INT             NOT NULL COMMENT 'Cama de origen del paciente',
    HOCAM_DESTINO      INT             NOT NULL COMMENT 'Cama de destino del paciente',
    HOTRA_FECHA        DATETIME        NOT NULL COMMENT 'Fecha y hora en que se ejecutó el traslado',
    AUD_AUTOR          CHAR(10)        NOT NULL COMMENT 'Personal responsable del traslado',
    PRIMARY KEY (HOTRA_CODIGO),
    CONSTRAINT FK_HOSP_TRASLADO FOREIGN KEY (HOHOS_CODIGO) REFERENCES HOSPITALIZACION (HOHOS_CODIGO) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT FK_CAMA_ORIGEN_TRASLADO FOREIGN KEY (HOCAM_ORIGEN) REFERENCES CAMA (HOCAM_CODIGO) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT FK_CAMA_DESTINO_TRASLADO FOREIGN KEY (HOCAM_DESTINO) REFERENCES CAMA (HOCAM_CODIGO) ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Traslados entre camas';

-- Historial y auditoría de asignación de camas
CREATE TABLE ASIGNACION_CAMA (
    ASCA_CODIGO        INT             AUTO_INCREMENT NOT NULL COMMENT 'Identificador de la asignación de cama',
    HOHOS_CODIGO       INT             NOT NULL COMMENT 'Hospitalización asociada',
    HOCAM_CODIGO       INT             NOT NULL COMMENT 'Cama asignada',
    PEPER_CODIGO       CHAR(10)        NULL COMMENT 'Personal que realizó la asignación',
    ASCA_INICIO        DATETIME        NOT NULL COMMENT 'Fecha y hora de inicio de ocupación',
    ASCA_FIN           DATETIME        NULL COMMENT 'Fecha y hora de liberación de la cama',
    ASCA_MOTIVO        VARCHAR(200)    NULL COMMENT 'Motivo o detalle de la asignación',
    PRIMARY KEY (ASCA_CODIGO),
    CONSTRAINT FK_HOSP_ASIGNACION FOREIGN KEY (HOHOS_CODIGO) REFERENCES HOSPITALIZACION (HOHOS_CODIGO) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT FK_CAMA_ASIGNACION FOREIGN KEY (HOCAM_CODIGO) REFERENCES CAMA (HOCAM_CODIGO) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT FK_PERSONA_ASIGNACION FOREIGN KEY (PEPER_CODIGO) REFERENCES PEPER_PERSO (PEPER_CODIGO) ON UPDATE CASCADE ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Historial de ocupación de camas por hospitalización, con periodo y responsable';

-- =============================================================================
-- 8. SUBSISTEMA GESTIÓN HOSPITALARIA (SUGH) - PROCEDIMIENTOS QUIRÚRGICOS
-- =============================================================================

-- Procedimientos e intervenciones quirúrgicas
CREATE TABLE QUPRO_PRQUI (
    QUPRO_CODIGO       INT             AUTO_INCREMENT NOT NULL COMMENT 'Identificador del procedimiento quirúrgico',
    CLATE_CODIGO       INT             NOT NULL COMMENT 'Atención médica asociada',
    PEPRO_CODIGO       INT             NOT NULL COMMENT 'Cirujano principal responsable',
    QUPRO_NOMBRE       VARCHAR(150)    NOT NULL COMMENT 'Nombre de la intervención o técnica quirúrgica',
    QUPRO_FECPRO       DATETIME        NOT NULL COMMENT 'Fecha y hora programada para la cirugía',
    QUPRO_INICIO       DATETIME        NULL COMMENT 'Hora real de inicio en quirófano',
    QUPRO_FIN          DATETIME        NULL COMMENT 'Hora real de salida de quirófano',
    QUPRO_SALA         VARCHAR(50)     NULL COMMENT 'Quirófano o sala asignada',
    QUPRO_ANEST        VARCHAR(100)    NULL COMMENT 'Tipo de anestesia administrada',
    QUPRO_HALLA        TEXT            NULL COMMENT 'Descripción de hallazgos intraoperatorios',
    QUPRO_ESTADO       VARCHAR(15)     NOT NULL DEFAULT 'PROGRAMADO' COMMENT 'PROGRAMADO, EN_CURSO, COMPLETADO, SUSPENDIDO',
    QUPRO_EQUIPO       TEXT            NULL COMMENT 'Equipo médico participante (ayudantes, anestesiólogo, instrumentista)',
    QUPRO_CHECK        TEXT            NULL COMMENT 'Lista de verificación de cirugía segura OMS',
    PRIMARY KEY (QUPRO_CODIGO),
    CONSTRAINT FK_ATENCION_QUIROFANO FOREIGN KEY (CLATE_CODIGO) REFERENCES CLATE_ATENC (CLATE_CODIGO) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT FK_CIRUJANO_QUIROFANO FOREIGN KEY (PEPRO_CODIGO) REFERENCES PEPRO_PROFE (PEPRO_CODIGO) ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Programación y registro de una intervención quirúrgica dentro de una atención clínica';

-- =============================================================================
-- 9. SUBSISTEMA FINANZAS Y FACTURACIÓN (SUFI)
-- =============================================================================

-- Tarifario general de prestaciones, estancias y servicios
CREATE TABLE TARIFA_SERVICIO (
    TASE_CODIGO        INT             AUTO_INCREMENT NOT NULL COMMENT 'Identificador de la tarifa',
    TASE_CONCEPTO      VARCHAR(120)    NOT NULL COMMENT 'Nombre o concepto facturable de la prestación',
    TASE_TIPO          VARCHAR(30)     NOT NULL COMMENT 'Categoría (CONSULTA, ESTANCIA, EXAMEN, IMAGEN, CIRUGIA, MEDICAMENTO)',
    TASE_VALOR         DECIMAL(12,2)   NOT NULL COMMENT 'Valor monetario base de la tarifa',
    TASE_IMPUESTO      DECIMAL(5,2)    NULL DEFAULT 0.00 COMMENT 'Porcentaje de IVA aplicable',
    TASE_DESDE         DATE            NOT NULL COMMENT 'Fecha de entrada en vigencia',
    TASE_HASTA         DATE            NULL COMMENT 'Fecha de fin de vigencia',
    TASE_ESTADO        CHAR(1)         NOT NULL DEFAULT 'A' COMMENT 'Estado: A activo, I inactivo',
    PRIMARY KEY (TASE_CODIGO)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Tarifas vigentes utilizadas para el cálculo de cargos hospitalarios';

-- Cuentas hospitalarias del paciente
CREATE TABLE FCCUE_CUENT (
    FCCUE_CODIGO       INT             AUTO_INCREMENT NOT NULL COMMENT 'Identificador de la cuenta hospitalaria',
    PAPAC_CODIGO       INT             NOT NULL COMMENT 'Paciente titular de la cuenta',
    FCCUE_FECAPE       DATETIME        NOT NULL COMMENT 'Fecha y hora de apertura de la cuenta',
    FCCUE_TOTAL        DECIMAL(12,2)   NOT NULL DEFAULT 0.00 COMMENT 'Total acumulado de cargos activos',
    FCCUE_SALDO        DECIMAL(12,2)   NOT NULL DEFAULT 0.00 COMMENT 'Saldo pendiente de liquidación',
    FCCUE_ESTADO       VARCHAR(12)     NOT NULL DEFAULT 'ABIERTA' COMMENT 'Estado: ABIERTA, REVISADA, CERRADA, LIQUIDADA',
    PRIMARY KEY (FCCUE_CODIGO),
    CONSTRAINT FK_PACIENTE_CUENTA FOREIGN KEY (PAPAC_CODIGO) REFERENCES PAPAC_PACIE (PAPAC_CODIGO) ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Cuenta del paciente para liquidación de servicios hospitalarios';

-- Cargos facturables imputados a una cuenta
CREATE TABLE CARGO_FACTURABLE (
    FCCAR_CODIGO       INT             AUTO_INCREMENT NOT NULL COMMENT 'Identificador del cargo facturable',
    FCCUE_CODIGO       INT             NOT NULL COMMENT 'Cuenta hospitalaria asociada',
    TASE_CODIGO        INT             NULL COMMENT 'Tarifa de referencia aplicada',
    FCCAR_CONCEP       VARCHAR(100)    NOT NULL COMMENT 'Descripción del concepto facturado',
    FCCAR_CANTID       INT             NOT NULL DEFAULT 1 COMMENT 'Cantidad del servicio o insumo brindado',
    FCCAR_PREUNI       DECIMAL(10,2)   NOT NULL COMMENT 'Precio unitario aplicado',
    FCCAR_DESCUE       DECIMAL(10,2)   NOT NULL DEFAULT 0.00 COMMENT 'Descuento monetario aplicado',
    FCCAR_SUBTOT       DECIMAL(12,2)   NOT NULL COMMENT 'Subtotal neto del cargo (cantidad * precio - descuento)',
    FCCAR_FECHA        DATETIME        NOT NULL COMMENT 'Fecha y hora del cargo',
    FCCAR_ESTADO       VARCHAR(10)     NOT NULL DEFAULT 'ACTIVO' COMMENT 'Estado: ACTIVO o ANULADO',
    FCCAR_MOTANU       VARCHAR(200)    NULL COMMENT 'Motivo de anulación si aplica',
    PRIMARY KEY (FCCAR_CODIGO),
    CONSTRAINT FK_CUENTA_CARGO FOREIGN KEY (FCCUE_CODIGO) REFERENCES FCCUE_CUENT (FCCUE_CODIGO) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT FK_TARIFA_CARGO FOREIGN KEY (TASE_CODIGO) REFERENCES TARIFA_SERVICIO (TASE_CODIGO) ON UPDATE CASCADE ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Cargos facturables imputados a una cuenta';

-- Pagos y recibos de caja
CREATE TABLE FCPAG_PAGO (
    FCPAG_CODIGO       INT             AUTO_INCREMENT NOT NULL COMMENT 'Identificador del pago',
    FCCUE_CODIGO       INT             NOT NULL COMMENT 'Cuenta hospitalaria receptora del abono',
    FCPAG_NUMCOM       VARCHAR(20)     NOT NULL COMMENT 'Número de recibo o comprobante de pago',
    FCPAG_MONTO        DECIMAL(12,2)   NOT NULL COMMENT 'Monto económico abonado',
    FCPAG_FORMA        VARCHAR(15)     NOT NULL COMMENT 'Forma de pago: EFECTIVO, TARJETA, TRANSFERENCIA',
    FCPAG_FECHA        DATETIME        NOT NULL COMMENT 'Fecha y hora del cobro',
    AUD_AUTOR          CHAR(10)        NOT NULL COMMENT 'Cajero o personal responsable que recibió el pago',
    FCPAG_ESTADO       VARCHAR(10)     NOT NULL DEFAULT 'ACTIVO' COMMENT 'Estado: ACTIVO o ANULADO',
    FCPAG_MOTANU       VARCHAR(200)    NULL COMMENT 'Motivo de anulación en caso de reversa',
    PRIMARY KEY (FCPAG_CODIGO),
    UNIQUE KEY AK_FCPAG_NUMCOM (FCPAG_NUMCOM),
    CONSTRAINT FK_CUENTA_PAGO FOREIGN KEY (FCCUE_CODIGO) REFERENCES FCCUE_CUENT (FCCUE_CODIGO) ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Pagos y comprobantes de recaudación';

-- Comprobantes tributarios y facturas emitidas
CREATE TABLE FCDOC_DFAC (
    FCDOC_CODIGO       INT             AUTO_INCREMENT NOT NULL COMMENT 'Identificador del documento tributario',
    FCCUE_CODIGO       INT             NOT NULL COMMENT 'Cuenta hospitalaria liquidada',
    FCDOC_NUMDOC       VARCHAR(30)     NOT NULL COMMENT 'Número de factura SRI (ej: 001-001-000000123)',
    FCDOC_TIPO         VARCHAR(20)     NOT NULL DEFAULT 'FACTURA' COMMENT 'Tipo: FACTURA, NOTA_CREDITO, RECIBO',
    FCDOC_FECHA        DATETIME        NOT NULL COMMENT 'Fecha y hora de emisión del comprobante',
    FCDOC_SUBTOT       DECIMAL(12,2)   NOT NULL COMMENT 'Subtotal gravado/exento',
    FCDOC_IMP          DECIMAL(12,2)   NOT NULL DEFAULT 0.00 COMMENT 'Monto de IVA liquidado',
    FCDOC_TOTAL        DECIMAL(12,2)   NOT NULL COMMENT 'Importe total de la factura',
    FCDOC_ESTADO       VARCHAR(15)     NOT NULL DEFAULT 'EMITIDO' COMMENT 'EMITIDO, ANULADO, AUTORIZADO_SRI',
    FCDOC_URI          VARCHAR(500)    NULL COMMENT 'Ruta del archivo XML/PDF de la factura electrónica',
    PRIMARY KEY (FCDOC_CODIGO),
    UNIQUE KEY AK_FCDOC_NUMDOC (FCDOC_NUMDOC),
    CONSTRAINT FK_CUENTA_FACTURA FOREIGN KEY (FCCUE_CODIGO) REFERENCES FCCUE_CUENT (FCCUE_CODIGO) ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Documento de facturación o comprobante emitido para una cuenta hospitalaria';

-- Ajustes financieros y notas de crédito
CREATE TABLE FCAJU_AJUS (
    FCAJU_CODIGO       INT             AUTO_INCREMENT NOT NULL COMMENT 'Identificador del ajuste financiero',
    FCCUE_CODIGO       INT             NOT NULL COMMENT 'Cuenta hospitalaria sujeta al ajuste',
    PEPER_CODIGO       CHAR(10)        NULL COMMENT 'Autoridad o auditor que aprobó el ajuste',
    FCAJU_TIPO         VARCHAR(20)     NOT NULL COMMENT 'Tipo: DESCUENTO_AUDITORIA, REVERSA, EXONERACION',
    FCAJU_MONTO        DECIMAL(12,2)   NOT NULL COMMENT 'Monto ajustado',
    FCAJU_MOTIVO       VARCHAR(300)    NOT NULL COMMENT 'Motivo detallado del ajuste financiero',
    FCAJU_FECHA        DATETIME        NOT NULL COMMENT 'Fecha y hora de registro del ajuste',
    FCAJU_ESTADO       VARCHAR(15)     NOT NULL DEFAULT 'APROBADO' COMMENT 'SOLICITADO, APROBADO, RECHAZADO',
    PRIMARY KEY (FCAJU_CODIGO),
    CONSTRAINT FK_CUENTA_AJUSTE FOREIGN KEY (FCCUE_CODIGO) REFERENCES FCCUE_CUENT (FCCUE_CODIGO) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT FK_PERSONA_AJUSTE FOREIGN KEY (PEPER_CODIGO) REFERENCES PEPER_PERSO (PEPER_CODIGO) ON UPDATE CASCADE ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Anulación, devolución u otro ajuste monetario con motivo y trazabilidad';
