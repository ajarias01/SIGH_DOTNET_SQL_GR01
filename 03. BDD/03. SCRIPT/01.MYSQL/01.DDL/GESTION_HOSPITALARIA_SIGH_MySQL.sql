/*==============================================================*/
/* DBMS name:      MySQL 5.0 / 8.0                              */
/* Created on:     03/11/2026 12:45:00                          */
/* Sistema:        SIGH_GR01 (Gestión Hospitalaria)             */
/*==============================================================*/

set foreign_key_checks = 0;

drop table if exists FCAJU_AJUS;

drop table if exists FCDOC_DFAC;

drop table if exists FCPAG_PAGO;

drop table if exists CARGO_FACTURABLE;

drop table if exists FCCUE_CUENT;

drop table if exists TARIFA_SERVICIO;

drop table if exists QUPRO_PRQUI;

drop table if exists ASIGNACION_CAMA;

drop table if exists HOTRA_TRASL;

drop table if exists HOSPITALIZACION;

drop table if exists CAMA;

drop table if exists HABITACION;

drop table if exists UNIDAD_HOSPITALARIA;

drop table if exists FADIS_DISPE;

drop table if exists FAMOV_MOVIN;

drop table if exists FALOT_LOTE;

drop table if exists CLPRE_PRESC;

drop table if exists FAMED_MEDIC;

drop table if exists IMORD_ORDIM;

drop table if exists LARES_RESLA;

drop table if exists LAORD_ORDEN;

drop table if exists CLDOC_DOCLI;

drop table if exists CLALR_ALERG;

drop table if exists CLDIA_DIAGN;

drop table if exists CLATE_ATENC;

drop table if exists CITA;

drop table if exists AGENDA;

drop table if exists CONSULTORIO;

drop table if exists PAPAC_PACIE;

drop table if exists PEPRO_PROFE;

drop table if exists PEESP_ESPEC;

drop table if exists SEAUD_EVEN;

drop table if exists XEUXP_USUPE;

drop table if exists XEUSU_USUAR;

drop table if exists PEPER_PERSO;

drop table if exists PECAR_CARGO;

drop table if exists PEESC_CIVIL;

drop table if exists PEGEN_GENERO;

drop table if exists PEDEP_DEPAR;

drop table if exists XEOXP_OPCPE;

drop table if exists XEOPC_OPCIO;

drop table if exists XEPER_PERFI;

drop table if exists XESIS_SISTE;

drop table if exists XEEST_ESTAD;

set foreign_key_checks = 1;

/*==============================================================*/
/* Table: XEEST_ESTAD                                           */
/*==============================================================*/
create table XEEST_ESTAD
(
   XEEST_CODIGO       CHAR(1)         NOT NULL COMMENT 'Código del estado de la entidad',
   XEEST_DESCRI       VARCHAR(50)     NOT NULL COMMENT 'Descripción del estado',
   primary key (XEEST_CODIGO)
);

alter table XEEST_ESTAD comment 'Entidad utilizada para gestionar el estado de las diferentes tablas';

/*==============================================================*/
/* Table: XESIS_SISTE                                           */
/*==============================================================*/
create table XESIS_SISTE
(
   XESIS_CODIGO       CHAR(1)         NOT NULL COMMENT 'Código identificador del subsistema',
   XESIS_DESCRI       VARCHAR(50)     NOT NULL COMMENT 'Descripción del subsistema',
   primary key (XESIS_CODIGO)
);

alter table XESIS_SISTE comment 'Entidad utilizada para realizar la gestión de los diferentes subsistemas';

/*==============================================================*/
/* Table: XEPER_PERFI                                           */
/*==============================================================*/
create table XEPER_PERFI
(
   XEPER_CODIGO       CHAR(8)         NOT NULL COMMENT 'Código identificador del perfil',
   XEPER_DESCRI       VARCHAR(100)    NOT NULL COMMENT 'Descripción del perfil',
   XEPER_OBSER        TEXT            NULL COMMENT 'Observaciones del perfil',
   primary key (XEPER_CODIGO)
);

alter table XEPER_PERFI comment 'Entidad utilizada para realizar la gestión de los diferentes perfiles';

/*==============================================================*/
/* Table: XEOPC_OPCIO                                           */
/*==============================================================*/
create table XEOPC_OPCIO
(
   XEOPC_CODIGO       CHAR(3)         NOT NULL COMMENT 'Código de la opción del sistema',
   XESIS_CODIGO       CHAR(1)         NOT NULL COMMENT 'Código del subsistema al que pertenece',
   XEOPC_DESCRI       VARCHAR(100)    NOT NULL COMMENT 'Descripción o etiqueta de la opción de menú',
   primary key (XEOPC_CODIGO)
);

alter table XEOPC_OPCIO comment 'Entidad utilizada para realizar el registro de las diferentes opciones de un sistema';

/*==============================================================*/
/* Table: XEOXP_OPCPE                                           */
/*==============================================================*/
create table XEOXP_OPCPE
(
   XEOPC_CODIGO       CHAR(3)         NOT NULL COMMENT 'Código de la opción del sistema',
   XEPER_CODIGO       CHAR(8)         NOT NULL COMMENT 'Código del perfil asignado',
   XEOXP_FECASI       DATE            NOT NULL COMMENT 'Fecha de asignación de la opción al perfil',
   XEOXP_FECRET       DATE            NULL COMMENT 'Fecha de retiro de la opción',
   primary key (XEOPC_CODIGO, XEPER_CODIGO, XEOXP_FECASI)
);

alter table XEOXP_OPCPE comment 'Entidad utilizada para llevar el registro de las opciones que pertenecen a un perfil';

/*==============================================================*/
/* Table: PEDEP_DEPAR                                           */
/*==============================================================*/
create table PEDEP_DEPAR
(
   PEDEP_CODIGO       CHAR(3)         NOT NULL COMMENT 'Código del departamento',
   PEDEP_DESCRIP      VARCHAR(50)     NULL COMMENT 'Descripción del departamento',
   primary key (PEDEP_CODIGO)
);

alter table PEDEP_DEPAR comment 'Entidad utilizada para realizar la gestión de los diferentes departamentos de la empresa';

/*==============================================================*/
/* Table: PEGEN_GENERO                                          */
/*==============================================================*/
create table PEGEN_GENERO
(
   PEGEN_CODIGO       CHAR(1)         NOT NULL COMMENT 'Código del género (M, F, O)',
   PEGEN_DESCRI       VARCHAR(50)     NULL COMMENT 'Descripción del género',
   primary key (PEGEN_CODIGO)
);

alter table PEGEN_GENERO comment 'Entidad utilizada para gestionar el género de una persona';

/*==============================================================*/
/* Table: PEESC_CIVIL                                           */
/*==============================================================*/
create table PEESC_CIVIL
(
   PEESC_CODIGO       CHAR(1)         NOT NULL COMMENT 'Código del estado civil (S, C, D, V, U)',
   PEESC_DESCRI       VARCHAR(50)     NULL COMMENT 'Descripción del estado civil',
   primary key (PEESC_CODIGO)
);

alter table PEESC_CIVIL comment 'Entidad utilizada para la gestión del estado civil de una persona';

/*==============================================================*/
/* Table: PECAR_CARGO                                           */
/*==============================================================*/
create table PECAR_CARGO
(
   PEDEP_CODIGO       CHAR(3)         NOT NULL COMMENT 'Código del departamento asociado',
   PECAR_CODIGO       CHAR(3)         NOT NULL COMMENT 'Código del cargo dentro del departamento',
   PECAR_DESCRI       VARCHAR(50)     NULL COMMENT 'Descripción del cargo',
   primary key (PEDEP_CODIGO, PECAR_CODIGO)
);

alter table PECAR_CARGO comment 'Entidad utilizada para realizar la gestión de los cargos que pertenecerán a un departamento';

/*==============================================================*/
/* Table: PEPER_PERSO                                           */
/*==============================================================*/
create table PEPER_PERSO
(
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
   primary key (PEPER_CODIGO)
);

alter table PEPER_PERSO comment 'Entidad utilizada para gestionar las personas que harán uso del sistema';

/*==============================================================*/
/* Table: XEUSU_USUAR                                           */
/*==============================================================*/
create table XEUSU_USUAR
(
   XEUSU_PASWD        VARCHAR(64)     NOT NULL COMMENT 'Identificador de acceso o login/hash seguro',
   XEEST_CODIGO       CHAR(1)         NOT NULL COMMENT 'Estado del usuario (A activo, I inactivo, B bloqueado)',
   PEPER_CODIGO       CHAR(10)        NOT NULL COMMENT 'Persona asociada al usuario',
   XEUSU_FECCRE       DATETIME        NOT NULL COMMENT 'Fecha y hora de creación de la cuenta',
   XEUSU_FECMOD       DATETIME        NOT NULL COMMENT 'Fecha y hora de última modificación',
   XEUSU_PIEFIR       VARCHAR(100)    NOT NULL COMMENT 'Pie de firma digital o leyenda de responsabilidad',
   primary key (XEUSU_PASWD)
);

alter table XEUSU_USUAR comment 'Entidad relacionada para gestionar los usuarios que ingresan al sistema';

/*==============================================================*/
/* Table: XEUXP_USUPE                                           */
/*==============================================================*/
create table XEUXP_USUPE
(
   XEUSU_PASWD        VARCHAR(64)     NOT NULL COMMENT 'Usuario del sistema',
   XEPER_CODIGO       CHAR(8)         NOT NULL COMMENT 'Perfil asignado al usuario',
   XEUXP_FECASI       DATE            NOT NULL COMMENT 'Fecha de asignación del perfil al usuario',
   XEUXP_FECRET       DATE            NULL COMMENT 'Fecha de retiro del perfil',
   primary key (XEUSU_PASWD, XEPER_CODIGO, XEUXP_FECASI)
);

alter table XEUXP_USUPE comment 'Entidad utilizada para realizar el registro de los diferentes usuarios que pertenecen a un perfil';

/*==============================================================*/
/* Table: SEAUD_EVEN                                            */
/*==============================================================*/
create table SEAUD_EVEN
(
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
   primary key (SEAUD_CODIGO)
);

alter table SEAUD_EVEN comment 'Evento relevante de acceso u operación sensible, con actor, resultado y contexto';

/*==============================================================*/
/* Table: PEESP_ESPEC                                           */
/*==============================================================*/
create table PEESP_ESPEC
(
   PEESP_CODIGO       INT             AUTO_INCREMENT NOT NULL COMMENT 'Identificador de la especialidad',
   PEESP_NOMBRE       VARCHAR(60)     NOT NULL COMMENT 'Nombre de la especialidad médica',
   PEESP_ESTADO       CHAR(1)         NOT NULL DEFAULT 'A' COMMENT 'Estado de la especialidad: A activo, I inactivo',
   primary key (PEESP_CODIGO)
);

alter table PEESP_ESPEC comment 'Especialidades médicas';

/*==============================================================*/
/* Table: PEPRO_PROFE                                           */
/*==============================================================*/
create table PEPRO_PROFE
(
   PEPRO_CODIGO       INT             AUTO_INCREMENT NOT NULL COMMENT 'Identificador único del profesional de salud',
   PEPER_CODIGO       CHAR(10)        NOT NULL COMMENT 'Persona asociada al profesional',
   PEESP_CODIGO       INT             NOT NULL COMMENT 'Especialidad principal del profesional',
   PEPRO_REGPRO       VARCHAR(20)     NOT NULL COMMENT 'Número de registro del profesional de salud (ACESS/MSP)',
   PEPRO_AGENDA       TEXT            NULL COMMENT 'Configuración o disponibilidad general de agenda',
   primary key (PEPRO_CODIGO)
);

alter table PEPRO_PROFE comment 'Profesionales de salud';

/*==============================================================*/
/* Table: PAPAC_PACIE                                           */
/*==============================================================*/
create table PAPAC_PACIE
(
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
   primary key (PAPAC_CODIGO)
);

alter table PAPAC_PACIE comment 'Registro único de pacientes';

/*==============================================================*/
/* Table: CONSULTORIO                                           */
/*==============================================================*/
create table CONSULTORIO
(
   CONS_CODIGO        INT             AUTO_INCREMENT NOT NULL COMMENT 'Identificador del consultorio',
   CONS_NOMBRE        VARCHAR(80)     NOT NULL COMMENT 'Nombre o código visible del consultorio',
   CONS_UBICACION     VARCHAR(120)    NULL COMMENT 'Ubicación física (piso, ala, bloque)',
   CONS_ESTADO        CHAR(1)         NOT NULL DEFAULT 'A' COMMENT 'Estado del consultorio: A activo, I inactivo, M mantenimiento',
   primary key (CONS_CODIGO)
);

alter table CONSULTORIO comment 'Consultorios habilitados para la programación de agendas médicas';

/*==============================================================*/
/* Table: AGENDA                                                */
/*==============================================================*/
create table AGENDA
(
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
   primary key (AGEN_CODIGO)
);

alter table AGENDA comment 'Disponibilidad por profesional, especialidad, consultorio y periodo, requerida por la gestión de citas';

/*==============================================================*/
/* Table: CITA                                                  */
/*==============================================================*/
create table CITA
(
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
   primary key (PACIT_CODIGO)
);

alter table CITA comment 'Citas médicas';

/*==============================================================*/
/* Table: CLATE_ATENC                                           */
/*==============================================================*/
create table CLATE_ATENC
(
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
   primary key (CLATE_CODIGO)
);

alter table CLATE_ATENC comment 'Atenciones de consulta externa y emergencia';

/*==============================================================*/
/* Table: CLDIA_DIAGN                                           */
/*==============================================================*/
create table CLDIA_DIAGN
(
   CLDIA_CODIGO       INT             AUTO_INCREMENT NOT NULL COMMENT 'Identificador del diagnóstico',
   CLATE_CODIGO       INT             NOT NULL COMMENT 'Atención médica asociada',
   CLDIA_CIE10        VARCHAR(8)      NOT NULL COMMENT 'Código internacional CIE-10 (ej: J00, I10, E11)',
   CLDIA_DESCRI       VARCHAR(200)    NOT NULL COMMENT 'Descripción del diagnóstico clínico',
   CLDIA_TIPO         VARCHAR(12)     NOT NULL DEFAULT 'PRESUNTIVO' COMMENT 'Tipo: PRESUNTIVO o DEFINITIVO',
   primary key (CLDIA_CODIGO)
);

alter table CLDIA_DIAGN comment 'Diagnósticos CIE-10 de una atención';

/*==============================================================*/
/* Table: CLALR_ALERG                                           */
/*==============================================================*/
create table CLALR_ALERG
(
   CLALR_CODIGO       INT             AUTO_INCREMENT NOT NULL COMMENT 'Identificador de la alerta de alergia',
   PAPAC_CODIGO       INT             NOT NULL COMMENT 'Paciente afectado',
   CLALR_ALERGE       VARCHAR(12)     NOT NULL COMMENT 'Código o tipo del alérgeno (MEDICAMENTO, ALIMENTO, AMBIENTAL)',
   CLALR_REACCI       VARCHAR(300)    NOT NULL COMMENT 'Descripción de la reacción alérgica adversa',
   CLALR_VERIFI       TINYINT(1)      NOT NULL DEFAULT 1 COMMENT 'Estado de verificación médica (1=Verificada, 0=Sospecha)',
   CLALR_FECREG       DATETIME        NOT NULL COMMENT 'Fecha y hora de registro de la alergia',
   CLALR_FUENTE       VARCHAR(120)    NULL COMMENT 'Fuente de la información (Paciente, Familiar, Prueba)',
   primary key (CLALR_CODIGO)
);

alter table CLALR_ALERG comment 'Alergia o reacción adversa conocida del paciente, con fuente y estado de verificación';

/*==============================================================*/
/* Table: CLDOC_DOCLI                                           */
/*==============================================================*/
create table CLDOC_DOCLI
(
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
   primary key (CLDOC_CODIGO)
);

alter table CLDOC_DOCLI comment 'Documento adjunto a una atención clínica, con metadatos, integridad y trazabilidad';

/*==============================================================*/
/* Table: LAORD_ORDEN                                           */
/*==============================================================*/
create table LAORD_ORDEN
(
   LAORD_CODIGO       INT             AUTO_INCREMENT NOT NULL COMMENT 'Identificador de la orden de laboratorio',
   CLATE_CODIGO       INT             NOT NULL COMMENT 'Atención médica origen de la orden',
   LAORD_PRIORI       VARCHAR(10)     NOT NULL DEFAULT 'RUTINA' COMMENT 'Prioridad: RUTINA o URGENTE',
   LAORD_FECSOL       DATETIME        NOT NULL COMMENT 'Fecha y hora de la solicitud médica',
   LAORD_ESTADO       VARCHAR(20)     NOT NULL DEFAULT 'REGISTRADA' COMMENT 'REGISTRADA, MUESTRA_RECIBIDA, EN_PROCESO, VALIDADA, ANULADA',
   LAORD_CODMUE       VARCHAR(20)     NULL COMMENT 'Código de barras o identificador de muestra',
   LAORD_FECMUE       DATETIME        NULL COMMENT 'Fecha y hora de toma o recepción de muestra',
   LAORD_INCIDE       VARCHAR(300)    NULL COMMENT 'Incidencias con la muestra (hemólisis, coagulación, etc.)',
   LAORD_TIPMUE       VARCHAR(40)     NULL COMMENT 'Tipo de muestra biológica (SANGRE, ORINA, HECES, LCR)',
   primary key (LAORD_CODIGO)
);

alter table LAORD_ORDEN comment 'Órdenes de laboratorio clínico';

/*==============================================================*/
/* Table: LARES_RESLA                                           */
/*==============================================================*/
create table LARES_RESLA
(
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
   primary key (LADET_CODIGO)
);

alter table LARES_RESLA comment 'Resultado asociado a una prueba solicitada dentro de una orden de laboratorio, con estado y validación';

/*==============================================================*/
/* Table: IMORD_ORDIM                                           */
/*==============================================================*/
create table IMORD_ORDIM
(
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
   primary key (IMORD_CODIGO)
);

alter table IMORD_ORDIM comment 'Solicitud, ejecución e informe validado de un estudio de diagnóstico por imagen';

/*==============================================================*/
/* Table: FAMED_MEDIC                                           */
/*==============================================================*/
create table FAMED_MEDIC
(
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
   primary key (FAMED_CODIGO)
);

alter table FAMED_MEDIC comment 'Catálogo de medicamentos';

/*==============================================================*/
/* Table: CLPRE_PRESC                                           */
/*==============================================================*/
create table CLPRE_PRESC
(
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
   primary key (CLPRE_CODIGO)
);

alter table CLPRE_PRESC comment 'Prescripciones médicas';

/*==============================================================*/
/* Table: FALOT_LOTE                                            */
/*==============================================================*/
create table FALOT_LOTE
(
   FALOT_CODIGO       INT             AUTO_INCREMENT NOT NULL COMMENT 'Identificador del lote',
   FAMED_CODIGO       INT             NOT NULL COMMENT 'Medicamento al que corresponde el lote',
   FALOT_NUMERO       VARCHAR(30)     NOT NULL COMMENT 'Número o código del lote del fabricante',
   FALOT_FECCAD       DATE            NOT NULL COMMENT 'Fecha de caducidad del lote',
   FALOT_CANINI       INT             NOT NULL COMMENT 'Cantidad de unidades ingresadas inicialmente',
   FALOT_CANDIS       INT             NOT NULL COMMENT 'Cantidad de unidades actualmente disponibles',
   FALOT_FECING       DATETIME        NOT NULL COMMENT 'Fecha y hora de ingreso del lote al almacén',
   primary key (FALOT_CODIGO)
);

alter table FALOT_LOTE comment 'Lotes de medicamentos';

/*==============================================================*/
/* Table: FAMOV_MOVIN                                           */
/*==============================================================*/
create table FAMOV_MOVIN
(
   FAMOV_CODIGO       INT             AUTO_INCREMENT NOT NULL COMMENT 'Identificador del movimiento de inventario',
   FALOT_CODIGO       INT             NOT NULL COMMENT 'Lote afectado por el movimiento',
   FAMOV_TIPO         VARCHAR(12)     NOT NULL COMMENT 'Tipo: INGRESO, EGRESO, AJUSTE, DISPENSACION, DEVOLUCION',
   FAMOV_CANTID       INT             NOT NULL COMMENT 'Cantidad de unidades afectadas',
   FAMOV_MOTIVO       VARCHAR(200)    NULL COMMENT 'Motivo o justificación del movimiento',
   AUD_AUTOR          CHAR(10)        NOT NULL COMMENT 'Usuario o personal responsable del movimiento',
   FAMOV_FECHA        DATETIME        NOT NULL COMMENT 'Fecha y hora exacta del movimiento',
   primary key (FAMOV_CODIGO)
);

alter table FAMOV_MOVIN comment 'Movimientos de inventario';

/*==============================================================*/
/* Table: FADIS_DISPE                                           */
/*==============================================================*/
create table FADIS_DISPE
(
   FADIS_CODIGO       INT             AUTO_INCREMENT NOT NULL COMMENT 'Identificador de la dispensación',
   CLPRE_CODIGO       INT             NOT NULL COMMENT 'Prescripción médica atendida',
   FALOT_CODIGO       INT             NOT NULL COMMENT 'Lote de donde se extrajo el medicamento',
   FADIS_CANTID       INT             NOT NULL COMMENT 'Cantidad de unidades entregadas',
   AUD_AUTOR          CHAR(10)        NOT NULL COMMENT 'Farmacéutico que realizó la entrega',
   FADIS_FECHA        DATETIME        NOT NULL COMMENT 'Fecha y hora de la entrega del medicamento',
   primary key (FADIS_CODIGO)
);

alter table FADIS_DISPE comment 'Dispensación de medicamentos';

/*==============================================================*/
/* Table: UNIDAD_HOSPITALARIA                                   */
/*==============================================================*/
create table UNIDAD_HOSPITALARIA
(
   UNHO_CODIGO        INT             AUTO_INCREMENT NOT NULL COMMENT 'Identificador de la unidad hospitalaria',
   UNHO_NOMBRE        VARCHAR(100)    NOT NULL COMMENT 'Nombre de la unidad (ej: Medicina Interna, Cuidados Intensivos, Pediatría)',
   UNHO_TIPO          VARCHAR(50)     NULL COMMENT 'Tipo de servicio (HOSPITALIZACION, CUIDADOS_CRITICOS, EMERGENCIAS)',
   UNHO_ESTADO        CHAR(1)         NOT NULL DEFAULT 'A' COMMENT 'Estado de la unidad: A activa, I inactiva',
   primary key (UNHO_CODIGO)
);

alter table UNIDAD_HOSPITALARIA comment 'Servicio o unidad asistencial donde se encuentran las habitaciones y camas';

/*==============================================================*/
/* Table: HABITACION                                            */
/*==============================================================*/
create table HABITACION
(
   HABI_CODIGO        INT             AUTO_INCREMENT NOT NULL COMMENT 'Identificador de la habitación',
   UNHO_CODIGO        INT             NOT NULL COMMENT 'Unidad hospitalaria a la que pertenece',
   HABI_NUMERO        VARCHAR(20)     NOT NULL COMMENT 'Número o identificador visible de la habitación (ej: H-101)',
   HABI_ESTADO        CHAR(1)         NOT NULL DEFAULT 'A' COMMENT 'Estado de la habitación: A activa, I inactiva, M mantenimiento',
   primary key (HABI_CODIGO)
);

alter table HABITACION comment 'Habitación perteneciente a una unidad hospitalaria y contenedora de camas';

/*==============================================================*/
/* Table: CAMA                                                  */
/*==============================================================*/
create table CAMA
(
   HOCAM_CODIGO       INT             AUTO_INCREMENT NOT NULL COMMENT 'Identificador de la cama',
   HABI_CODIGO        INT             NOT NULL COMMENT 'Habitación donde está ubicada la cama',
   HOCAM_NUMERO       VARCHAR(20)     NOT NULL COMMENT 'Número de la cama (ej: CAMA-101-A)',
   HOCAM_ESTADO       VARCHAR(20)     NOT NULL DEFAULT 'DISPONIBLE' COMMENT 'DISPONIBLE, OCUPADA, LIMPIEZA, MANTENIMIENTO, RESERVADA',
   HOCAM_UNIDAD       VARCHAR(60)     NULL COMMENT 'Descripción o etiqueta de la unidad funcional',
   primary key (HOCAM_CODIGO)
);

alter table CAMA comment 'Camas hospitalarias';

/*==============================================================*/
/* Table: HOSPITALIZACION                                       */
/*==============================================================*/
create table HOSPITALIZACION
(
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
   primary key (HOHOS_CODIGO)
);

alter table HOSPITALIZACION comment 'Episodios de hospitalización de pacientes';

/*==============================================================*/
/* Table: HOTRA_TRASL                                           */
/*==============================================================*/
create table HOTRA_TRASL
(
   HOTRA_CODIGO       INT             AUTO_INCREMENT NOT NULL COMMENT 'Identificador del traslado de cama',
   HOHOS_CODIGO       INT             NOT NULL COMMENT 'Episodio de hospitalización asociado',
   HOCAM_ORIGEN       INT             NOT NULL COMMENT 'Cama de origen del paciente',
   HOCAM_DESTINO      INT             NOT NULL COMMENT 'Cama de destino del paciente',
   HOTRA_FECHA        DATETIME        NOT NULL COMMENT 'Fecha y hora en que se ejecutó el traslado',
   AUD_AUTOR          CHAR(10)        NOT NULL COMMENT 'Personal responsable del traslado',
   primary key (HOTRA_CODIGO)
);

alter table HOTRA_TRASL comment 'Traslados entre camas';

/*==============================================================*/
/* Table: ASIGNACION_CAMA                                       */
/*==============================================================*/
create table ASIGNACION_CAMA
(
   ASCA_CODIGO        INT             AUTO_INCREMENT NOT NULL COMMENT 'Identificador de la asignación de cama',
   HOHOS_CODIGO       INT             NOT NULL COMMENT 'Hospitalización asociada',
   HOCAM_CODIGO       INT             NOT NULL COMMENT 'Cama asignada',
   PEPER_CODIGO       CHAR(10)        NULL COMMENT 'Personal que realizó la asignación',
   ASCA_INICIO        DATETIME        NOT NULL COMMENT 'Fecha y hora de inicio de ocupación',
   ASCA_FIN           DATETIME        NULL COMMENT 'Fecha y hora de liberación de la cama',
   ASCA_MOTIVO        VARCHAR(200)    NULL COMMENT 'Motivo o detalle de la asignación',
   primary key (ASCA_CODIGO)
);

alter table ASIGNACION_CAMA comment 'Historial de ocupación de camas por hospitalización, con periodo y responsable';

/*==============================================================*/
/* Table: QUPRO_PRQUI                                           */
/*==============================================================*/
create table QUPRO_PRQUI
(
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
   primary key (QUPRO_CODIGO)
);

alter table QUPRO_PRQUI comment 'Programación y registro de una intervención quirúrgica dentro de una atención clínica';

/*==============================================================*/
/* Table: TARIFA_SERVICIO                                       */
/*==============================================================*/
create table TARIFA_SERVICIO
(
   TASE_CODIGO        INT             AUTO_INCREMENT NOT NULL COMMENT 'Identificador de la tarifa',
   TASE_CONCEPTO      VARCHAR(120)    NOT NULL COMMENT 'Nombre o concepto facturable de la prestación',
   TASE_TIPO          VARCHAR(30)     NOT NULL COMMENT 'Categoría (CONSULTA, ESTANCIA, EXAMEN, IMAGEN, CIRUGIA, MEDICAMENTO)',
   TASE_VALOR         DECIMAL(12,2)   NOT NULL COMMENT 'Valor monetario base de la tarifa',
   TASE_IMPUESTO      DECIMAL(5,2)    NULL DEFAULT 0.00 COMMENT 'Porcentaje de IVA aplicable',
   TASE_DESDE         DATE            NOT NULL COMMENT 'Fecha de entrada en vigencia',
   TASE_HASTA         DATE            NULL COMMENT 'Fecha de fin de vigencia',
   TASE_ESTADO        CHAR(1)         NOT NULL DEFAULT 'A' COMMENT 'Estado: A activo, I inactivo',
   primary key (TASE_CODIGO)
);

alter table TARIFA_SERVICIO comment 'Tarifas vigentes utilizadas para el cálculo de cargos hospitalarios';

/*==============================================================*/
/* Table: FCCUE_CUENT                                           */
/*==============================================================*/
create table FCCUE_CUENT
(
   FCCUE_CODIGO       INT             AUTO_INCREMENT NOT NULL COMMENT 'Identificador de la cuenta hospitalaria',
   PAPAC_CODIGO       INT             NOT NULL COMMENT 'Paciente titular de la cuenta',
   FCCUE_FECAPE       DATETIME        NOT NULL COMMENT 'Fecha y hora de apertura de la cuenta',
   FCCUE_TOTAL        DECIMAL(12,2)   NOT NULL DEFAULT 0.00 COMMENT 'Total acumulado de cargos activos',
   FCCUE_SALDO        DECIMAL(12,2)   NOT NULL DEFAULT 0.00 COMMENT 'Saldo pendiente de liquidación',
   FCCUE_ESTADO       VARCHAR(12)     NOT NULL DEFAULT 'ABIERTA' COMMENT 'Estado: ABIERTA, REVISADA, CERRADA, LIQUIDADA',
   primary key (FCCUE_CODIGO)
);

alter table FCCUE_CUENT comment 'Cuenta del paciente para liquidación de servicios hospitalarios';

/*==============================================================*/
/* Table: CARGO_FACTURABLE                                      */
/*==============================================================*/
create table CARGO_FACTURABLE
(
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
   primary key (FCCAR_CODIGO)
);

alter table CARGO_FACTURABLE comment 'Cargos facturables imputados a una cuenta';

/*==============================================================*/
/* Table: FCPAG_PAGO                                            */
/*==============================================================*/
create table FCPAG_PAGO
(
   FCPAG_CODIGO       INT             AUTO_INCREMENT NOT NULL COMMENT 'Identificador del pago',
   FCCUE_CODIGO       INT             NOT NULL COMMENT 'Cuenta hospitalaria receptora del abono',
   FCPAG_NUMCOM       VARCHAR(20)     NOT NULL COMMENT 'Número de recibo o comprobante de pago',
   FCPAG_MONTO        DECIMAL(12,2)   NOT NULL COMMENT 'Monto económico abonado',
   FCPAG_FORMA        VARCHAR(15)     NOT NULL COMMENT 'Forma de pago: EFECTIVO, TARJETA, TRANSFERENCIA',
   FCPAG_FECHA        DATETIME        NOT NULL COMMENT 'Fecha y hora del cobro',
   AUD_AUTOR          CHAR(10)        NOT NULL COMMENT 'Cajero o personal responsable que recibió el pago',
   FCPAG_ESTADO       VARCHAR(10)     NOT NULL DEFAULT 'ACTIVO' COMMENT 'Estado: ACTIVO o ANULADO',
   FCPAG_MOTANU       VARCHAR(200)    NULL COMMENT 'Motivo de anulación en caso de reversa',
   primary key (FCPAG_CODIGO)
);

alter table FCPAG_PAGO comment 'Pagos y comprobantes de recaudación';

/*==============================================================*/
/* Table: FCDOC_DFAC                                            */
/*==============================================================*/
create table FCDOC_DFAC
(
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
   primary key (FCDOC_CODIGO)
);

alter table FCDOC_DFAC comment 'Documento de facturación o comprobante emitido para una cuenta hospitalaria';

/*==============================================================*/
/* Table: FCAJU_AJUS                                            */
/*==============================================================*/
create table FCAJU_AJUS
(
   FCAJU_CODIGO       INT             AUTO_INCREMENT NOT NULL COMMENT 'Identificador del ajuste financiero',
   FCCUE_CODIGO       INT             NOT NULL COMMENT 'Cuenta hospitalaria sujeta al ajuste',
   PEPER_CODIGO       CHAR(10)        NULL COMMENT 'Autoridad o auditor que aprobó el ajuste',
   FCAJU_TIPO         VARCHAR(20)     NOT NULL COMMENT 'Tipo: DESCUENTO_AUDITORIA, REVERSA, EXONERACION',
   FCAJU_MONTO        DECIMAL(12,2)   NOT NULL COMMENT 'Monto ajustado',
   FCAJU_MOTIVO       VARCHAR(300)    NOT NULL COMMENT 'Motivo detallado del ajuste financiero',
   FCAJU_FECHA        DATETIME        NOT NULL COMMENT 'Fecha y hora de registro del ajuste',
   FCAJU_ESTADO       VARCHAR(15)     NOT NULL DEFAULT 'APROBADO' COMMENT 'SOLICITADO, APROBADO, RECHAZADO',
   primary key (FCAJU_CODIGO)
);

alter table FCAJU_AJUS comment 'Anulación, devolución u otro ajuste monetario con motivo y trazabilidad';

/*==============================================================*/
/* Foreign Key Constraints                                      */
/*==============================================================*/

alter table XEOPC_OPCIO add constraint FK_XR_XESIS_XEOPC foreign key (XESIS_CODIGO)
      references XESIS_SISTE (XESIS_CODIGO) on delete restrict on update restrict;

alter table XEOXP_OPCPE add constraint FK_XR_XEOPC_XEOXP foreign key (XEOPC_CODIGO)
      references XEOPC_OPCIO (XEOPC_CODIGO) on delete restrict on update restrict;

alter table XEOXP_OPCPE add constraint FK_XR_XEPER_XEOXP foreign key (XEPER_CODIGO)
      references XEPER_PERFI (XEPER_CODIGO) on delete restrict on update restrict;

alter table PECAR_CARGO add constraint FK_PR_PEDEP_PECAR foreign key (PEDEP_CODIGO)
      references PEDEP_DEPAR (PEDEP_CODIGO) on delete restrict on update restrict;

alter table PEPER_PERSO add constraint FK_PR_PEGEN_PEPER foreign key (PEGEN_CODIGO)
      references PEGEN_GENERO (PEGEN_CODIGO) on delete restrict on update restrict;

alter table PEPER_PERSO add constraint FK_PR_PEESC_PEPER foreign key (PEESC_CODIGO)
      references PEESC_CIVIL (PEESC_CODIGO) on delete restrict on update restrict;

alter table XEUSU_USUAR add constraint FK_XR_XEEST_XEUSU foreign key (XEEST_CODIGO)
      references XEEST_ESTAD (XEEST_CODIGO) on delete restrict on update restrict;

alter table XEUSU_USUAR add constraint FK_XR_PEPER_XEUSU foreign key (PEPER_CODIGO)
      references PEPER_PERSO (PEPER_CODIGO) on delete restrict on update restrict;

alter table XEUXP_USUPE add constraint FK_XR_XEUSU_XEUXP foreign key (XEUSU_PASWD)
      references XEUSU_USUAR (XEUSU_PASWD) on delete restrict on update restrict;

alter table XEUXP_USUPE add constraint FK_XR_XEPER_XEUXP foreign key (XEPER_CODIGO)
      references XEPER_PERFI (XEPER_CODIGO) on delete restrict on update restrict;

alter table SEAUD_EVEN add constraint FK_PERSONA_EVENTO_AUDITORIA foreign key (PEPER_CODIGO)
      references PEPER_PERSO (PEPER_CODIGO) on delete restrict on update restrict;

alter table PEPRO_PROFE add constraint FK_PERSONA_PROFESIONAL foreign key (PEPER_CODIGO)
      references PEPER_PERSO (PEPER_CODIGO) on delete restrict on update restrict;

alter table PEPRO_PROFE add constraint FK_ESPECIALIDAD_PROFESIONAL foreign key (PEESP_CODIGO)
      references PEESP_ESPEC (PEESP_CODIGO) on delete restrict on update restrict;

alter table AGENDA add constraint FK_PROFESIONAL_AGENDA foreign key (PEPRO_CODIGO)
      references PEPRO_PROFE (PEPRO_CODIGO) on delete restrict on update restrict;

alter table AGENDA add constraint FK_ESPECIALIDAD_AGENDA foreign key (PEESP_CODIGO)
      references PEESP_ESPEC (PEESP_CODIGO) on delete restrict on update restrict;

alter table AGENDA add constraint FK_CONSULTORIO_AGENDA foreign key (CONS_CODIGO)
      references CONSULTORIO (CONS_CODIGO) on delete restrict on update restrict;

alter table CITA add constraint FK_PACIENTE_CITA foreign key (PAPAC_CODIGO)
      references PAPAC_PACIE (PAPAC_CODIGO) on delete restrict on update restrict;

alter table CITA add constraint FK_PROFESIONAL_CITA foreign key (PEPRO_CODIGO)
      references PEPRO_PROFE (PEPRO_CODIGO) on delete restrict on update restrict;

alter table CITA add constraint FK_AGENDA_CITA foreign key (AGEN_CODIGO)
      references AGENDA (AGEN_CODIGO) on delete restrict on update restrict;

alter table CLATE_ATENC add constraint FK_PACIENTE_ATENCION foreign key (PAPAC_CODIGO)
      references PAPAC_PACIE (PAPAC_CODIGO) on delete restrict on update restrict;

alter table CLATE_ATENC add constraint FK_PROFESIONAL_ATENCION foreign key (PEPRO_CODIGO)
      references PEPRO_PROFE (PEPRO_CODIGO) on delete restrict on update restrict;

alter table CLATE_ATENC add constraint FK_CITA_ATENCION foreign key (PACIT_CODIGO)
      references CITA (PACIT_CODIGO) on delete restrict on update restrict;

alter table CLDIA_DIAGN add constraint FK_ATENCION_DIAGNOSTICO foreign key (CLATE_CODIGO)
      references CLATE_ATENC (CLATE_CODIGO) on delete restrict on update restrict;

alter table CLALR_ALERG add constraint FK_PACIENTE_ALERGIA foreign key (PAPAC_CODIGO)
      references PAPAC_PACIE (PAPAC_CODIGO) on delete restrict on update restrict;

alter table CLDOC_DOCLI add constraint FK_ATENCION_DOCLI foreign key (CLATE_CODIGO)
      references CLATE_ATENC (CLATE_CODIGO) on delete restrict on update restrict;

alter table CLDOC_DOCLI add constraint FK_PERSONA_DOCLI foreign key (PEPER_CODIGO)
      references PEPER_PERSO (PEPER_CODIGO) on delete restrict on update restrict;

alter table CLDOC_DOCLI add constraint FK_DOCLI_PREDEC foreign key (CLDOC_PREDEC)
      references CLDOC_DOCLI (CLDOC_CODIGO) on delete restrict on update restrict;

alter table LAORD_ORDEN add constraint FK_ATENCION_ORDENLAB foreign key (CLATE_CODIGO)
      references CLATE_ATENC (CLATE_CODIGO) on delete restrict on update restrict;

alter table LARES_RESLA add constraint FK_ORDEN_DETALLE_LAB foreign key (LAORD_CODIGO)
      references LAORD_ORDEN (LAORD_CODIGO) on delete restrict on update restrict;

alter table IMORD_ORDIM add constraint FK_ATENCION_ORDEN_IMAGEN foreign key (CLATE_CODIGO)
      references CLATE_ATENC (CLATE_CODIGO) on delete restrict on update restrict;

alter table IMORD_ORDIM add constraint FK_PROFESIONAL_ORDEN_IMAGEN foreign key (PEPRO_CODIGO)
      references PEPRO_PROFE (PEPRO_CODIGO) on delete restrict on update restrict;

alter table IMORD_ORDIM add constraint FK_PROFESIONAL_INFORME_IMAGEN foreign key (IMINF_CODINF)
      references PEPRO_PROFE (PEPRO_CODIGO) on delete restrict on update restrict;

alter table CLPRE_PRESC add constraint FK_ATENCION_PRESC foreign key (CLATE_CODIGO)
      references CLATE_ATENC (CLATE_CODIGO) on delete restrict on update restrict;

alter table CLPRE_PRESC add constraint FK_MEDICAMENTO_PRESC foreign key (FAMED_CODIGO)
      references FAMED_MEDIC (FAMED_CODIGO) on delete restrict on update restrict;

alter table FALOT_LOTE add constraint FK_MEDICAMENTO_LOTE foreign key (FAMED_CODIGO)
      references FAMED_MEDIC (FAMED_CODIGO) on delete restrict on update restrict;

alter table FAMOV_MOVIN add constraint FK_LOTE_MOVIMIENTO foreign key (FALOT_CODIGO)
      references FALOT_LOTE (FALOT_CODIGO) on delete restrict on update restrict;

alter table FADIS_DISPE add constraint FK_PRESC_DISPENSACION foreign key (CLPRE_CODIGO)
      references CLPRE_PRESC (CLPRE_CODIGO) on delete restrict on update restrict;

alter table FADIS_DISPE add constraint FK_LOTE_DISPENSACION foreign key (FALOT_CODIGO)
      references FALOT_LOTE (FALOT_CODIGO) on delete restrict on update restrict;

alter table HABITACION add constraint FK_UNIDAD_HABITACION foreign key (UNHO_CODIGO)
      references UNIDAD_HOSPITALARIA (UNHO_CODIGO) on delete restrict on update restrict;

alter table CAMA add constraint FK_HABITACION_CAMA foreign key (HABI_CODIGO)
      references HABITACION (HABI_CODIGO) on delete restrict on update restrict;

alter table HOSPITALIZACION add constraint FK_PACIENTE_HOSPITALIZACION foreign key (PAPAC_CODIGO)
      references PAPAC_PACIE (PAPAC_CODIGO) on delete restrict on update restrict;

alter table HOSPITALIZACION add constraint FK_PROFESIONAL_HOSPITALIZACION foreign key (PEPRO_CODIGO)
      references PEPRO_PROFE (PEPRO_CODIGO) on delete restrict on update restrict;

alter table HOSPITALIZACION add constraint FK_CAMA_HOSPITALIZACION foreign key (HOCAM_CODIGO)
      references CAMA (HOCAM_CODIGO) on delete restrict on update restrict;

alter table HOSPITALIZACION add constraint FK_ATENCION_HOSPITALIZACION foreign key (CLATE_CODIGO)
      references CLATE_ATENC (CLATE_CODIGO) on delete restrict on update restrict;

alter table HOTRA_TRASL add constraint FK_HOSP_TRASLADO foreign key (HOHOS_CODIGO)
      references HOSPITALIZACION (HOHOS_CODIGO) on delete restrict on update restrict;

alter table HOTRA_TRASL add constraint FK_CAMA_ORIGEN_TRASLADO foreign key (HOCAM_ORIGEN)
      references CAMA (HOCAM_CODIGO) on delete restrict on update restrict;

alter table HOTRA_TRASL add constraint FK_CAMA_DESTINO_TRASLADO foreign key (HOCAM_DESTINO)
      references CAMA (HOCAM_CODIGO) on delete restrict on update restrict;

alter table ASIGNACION_CAMA add constraint FK_HOSP_ASIGNACION foreign key (HOHOS_CODIGO)
      references HOSPITALIZACION (HOHOS_CODIGO) on delete restrict on update restrict;

alter table ASIGNACION_CAMA add constraint FK_CAMA_ASIGNACION foreign key (HOCAM_CODIGO)
      references CAMA (HOCAM_CODIGO) on delete restrict on update restrict;

alter table ASIGNACION_CAMA add constraint FK_PERSONA_ASIGNACION foreign key (PEPER_CODIGO)
      references PEPER_PERSO (PEPER_CODIGO) on delete restrict on update restrict;

alter table QUPRO_PRQUI add constraint FK_ATENCION_QUIROFANO foreign key (CLATE_CODIGO)
      references CLATE_ATENC (CLATE_CODIGO) on delete restrict on update restrict;

alter table QUPRO_PRQUI add constraint FK_CIRUJANO_QUIROFANO foreign key (PEPRO_CODIGO)
      references PEPRO_PROFE (PEPRO_CODIGO) on delete restrict on update restrict;

alter table FCCUE_CUENT add constraint FK_PACIENTE_CUENTA foreign key (PAPAC_CODIGO)
      references PAPAC_PACIE (PAPAC_CODIGO) on delete restrict on update restrict;

alter table CARGO_FACTURABLE add constraint FK_CUENTA_CARGO foreign key (FCCUE_CODIGO)
      references FCCUE_CUENT (FCCUE_CODIGO) on delete restrict on update restrict;

alter table CARGO_FACTURABLE add constraint FK_TARIFA_CARGO foreign key (TASE_CODIGO)
      references TARIFA_SERVICIO (TASE_CODIGO) on delete restrict on update restrict;

alter table FCPAG_PAGO add constraint FK_CUENTA_PAGO foreign key (FCCUE_CODIGO)
      references FCCUE_CUENT (FCCUE_CODIGO) on delete restrict on update restrict;

alter table FCDOC_DFAC add constraint FK_CUENTA_FACTURA foreign key (FCCUE_CODIGO)
      references FCCUE_CUENT (FCCUE_CODIGO) on delete restrict on update restrict;

alter table FCAJU_AJUS add constraint FK_CUENTA_AJUSTE foreign key (FCCUE_CODIGO)
      references FCCUE_CUENT (FCCUE_CODIGO) on delete restrict on update restrict;

alter table FCAJU_AJUS add constraint FK_PERSONA_AJUSTE foreign key (PEPER_CODIGO)
      references PEPER_PERSO (PEPER_CODIGO) on delete restrict on update restrict;
