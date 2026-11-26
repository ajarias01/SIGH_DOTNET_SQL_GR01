/*==============================================================*/
/* DBMS name:      Microsoft SQL Server 2016                    */
/* Created on:     03/11/2026 12:45:00                          */
/* Sistema:        SIGH_GR01 (Gestión Hospitalaria)             */
/*==============================================================*/

if exists (select 1 from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('XEOPC_OPCIO') and o.name = 'FK_XR_XESIS_XEOPC')
alter table XEOPC_OPCIO
   drop constraint FK_XR_XESIS_XEOPC
go

if exists (select 1 from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('XEOXP_OPCPE') and o.name = 'FK_XR_XEOPC_XEOXP')
alter table XEOXP_OPCPE
   drop constraint FK_XR_XEOPC_XEOXP
go

if exists (select 1 from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('XEOXP_OPCPE') and o.name = 'FK_XR_XEPER_XEOXP')
alter table XEOXP_OPCPE
   drop constraint FK_XR_XEPER_XEOXP
go

if exists (select 1 from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('PECAR_CARGO') and o.name = 'FK_PR_PEDEP_PECAR')
alter table PECAR_CARGO
   drop constraint FK_PR_PEDEP_PECAR
go

if exists (select 1 from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('PEPER_PERSO') and o.name = 'FK_PR_PEGEN_PEPER')
alter table PEPER_PERSO
   drop constraint FK_PR_PEGEN_PEPER
go

if exists (select 1 from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('PEPER_PERSO') and o.name = 'FK_PR_PEESC_PEPER')
alter table PEPER_PERSO
   drop constraint FK_PR_PEESC_PEPER
go

if exists (select 1 from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('XEUSU_USUAR') and o.name = 'FK_XR_XEEST_XEUSU')
alter table XEUSU_USUAR
   drop constraint FK_XR_XEEST_XEUSU
go

if exists (select 1 from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('XEUSU_USUAR') and o.name = 'FK_XR_PEPER_XEUSU')
alter table XEUSU_USUAR
   drop constraint FK_XR_PEPER_XEUSU
go

if exists (select 1 from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('XEUXP_USUPE') and o.name = 'FK_XR_XEUSU_XEUXP')
alter table XEUXP_USUPE
   drop constraint FK_XR_XEUSU_XEUXP
go

if exists (select 1 from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('XEUXP_USUPE') and o.name = 'FK_XR_XEPER_XEUXP')
alter table XEUXP_USUPE
   drop constraint FK_XR_XEPER_XEUXP
go

if exists (select 1 from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('SEAUD_EVEN') and o.name = 'FK_PERSONA_EVENTO_AUDITORIA')
alter table SEAUD_EVEN
   drop constraint FK_PERSONA_EVENTO_AUDITORIA
go

if exists (select 1 from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('PEPRO_PROFE') and o.name = 'FK_PERSONA_PROFESIONAL')
alter table PEPRO_PROFE
   drop constraint FK_PERSONA_PROFESIONAL
go

if exists (select 1 from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('PEPRO_PROFE') and o.name = 'FK_ESPECIALIDAD_PROFESIONAL')
alter table PEPRO_PROFE
   drop constraint FK_ESPECIALIDAD_PROFESIONAL
go

if exists (select 1 from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('AGENDA') and o.name = 'FK_PROFESIONAL_AGENDA')
alter table AGENDA
   drop constraint FK_PROFESIONAL_AGENDA
go

if exists (select 1 from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('AGENDA') and o.name = 'FK_ESPECIALIDAD_AGENDA')
alter table AGENDA
   drop constraint FK_ESPECIALIDAD_AGENDA
go

if exists (select 1 from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('AGENDA') and o.name = 'FK_CONSULTORIO_AGENDA')
alter table AGENDA
   drop constraint FK_CONSULTORIO_AGENDA
go

if exists (select 1 from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('CITA') and o.name = 'FK_PACIENTE_CITA')
alter table CITA
   drop constraint FK_PACIENTE_CITA
go

if exists (select 1 from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('CITA') and o.name = 'FK_PROFESIONAL_CITA')
alter table CITA
   drop constraint FK_PROFESIONAL_CITA
go

if exists (select 1 from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('CITA') and o.name = 'FK_AGENDA_CITA')
alter table CITA
   drop constraint FK_AGENDA_CITA
go

if exists (select 1 from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('CLATE_ATENC') and o.name = 'FK_PACIENTE_ATENCION')
alter table CLATE_ATENC
   drop constraint FK_PACIENTE_ATENCION
go

if exists (select 1 from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('CLATE_ATENC') and o.name = 'FK_PROFESIONAL_ATENCION')
alter table CLATE_ATENC
   drop constraint FK_PROFESIONAL_ATENCION
go

if exists (select 1 from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('CLATE_ATENC') and o.name = 'FK_CITA_ATENCION')
alter table CLATE_ATENC
   drop constraint FK_CITA_ATENCION
go

if exists (select 1 from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('CLDIA_DIAGN') and o.name = 'FK_ATENCION_DIAGNOSTICO')
alter table CLDIA_DIAGN
   drop constraint FK_ATENCION_DIAGNOSTICO
go

if exists (select 1 from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('CLALR_ALERG') and o.name = 'FK_PACIENTE_ALERGIA')
alter table CLALR_ALERG
   drop constraint FK_PACIENTE_ALERGIA
go

if exists (select 1 from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('CLDOC_DOCLI') and o.name = 'FK_ATENCION_DOCLI')
alter table CLDOC_DOCLI
   drop constraint FK_ATENCION_DOCLI
go

if exists (select 1 from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('CLDOC_DOCLI') and o.name = 'FK_PERSONA_DOCLI')
alter table CLDOC_DOCLI
   drop constraint FK_PERSONA_DOCLI
go

if exists (select 1 from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('CLDOC_DOCLI') and o.name = 'FK_DOCLI_PREDEC')
alter table CLDOC_DOCLI
   drop constraint FK_DOCLI_PREDEC
go

if exists (select 1 from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('LAORD_ORDEN') and o.name = 'FK_ATENCION_ORDENLAB')
alter table LAORD_ORDEN
   drop constraint FK_ATENCION_ORDENLAB
go

if exists (select 1 from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('LARES_RESLA') and o.name = 'FK_ORDEN_DETALLE_LAB')
alter table LARES_RESLA
   drop constraint FK_ORDEN_DETALLE_LAB
go

if exists (select 1 from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('IMORD_ORDIM') and o.name = 'FK_ATENCION_ORDEN_IMAGEN')
alter table IMORD_ORDIM
   drop constraint FK_ATENCION_ORDEN_IMAGEN
go

if exists (select 1 from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('IMORD_ORDIM') and o.name = 'FK_PROFESIONAL_ORDEN_IMAGEN')
alter table IMORD_ORDIM
   drop constraint FK_PROFESIONAL_ORDEN_IMAGEN
go

if exists (select 1 from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('IMORD_ORDIM') and o.name = 'FK_PROFESIONAL_INFORME_IMAGEN')
alter table IMORD_ORDIM
   drop constraint FK_PROFESIONAL_INFORME_IMAGEN
go

if exists (select 1 from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('CLPRE_PRESC') and o.name = 'FK_ATENCION_PRESC')
alter table CLPRE_PRESC
   drop constraint FK_ATENCION_PRESC
go

if exists (select 1 from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('CLPRE_PRESC') and o.name = 'FK_MEDICAMENTO_PRESC')
alter table CLPRE_PRESC
   drop constraint FK_MEDICAMENTO_PRESC
go

if exists (select 1 from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('FALOT_LOTE') and o.name = 'FK_MEDICAMENTO_LOTE')
alter table FALOT_LOTE
   drop constraint FK_MEDICAMENTO_LOTE
go

if exists (select 1 from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('FAMOV_MOVIN') and o.name = 'FK_LOTE_MOVIMIENTO')
alter table FAMOV_MOVIN
   drop constraint FK_LOTE_MOVIMIENTO
go

if exists (select 1 from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('FADIS_DISPE') and o.name = 'FK_PRESC_DISPENSACION')
alter table FADIS_DISPE
   drop constraint FK_PRESC_DISPENSACION
go

if exists (select 1 from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('FADIS_DISPE') and o.name = 'FK_LOTE_DISPENSACION')
alter table FADIS_DISPE
   drop constraint FK_LOTE_DISPENSACION
go

if exists (select 1 from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('HABITACION') and o.name = 'FK_UNIDAD_HABITACION')
alter table HABITACION
   drop constraint FK_UNIDAD_HABITACION
go

if exists (select 1 from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('CAMA') and o.name = 'FK_HABITACION_CAMA')
alter table CAMA
   drop constraint FK_HABITACION_CAMA
go

if exists (select 1 from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('HOSPITALIZACION') and o.name = 'FK_PACIENTE_HOSPITALIZACION')
alter table HOSPITALIZACION
   drop constraint FK_PACIENTE_HOSPITALIZACION
go

if exists (select 1 from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('HOSPITALIZACION') and o.name = 'FK_PROFESIONAL_HOSPITALIZACION')
alter table HOSPITALIZACION
   drop constraint FK_PROFESIONAL_HOSPITALIZACION
go

if exists (select 1 from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('HOSPITALIZACION') and o.name = 'FK_CAMA_HOSPITALIZACION')
alter table HOSPITALIZACION
   drop constraint FK_CAMA_HOSPITALIZACION
go

if exists (select 1 from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('HOSPITALIZACION') and o.name = 'FK_ATENCION_HOSPITALIZACION')
alter table HOSPITALIZACION
   drop constraint FK_ATENCION_HOSPITALIZACION
go

if exists (select 1 from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('HOTRA_TRASL') and o.name = 'FK_HOSP_TRASLADO')
alter table HOTRA_TRASL
   drop constraint FK_HOSP_TRASLADO
go

if exists (select 1 from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('HOTRA_TRASL') and o.name = 'FK_CAMA_ORIGEN_TRASLADO')
alter table HOTRA_TRASL
   drop constraint FK_CAMA_ORIGEN_TRASLADO
go

if exists (select 1 from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('HOTRA_TRASL') and o.name = 'FK_CAMA_DESTINO_TRASLADO')
alter table HOTRA_TRASL
   drop constraint FK_CAMA_DESTINO_TRASLADO
go

if exists (select 1 from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('ASIGNACION_CAMA') and o.name = 'FK_HOSP_ASIGNACION')
alter table ASIGNACION_CAMA
   drop constraint FK_HOSP_ASIGNACION
go

if exists (select 1 from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('ASIGNACION_CAMA') and o.name = 'FK_CAMA_ASIGNACION')
alter table ASIGNACION_CAMA
   drop constraint FK_CAMA_ASIGNACION
go

if exists (select 1 from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('ASIGNACION_CAMA') and o.name = 'FK_PERSONA_ASIGNACION')
alter table ASIGNACION_CAMA
   drop constraint FK_PERSONA_ASIGNACION
go

if exists (select 1 from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('QUPRO_PRQUI') and o.name = 'FK_ATENCION_QUIROFANO')
alter table QUPRO_PRQUI
   drop constraint FK_ATENCION_QUIROFANO
go

if exists (select 1 from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('QUPRO_PRQUI') and o.name = 'FK_CIRUJANO_QUIROFANO')
alter table QUPRO_PRQUI
   drop constraint FK_CIRUJANO_QUIROFANO
go

if exists (select 1 from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('FCCUE_CUENT') and o.name = 'FK_PACIENTE_CUENTA')
alter table FCCUE_CUENT
   drop constraint FK_PACIENTE_CUENTA
go

if exists (select 1 from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('CARGO_FACTURABLE') and o.name = 'FK_CUENTA_CARGO')
alter table CARGO_FACTURABLE
   drop constraint FK_CUENTA_CARGO
go

if exists (select 1 from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('CARGO_FACTURABLE') and o.name = 'FK_TARIFA_CARGO')
alter table CARGO_FACTURABLE
   drop constraint FK_TARIFA_CARGO
go

if exists (select 1 from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('FCPAG_PAGO') and o.name = 'FK_CUENTA_PAGO')
alter table FCPAG_PAGO
   drop constraint FK_CUENTA_PAGO
go

if exists (select 1 from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('FCDOC_DFAC') and o.name = 'FK_CUENTA_FACTURA')
alter table FCDOC_DFAC
   drop constraint FK_CUENTA_FACTURA
go

if exists (select 1 from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('FCAJU_AJUS') and o.name = 'FK_CUENTA_AJUSTE')
alter table FCAJU_AJUS
   drop constraint FK_CUENTA_AJUSTE
go

if exists (select 1 from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('FCAJU_AJUS') and o.name = 'FK_PERSONA_AJUSTE')
alter table FCAJU_AJUS
   drop constraint FK_PERSONA_AJUSTE
go

if exists (select 1 from sysobjects where id = object_id('FCAJU_AJUS') and type = 'U')
   drop table FCAJU_AJUS
go

if exists (select 1 from sysobjects where id = object_id('FCDOC_DFAC') and type = 'U')
   drop table FCDOC_DFAC
go

if exists (select 1 from sysobjects where id = object_id('FCPAG_PAGO') and type = 'U')
   drop table FCPAG_PAGO
go

if exists (select 1 from sysobjects where id = object_id('CARGO_FACTURABLE') and type = 'U')
   drop table CARGO_FACTURABLE
go

if exists (select 1 from sysobjects where id = object_id('FCCUE_CUENT') and type = 'U')
   drop table FCCUE_CUENT
go

if exists (select 1 from sysobjects where id = object_id('TARIFA_SERVICIO') and type = 'U')
   drop table TARIFA_SERVICIO
go

if exists (select 1 from sysobjects where id = object_id('QUPRO_PRQUI') and type = 'U')
   drop table QUPRO_PRQUI
go

if exists (select 1 from sysobjects where id = object_id('ASIGNACION_CAMA') and type = 'U')
   drop table ASIGNACION_CAMA
go

if exists (select 1 from sysobjects where id = object_id('HOTRA_TRASL') and type = 'U')
   drop table HOTRA_TRASL
go

if exists (select 1 from sysobjects where id = object_id('HOSPITALIZACION') and type = 'U')
   drop table HOSPITALIZACION
go

if exists (select 1 from sysobjects where id = object_id('CAMA') and type = 'U')
   drop table CAMA
go

if exists (select 1 from sysobjects where id = object_id('HABITACION') and type = 'U')
   drop table HABITACION
go

if exists (select 1 from sysobjects where id = object_id('UNIDAD_HOSPITALARIA') and type = 'U')
   drop table UNIDAD_HOSPITALARIA
go

if exists (select 1 from sysobjects where id = object_id('FADIS_DISPE') and type = 'U')
   drop table FADIS_DISPE
go

if exists (select 1 from sysobjects where id = object_id('FAMOV_MOVIN') and type = 'U')
   drop table FAMOV_MOVIN
go

if exists (select 1 from sysobjects where id = object_id('FALOT_LOTE') and type = 'U')
   drop table FALOT_LOTE
go

if exists (select 1 from sysobjects where id = object_id('CLPRE_PRESC') and type = 'U')
   drop table CLPRE_PRESC
go

if exists (select 1 from sysobjects where id = object_id('FAMED_MEDIC') and type = 'U')
   drop table FAMED_MEDIC
go

if exists (select 1 from sysobjects where id = object_id('IMORD_ORDIM') and type = 'U')
   drop table IMORD_ORDIM
go

if exists (select 1 from sysobjects where id = object_id('LARES_RESLA') and type = 'U')
   drop table LARES_RESLA
go

if exists (select 1 from sysobjects where id = object_id('LAORD_ORDEN') and type = 'U')
   drop table LAORD_ORDEN
go

if exists (select 1 from sysobjects where id = object_id('CLDOC_DOCLI') and type = 'U')
   drop table CLDOC_DOCLI
go

if exists (select 1 from sysobjects where id = object_id('CLALR_ALERG') and type = 'U')
   drop table CLALR_ALERG
go

if exists (select 1 from sysobjects where id = object_id('CLDIA_DIAGN') and type = 'U')
   drop table CLDIA_DIAGN
go

if exists (select 1 from sysobjects where id = object_id('CLATE_ATENC') and type = 'U')
   drop table CLATE_ATENC
go

if exists (select 1 from sysobjects where id = object_id('CITA') and type = 'U')
   drop table CITA
go

if exists (select 1 from sysobjects where id = object_id('AGENDA') and type = 'U')
   drop table AGENDA
go

if exists (select 1 from sysobjects where id = object_id('CONSULTORIO') and type = 'U')
   drop table CONSULTORIO
go

if exists (select 1 from sysobjects where id = object_id('PAPAC_PACIE') and type = 'U')
   drop table PAPAC_PACIE
go

if exists (select 1 from sysobjects where id = object_id('PEPRO_PROFE') and type = 'U')
   drop table PEPRO_PROFE
go

if exists (select 1 from sysobjects where id = object_id('PEESP_ESPEC') and type = 'U')
   drop table PEESP_ESPEC
go

if exists (select 1 from sysobjects where id = object_id('SEAUD_EVEN') and type = 'U')
   drop table SEAUD_EVEN
go

if exists (select 1 from sysobjects where id = object_id('XEUXP_USUPE') and type = 'U')
   drop table XEUXP_USUPE
go

if exists (select 1 from sysobjects where id = object_id('XEUSU_USUAR') and type = 'U')
   drop table XEUSU_USUAR
go

if exists (select 1 from sysobjects where id = object_id('PEPER_PERSO') and type = 'U')
   drop table PEPER_PERSO
go

if exists (select 1 from sysobjects where id = object_id('PECAR_CARGO') and type = 'U')
   drop table PECAR_CARGO
go

if exists (select 1 from sysobjects where id = object_id('PEESC_CIVIL') and type = 'U')
   drop table PEESC_CIVIL
go

if exists (select 1 from sysobjects where id = object_id('PEGEN_GENERO') and type = 'U')
   drop table PEGEN_GENERO
go

if exists (select 1 from sysobjects where id = object_id('PEDEP_DEPAR') and type = 'U')
   drop table PEDEP_DEPAR
go

if exists (select 1 from sysobjects where id = object_id('XEOXP_OPCPE') and type = 'U')
   drop table XEOXP_OPCPE
go

if exists (select 1 from sysobjects where id = object_id('XEOPC_OPCIO') and type = 'U')
   drop table XEOPC_OPCIO
go

if exists (select 1 from sysobjects where id = object_id('XEPER_PERFI') and type = 'U')
   drop table XEPER_PERFI
go

if exists (select 1 from sysobjects where id = object_id('XESIS_SISTE') and type = 'U')
   drop table XESIS_SISTE
go

if exists (select 1 from sysobjects where id = object_id('XEEST_ESTAD') and type = 'U')
   drop table XEEST_ESTAD
go

/*==============================================================*/
/* Table: XEEST_ESTAD                                           */
/*==============================================================*/
create table XEEST_ESTAD (
   XEEST_CODIGO       CHAR(1)         NOT NULL,
   XEEST_DESCRI       VARCHAR(50)     NOT NULL,
   constraint PK_XEEST_ESTAD primary key (XEEST_CODIGO)
)
go

/*==============================================================*/
/* Table: XESIS_SISTE                                           */
/*==============================================================*/
create table XESIS_SISTE (
   XESIS_CODIGO       CHAR(1)         NOT NULL,
   XESIS_DESCRI       VARCHAR(50)     NOT NULL,
   constraint PK_XESIS_SISTE primary key (XESIS_CODIGO)
)
go

/*==============================================================*/
/* Table: XEPER_PERFI                                           */
/*==============================================================*/
create table XEPER_PERFI (
   XEPER_CODIGO       CHAR(8)         NOT NULL,
   XEPER_DESCRI       VARCHAR(100)    NOT NULL,
   XEPER_OBSER        TEXT            NULL,
   constraint PK_XEPER_PERFI primary key (XEPER_CODIGO)
)
go

/*==============================================================*/
/* Table: XEOPC_OPCIO                                           */
/*==============================================================*/
create table XEOPC_OPCIO (
   XEOPC_CODIGO       CHAR(3)         NOT NULL,
   XESIS_CODIGO       CHAR(1)         NOT NULL,
   XEOPC_DESCRI       VARCHAR(100)    NOT NULL,
   constraint PK_XEOPC_OPCIO primary key (XEOPC_CODIGO)
)
go

/*==============================================================*/
/* Table: XEOXP_OPCPE                                           */
/*==============================================================*/
create table XEOXP_OPCPE (
   XEOPC_CODIGO       CHAR(3)         NOT NULL,
   XEPER_CODIGO       CHAR(8)         NOT NULL,
   XEOXP_FECASI       DATE            NOT NULL,
   XEOXP_FECRET       DATE            NULL,
   constraint PK_XEOXP_OPCPE primary key (XEOPC_CODIGO, XEPER_CODIGO, XEOXP_FECASI)
)
go

/*==============================================================*/
/* Table: PEDEP_DEPAR                                           */
/*==============================================================*/
create table PEDEP_DEPAR (
   PEDEP_CODIGO       CHAR(3)         NOT NULL,
   PEDEP_DESCRIP      VARCHAR(50)     NULL,
   constraint PK_PEDEP_DEPAR primary key (PEDEP_CODIGO)
)
go

/*==============================================================*/
/* Table: PEGEN_GENERO                                          */
/*==============================================================*/
create table PEGEN_GENERO (
   PEGEN_CODIGO       CHAR(1)         NOT NULL,
   PEGEN_DESCRI       VARCHAR(50)     NULL,
   constraint PK_PEGEN_GENERO primary key (PEGEN_CODIGO)
)
go

/*==============================================================*/
/* Table: PEESC_CIVIL                                           */
/*==============================================================*/
create table PEESC_CIVIL (
   PEESC_CODIGO       CHAR(1)         NOT NULL,
   PEESC_DESCRI       VARCHAR(50)     NULL,
   constraint PK_PEESC_CIVIL primary key (PEESC_CODIGO)
)
go

/*==============================================================*/
/* Table: PECAR_CARGO                                           */
/*==============================================================*/
create table PECAR_CARGO (
   PEDEP_CODIGO       CHAR(3)         NOT NULL,
   PECAR_CODIGO       CHAR(3)         NOT NULL,
   PECAR_DESCRI       VARCHAR(50)     NULL,
   constraint PK_PECAR_CARGO primary key (PEDEP_CODIGO, PECAR_CODIGO)
)
go

/*==============================================================*/
/* Table: PEPER_PERSO                                           */
/*==============================================================*/
create table PEPER_PERSO (
   PEPER_CODIGO       CHAR(10)        NOT NULL,
   PEGEN_CODIGO       CHAR(1)         NOT NULL,
   PEESC_CODIGO       CHAR(1)         NOT NULL,
   PEPER_APELLI       VARCHAR(50)     NOT NULL,
   PEPER_NOMBRE       VARCHAR(50)     NOT NULL,
   PEPER_FECNAC       DATE            NOT NULL,
   PEPER_CEDULA       VARCHAR(10)     NULL,
   PEPER_PASAPO       VARCHAR(15)     NULL,
   PEPER_EMAIL        VARCHAR(50)     NULL,
   PEPER_CARFAM       NUMERIC(2,0)    NOT NULL DEFAULT 0,
   PEPER_FOTO         VARCHAR(100)    NOT NULL DEFAULT 'default.png',
   PEPER_DISCAPACIDAD CHAR(1)         NOT NULL DEFAULT 'N',
   constraint PK_PEPER_PERSO primary key (PEPER_CODIGO)
)
go

/*==============================================================*/
/* Table: XEUSU_USUAR                                           */
/*==============================================================*/
create table XEUSU_USUAR (
   XEUSU_PASWD        VARCHAR(64)     NOT NULL,
   XEEST_CODIGO       CHAR(1)         NOT NULL,
   PEPER_CODIGO       CHAR(10)        NOT NULL,
   XEUSU_FECCRE       DATETIME        NOT NULL,
   XEUSU_FECMOD       DATETIME        NOT NULL,
   XEUSU_PIEFIR       VARCHAR(100)    NOT NULL,
   constraint PK_XEUSU_USUAR primary key (XEUSU_PASWD)
)
go

/*==============================================================*/
/* Table: XEUXP_USUPE                                           */
/*==============================================================*/
create table XEUXP_USUPE (
   XEUSU_PASWD        VARCHAR(64)     NOT NULL,
   XEPER_CODIGO       CHAR(8)         NOT NULL,
   XEUXP_FECASI       DATE            NOT NULL,
   XEUXP_FECRET       DATE            NULL,
   constraint PK_XEUXP_USUPE primary key (XEUSU_PASWD, XEPER_CODIGO, XEUXP_FECASI)
)
go

/*==============================================================*/
/* Table: SEAUD_EVEN                                            */
/*==============================================================*/
create table SEAUD_EVEN (
   SEAUD_CODIGO       INT             IDENTITY NOT NULL,
   PEPER_CODIGO       CHAR(10)        NULL,
   SEAUD_FECHA        DATETIME        NOT NULL,
   SEAUD_MODULO       VARCHAR(30)     NOT NULL,
   SEAUD_ACCION       VARCHAR(50)     NOT NULL,
   SEAUD_ENTID        VARCHAR(60)     NULL,
   SEAUD_IDOBJ        VARCHAR(60)     NULL,
   SEAUD_RESULT       VARCHAR(20)     NOT NULL,
   SEAUD_JUSTIF       VARCHAR(300)    NULL,
   SEAUD_ORIGEN       VARCHAR(45)     NULL,
   SEAUD_DETALL       TEXT            NULL,
   constraint PK_SEAUD_EVEN primary key (SEAUD_CODIGO)
)
go

/*==============================================================*/
/* Table: PEESP_ESPEC                                           */
/*==============================================================*/
create table PEESP_ESPEC (
   PEESP_CODIGO       INT             IDENTITY NOT NULL,
   PEESP_NOMBRE       VARCHAR(60)     NOT NULL,
   PEESP_ESTADO       CHAR(1)         NOT NULL DEFAULT 'A',
   constraint PK_PEESP_ESPEC primary key (PEESP_CODIGO)
)
go

/*==============================================================*/
/* Table: PEPRO_PROFE                                           */
/*==============================================================*/
create table PEPRO_PROFE (
   PEPRO_CODIGO       INT             IDENTITY NOT NULL,
   PEPER_CODIGO       CHAR(10)        NOT NULL,
   PEESP_CODIGO       INT             NOT NULL,
   PEPRO_REGPRO       VARCHAR(20)     NOT NULL,
   PEPRO_AGENDA       TEXT            NULL,
   constraint PK_PEPRO_PROFE primary key (PEPRO_CODIGO)
)
go

/*==============================================================*/
/* Table: PAPAC_PACIE                                           */
/*==============================================================*/
create table PAPAC_PACIE (
   PAPAC_CODIGO       INT             IDENTITY NOT NULL,
   PAPAC_NUMHC        VARCHAR(12)     NOT NULL,
   PAPAC_TIPDOC       CHAR(1)         NOT NULL,
   PAPAC_NUMDOC       VARCHAR(20)     NULL,
   PAPAC_NOMBRE       VARCHAR(60)     NOT NULL,
   PAPAC_APELLI       VARCHAR(60)     NOT NULL,
   PAPAC_FECNAC       DATE            NULL,
   PAPAC_SEXO         CHAR(1)         NOT NULL,
   PAPAC_DIRECC       VARCHAR(200)    NULL,
   PAPAC_TELEF        VARCHAR(15)     NULL,
   PAPAC_EMAIL        VARCHAR(100)    NULL,
   PAPAC_CONEME       VARCHAR(100)    NULL,
   PAPAC_TELEME       VARCHAR(15)     NULL,
   PAPAC_PROVIS       TINYINT(1)      NOT NULL DEFAULT 0,
   PAPAC_ESTADO       CHAR(1)         NOT NULL DEFAULT 'A',
   PAPAC_FECREG       DATETIME        NOT NULL,
   constraint PK_PAPAC_PACIE primary key (PAPAC_CODIGO)
)
go

/*==============================================================*/
/* Table: CONSULTORIO                                           */
/*==============================================================*/
create table CONSULTORIO (
   CONS_CODIGO        INT             IDENTITY NOT NULL,
   CONS_NOMBRE        VARCHAR(80)     NOT NULL,
   CONS_UBICACION     VARCHAR(120)    NULL,
   CONS_ESTADO        CHAR(1)         NOT NULL DEFAULT 'A',
   constraint PK_CONSULTORIO primary key (CONS_CODIGO)
)
go

/*==============================================================*/
/* Table: AGENDA                                                */
/*==============================================================*/
create table AGENDA (
   AGEN_CODIGO        INT             IDENTITY NOT NULL,
   PEPRO_CODIGO       INT             NOT NULL,
   PEESP_CODIGO       INT             NOT NULL,
   CONS_CODIGO        INT             NOT NULL,
   AGEN_DIASEM        TINYINT         NOT NULL,
   AGEN_HORINI        TIME            NOT NULL,
   AGEN_HORFIN        TIME            NOT NULL,
   AGEN_DURACION      SMALLINT        NOT NULL DEFAULT 20,
   AGEN_DESDE         DATE            NOT NULL,
   AGEN_HASTA         DATE            NULL,
   AGEN_ESTADO        CHAR(1)         NOT NULL DEFAULT 'A',
   constraint PK_AGENDA primary key (AGEN_CODIGO)
)
go

/*==============================================================*/
/* Table: CITA                                                  */
/*==============================================================*/
create table CITA (
   PACIT_CODIGO       INT             IDENTITY NOT NULL,
   PAPAC_CODIGO       INT             NOT NULL,
   PEPRO_CODIGO       INT             NOT NULL,
   AGEN_CODIGO        INT             NULL,
   PACIT_FECHA        DATE            NOT NULL,
   PACIT_HORA         TIME            NOT NULL,
   PACIT_MOTIVO       VARCHAR(200)    NOT NULL,
   PACIT_ESTADO       VARCHAR(15)     NOT NULL DEFAULT 'PROGRAMADA',
   PACIT_HORLLE       DATETIME        NULL,
   PACIT_MOTCAM       VARCHAR(200)    NULL,
   PACIT_FECREG       DATETIME        NOT NULL,
   PACIT_CONSUL       VARCHAR(80)     NULL,
   constraint PK_CITA primary key (PACIT_CODIGO)
)
go

/*==============================================================*/
/* Table: CLATE_ATENC                                           */
/*==============================================================*/
create table CLATE_ATENC (
   CLATE_CODIGO       INT             IDENTITY NOT NULL,
   PAPAC_CODIGO       INT             NOT NULL,
   PEPRO_CODIGO       INT             NOT NULL,
   PACIT_CODIGO       INT             NULL,
   CLATE_TIPO         VARCHAR(12)     NOT NULL,
   CLATE_FECHA        DATETIME        NOT NULL,
   CLATE_MOTIVO       VARCHAR(300)    NOT NULL,
   CLATE_SINTOM       TEXT            NULL,
   CLATE_EXPLOR       TEXT            NULL,
   CLATE_INDICA       TEXT            NULL,
   CLATE_TRIAJE       TINYINT         NULL,
   CLATE_DISPOS       VARCHAR(20)     NULL,
   CLATE_PROREV       DATE            NULL,
   CLATE_ESTADO       VARCHAR(15)     NOT NULL DEFAULT 'EN_ELABORACION',
   CLATE_FECFIN       DATETIME        NULL,
   CLATE_PRESIS       INT             NULL,
   CLATE_PREDIA       INT             NULL,
   CLATE_FCARD        INT             NULL,
   CLATE_FRESP        INT             NULL,
   CLATE_TEMP         DECIMAL(5,2)    NULL,
   CLATE_SATUR        DECIMAL(5,2)    NULL,
   CLATE_PESO         DECIMAL(6,2)    NULL,
   CLATE_TALLA        DECIMAL(5,2)    NULL,
   constraint PK_CLATE_ATENC primary key (CLATE_CODIGO)
)
go

/*==============================================================*/
/* Table: CLDIA_DIAGN                                           */
/*==============================================================*/
create table CLDIA_DIAGN (
   CLDIA_CODIGO       INT             IDENTITY NOT NULL,
   CLATE_CODIGO       INT             NOT NULL,
   CLDIA_CIE10        VARCHAR(8)      NOT NULL,
   CLDIA_DESCRI       VARCHAR(200)    NOT NULL,
   CLDIA_TIPO         VARCHAR(12)     NOT NULL DEFAULT 'PRESUNTIVO',
   constraint PK_CLDIA_DIAGN primary key (CLDIA_CODIGO)
)
go

/*==============================================================*/
/* Table: CLALR_ALERG                                           */
/*==============================================================*/
create table CLALR_ALERG (
   CLALR_CODIGO       INT             IDENTITY NOT NULL,
   PAPAC_CODIGO       INT             NOT NULL,
   CLALR_ALERGE       VARCHAR(12)     NOT NULL,
   CLALR_REACCI       VARCHAR(300)    NOT NULL,
   CLALR_VERIFI       TINYINT(1)      NOT NULL DEFAULT 1,
   CLALR_FECREG       DATETIME        NOT NULL,
   CLALR_FUENTE       VARCHAR(120)    NULL,
   constraint PK_CLALR_ALERG primary key (CLALR_CODIGO)
)
go

/*==============================================================*/
/* Table: CLDOC_DOCLI                                           */
/*==============================================================*/
create table CLDOC_DOCLI (
   CLDOC_CODIGO       INT             IDENTITY NOT NULL,
   CLATE_CODIGO       INT             NOT NULL,
   PEPER_CODIGO       CHAR(10)        NULL,
   CLDOC_PREDEC       INT             NULL,
   CLDOC_TIPO         VARCHAR(30)     NOT NULL,
   CLDOC_TITULO       VARCHAR(150)    NOT NULL,
   CLDOC_URI          VARCHAR(500)    NOT NULL,
   CLDOC_HASH         CHAR(64)        NOT NULL,
   CLDOC_FECHA        DATETIME        NOT NULL,
   CLDOC_CONTEN       TEXT            NULL,
   constraint PK_CLDOC_DOCLI primary key (CLDOC_CODIGO)
)
go

/*==============================================================*/
/* Table: LAORD_ORDEN                                           */
/*==============================================================*/
create table LAORD_ORDEN (
   LAORD_CODIGO       INT             IDENTITY NOT NULL,
   CLATE_CODIGO       INT             NOT NULL,
   LAORD_PRIORI       VARCHAR(10)     NOT NULL DEFAULT 'RUTINA',
   LAORD_FECSOL       DATETIME        NOT NULL,
   LAORD_ESTADO       VARCHAR(20)     NOT NULL DEFAULT 'REGISTRADA',
   LAORD_CODMUE       VARCHAR(20)     NULL,
   LAORD_FECMUE       DATETIME        NULL,
   LAORD_INCIDE       VARCHAR(300)    NULL,
   LAORD_TIPMUE       VARCHAR(40)     NULL,
   constraint PK_LAORD_ORDEN primary key (LAORD_CODIGO)
)
go

/*==============================================================*/
/* Table: LARES_RESLA                                           */
/*==============================================================*/
create table LARES_RESLA (
   LADET_CODIGO       INT             IDENTITY NOT NULL,
   LAORD_CODIGO       INT             NOT NULL,
   LADET_RESULT       VARCHAR(100)    NULL,
   LADET_CRITIC       TINYINT(1)      NOT NULL DEFAULT 0,
   LADET_VERSIO       INT             NOT NULL DEFAULT 1,
   LADET_ESTADO       VARCHAR(15)     NOT NULL DEFAULT 'PENDIENTE',
   LADET_FECRES       DATETIME        NULL,
   AUD_AUTOR          CHAR(10)        NULL,
   LADET_FECVAL       DATETIME        NULL,
   LARES_NOMEXA       VARCHAR(120)    NULL,
   constraint PK_LARES_RESLA primary key (LADET_CODIGO)
)
go

/*==============================================================*/
/* Table: IMORD_ORDIM                                           */
/*==============================================================*/
create table IMORD_ORDIM (
   IMORD_CODIGO       INT             IDENTITY NOT NULL,
   CLATE_CODIGO       INT             NOT NULL,
   PEPRO_CODIGO       INT             NOT NULL,
   IMINF_CODINF       INT             NULL,
   IMORD_TIPO         VARCHAR(50)     NOT NULL,
   IMORD_REGION       VARCHAR(50)     NULL,
   IMORD_PRIORI       VARCHAR(15)     NOT NULL DEFAULT 'RUTINA',
   IMORD_INDIC        TEXT            NOT NULL,
   IMORD_FECSOL       DATETIME        NOT NULL,
   IMORD_FECPRO       DATETIME        NULL,
   IMORD_ESTADO       VARCHAR(15)     NOT NULL DEFAULT 'SOLICITADA',
   IMINF_HALLA        TEXT            NULL,
   IMINF_CONCL        TEXT            NULL,
   IMINF_FECVAL       DATETIME        NULL,
   IMINF_ESTADO       VARCHAR(15)     NULL,
   IMINF_URI          VARCHAR(500)    NULL,
   constraint PK_IMORD_ORDIM primary key (IMORD_CODIGO)
)
go

/*==============================================================*/
/* Table: FAMED_MEDIC                                           */
/*==============================================================*/
create table FAMED_MEDIC (
   FAMED_CODIGO       INT             IDENTITY NOT NULL,
   FAMED_CODIGOM      VARCHAR(20)     NOT NULL,
   FAMED_NOMBRE       VARCHAR(100)    NOT NULL,
   FAMED_PRIACT       VARCHAR(100)    NOT NULL,
   FAMED_PRESEN       VARCHAR(50)     NOT NULL,
   FAMED_CONCEN       VARCHAR(30)     NOT NULL,
   FAMED_UNIDAD       VARCHAR(15)     NOT NULL,
   FAMED_STKMIN       INT             NOT NULL DEFAULT 10,
   FAMED_PRECIO       DECIMAL(10,2)   NOT NULL DEFAULT 0.00,
   FAMED_ESTADO       CHAR(1)         NOT NULL DEFAULT 'A',
   constraint PK_FAMED_MEDIC primary key (FAMED_CODIGO)
)
go

/*==============================================================*/
/* Table: CLPRE_PRESC                                           */
/*==============================================================*/
create table CLPRE_PRESC (
   CLPRE_CODIGO       INT             IDENTITY NOT NULL,
   CLATE_CODIGO       INT             NOT NULL,
   FAMED_CODIGO       INT             NOT NULL,
   CLPRE_DOSIS        VARCHAR(40)     NOT NULL,
   CLPRE_VIA          VARCHAR(20)     NOT NULL,
   CLPRE_FRECUE       VARCHAR(40)     NOT NULL,
   CLPRE_DURACI       VARCHAR(40)     NOT NULL,
   CLPRE_CANTID       INT             NOT NULL,
   CLPRE_CANDIS       INT             NOT NULL DEFAULT 0,
   CLPRE_INSTRU       VARCHAR(300)    NULL,
   CLPRE_JUSTIF       VARCHAR(300)    NULL,
   CLPRE_ESTADO       VARCHAR(15)     NOT NULL DEFAULT 'VIGENTE',
   constraint PK_CLPRE_PRESC primary key (CLPRE_CODIGO)
)
go

/*==============================================================*/
/* Table: FALOT_LOTE                                            */
/*==============================================================*/
create table FALOT_LOTE (
   FALOT_CODIGO       INT             IDENTITY NOT NULL,
   FAMED_CODIGO       INT             NOT NULL,
   FALOT_NUMERO       VARCHAR(30)     NOT NULL,
   FALOT_FECCAD       DATE            NOT NULL,
   FALOT_CANINI       INT             NOT NULL,
   FALOT_CANDIS       INT             NOT NULL,
   FALOT_FECING       DATETIME        NOT NULL,
   constraint PK_FALOT_LOTE primary key (FALOT_CODIGO)
)
go

/*==============================================================*/
/* Table: FAMOV_MOVIN                                           */
/*==============================================================*/
create table FAMOV_MOVIN (
   FAMOV_CODIGO       INT             IDENTITY NOT NULL,
   FALOT_CODIGO       INT             NOT NULL,
   FAMOV_TIPO         VARCHAR(12)     NOT NULL,
   FAMOV_CANTID       INT             NOT NULL,
   FAMOV_MOTIVO       VARCHAR(200)    NULL,
   AUD_AUTOR          CHAR(10)        NOT NULL,
   FAMOV_FECHA        DATETIME        NOT NULL,
   constraint PK_FAMOV_MOVIN primary key (FAMOV_CODIGO)
)
go

/*==============================================================*/
/* Table: FADIS_DISPE                                           */
/*==============================================================*/
create table FADIS_DISPE (
   FADIS_CODIGO       INT             IDENTITY NOT NULL,
   CLPRE_CODIGO       INT             NOT NULL,
   FALOT_CODIGO       INT             NOT NULL,
   FADIS_CANTID       INT             NOT NULL,
   AUD_AUTOR          CHAR(10)        NOT NULL,
   FADIS_FECHA        DATETIME        NOT NULL,
   constraint PK_FADIS_DISPE primary key (FADIS_CODIGO)
)
go

/*==============================================================*/
/* Table: UNIDAD_HOSPITALARIA                                   */
/*==============================================================*/
create table UNIDAD_HOSPITALARIA (
   UNHO_CODIGO        INT             IDENTITY NOT NULL,
   UNHO_NOMBRE        VARCHAR(100)    NOT NULL,
   UNHO_TIPO          VARCHAR(50)     NULL,
   UNHO_ESTADO        CHAR(1)         NOT NULL DEFAULT 'A',
   constraint PK_UNIDAD_HOSPITALARIA primary key (UNHO_CODIGO)
)
go

/*==============================================================*/
/* Table: HABITACION                                            */
/*==============================================================*/
create table HABITACION (
   HABI_CODIGO        INT             IDENTITY NOT NULL,
   UNHO_CODIGO        INT             NOT NULL,
   HABI_NUMERO        VARCHAR(20)     NOT NULL,
   HABI_ESTADO        CHAR(1)         NOT NULL DEFAULT 'A',
   constraint PK_HABITACION primary key (HABI_CODIGO)
)
go

/*==============================================================*/
/* Table: CAMA                                                  */
/*==============================================================*/
create table CAMA (
   HOCAM_CODIGO       INT             IDENTITY NOT NULL,
   HABI_CODIGO        INT             NOT NULL,
   HOCAM_NUMERO       VARCHAR(20)     NOT NULL,
   HOCAM_ESTADO       VARCHAR(20)     NOT NULL DEFAULT 'DISPONIBLE',
   HOCAM_UNIDAD       VARCHAR(60)     NULL,
   constraint PK_CAMA primary key (HOCAM_CODIGO)
)
go

/*==============================================================*/
/* Table: HOSPITALIZACION                                       */
/*==============================================================*/
create table HOSPITALIZACION (
   HOHOS_CODIGO       INT             IDENTITY NOT NULL,
   PAPAC_CODIGO       INT             NOT NULL,
   PEPRO_CODIGO       INT             NOT NULL,
   HOCAM_CODIGO       INT             NOT NULL,
   CLATE_CODIGO       INT             NULL,
   HOHOS_FECING       DATETIME        NOT NULL,
   HOHOS_DIAING       VARCHAR(200)    NOT NULL,
   HOHOS_ALTMED       DATETIME        NULL,
   HOHOS_ALTADM       DATETIME        NULL,
   HOHOS_ESTADO       VARCHAR(15)     NOT NULL DEFAULT 'ACTIVA',
   constraint PK_HOSPITALIZACION primary key (HOHOS_CODIGO)
)
go

/*==============================================================*/
/* Table: HOTRA_TRASL                                           */
/*==============================================================*/
create table HOTRA_TRASL (
   HOTRA_CODIGO       INT             IDENTITY NOT NULL,
   HOHOS_CODIGO       INT             NOT NULL,
   HOCAM_ORIGEN       INT             NOT NULL,
   HOCAM_DESTINO      INT             NOT NULL,
   HOTRA_FECHA        DATETIME        NOT NULL,
   AUD_AUTOR          CHAR(10)        NOT NULL,
   constraint PK_HOTRA_TRASL primary key (HOTRA_CODIGO)
)
go

/*==============================================================*/
/* Table: ASIGNACION_CAMA                                       */
/*==============================================================*/
create table ASIGNACION_CAMA (
   ASCA_CODIGO        INT             IDENTITY NOT NULL,
   HOHOS_CODIGO       INT             NOT NULL,
   HOCAM_CODIGO       INT             NOT NULL,
   PEPER_CODIGO       CHAR(10)        NULL,
   ASCA_INICIO        DATETIME        NOT NULL,
   ASCA_FIN           DATETIME        NULL,
   ASCA_MOTIVO        VARCHAR(200)    NULL,
   constraint PK_ASIGNACION_CAMA primary key (ASCA_CODIGO)
)
go

/*==============================================================*/
/* Table: QUPRO_PRQUI                                           */
/*==============================================================*/
create table QUPRO_PRQUI (
   QUPRO_CODIGO       INT             IDENTITY NOT NULL,
   CLATE_CODIGO       INT             NOT NULL,
   PEPRO_CODIGO       INT             NOT NULL,
   QUPRO_NOMBRE       VARCHAR(150)    NOT NULL,
   QUPRO_FECPRO       DATETIME        NOT NULL,
   QUPRO_INICIO       DATETIME        NULL,
   QUPRO_FIN          DATETIME        NULL,
   QUPRO_SALA         VARCHAR(50)     NULL,
   QUPRO_ANEST        VARCHAR(100)    NULL,
   QUPRO_HALLA        TEXT            NULL,
   QUPRO_ESTADO       VARCHAR(15)     NOT NULL DEFAULT 'PROGRAMADO',
   QUPRO_EQUIPO       TEXT            NULL,
   QUPRO_CHECK        TEXT            NULL,
   constraint PK_QUPRO_PRQUI primary key (QUPRO_CODIGO)
)
go

/*==============================================================*/
/* Table: TARIFA_SERVICIO                                       */
/*==============================================================*/
create table TARIFA_SERVICIO (
   TASE_CODIGO        INT             IDENTITY NOT NULL,
   TASE_CONCEPTO      VARCHAR(120)    NOT NULL,
   TASE_TIPO          VARCHAR(30)     NOT NULL,
   TASE_VALOR         DECIMAL(12,2)   NOT NULL,
   TASE_IMPUESTO      DECIMAL(5,2)    NULL DEFAULT 0.00,
   TASE_DESDE         DATE            NOT NULL,
   TASE_HASTA         DATE            NULL,
   TASE_ESTADO        CHAR(1)         NOT NULL DEFAULT 'A',
   constraint PK_TARIFA_SERVICIO primary key (TASE_CODIGO)
)
go

/*==============================================================*/
/* Table: FCCUE_CUENT                                           */
/*==============================================================*/
create table FCCUE_CUENT (
   FCCUE_CODIGO       INT             IDENTITY NOT NULL,
   PAPAC_CODIGO       INT             NOT NULL,
   FCCUE_FECAPE       DATETIME        NOT NULL,
   FCCUE_TOTAL        DECIMAL(12,2)   NOT NULL DEFAULT 0.00,
   FCCUE_SALDO        DECIMAL(12,2)   NOT NULL DEFAULT 0.00,
   FCCUE_ESTADO       VARCHAR(12)     NOT NULL DEFAULT 'ABIERTA',
   constraint PK_FCCUE_CUENT primary key (FCCUE_CODIGO)
)
go

/*==============================================================*/
/* Table: CARGO_FACTURABLE                                      */
/*==============================================================*/
create table CARGO_FACTURABLE (
   FCCAR_CODIGO       INT             IDENTITY NOT NULL,
   FCCUE_CODIGO       INT             NOT NULL,
   TASE_CODIGO        INT             NULL,
   FCCAR_CONCEP       VARCHAR(100)    NOT NULL,
   FCCAR_CANTID       INT             NOT NULL DEFAULT 1,
   FCCAR_PREUNI       DECIMAL(10,2)   NOT NULL,
   FCCAR_DESCUE       DECIMAL(10,2)   NOT NULL DEFAULT 0.00,
   FCCAR_SUBTOT       DECIMAL(12,2)   NOT NULL,
   FCCAR_FECHA        DATETIME        NOT NULL,
   FCCAR_ESTADO       VARCHAR(10)     NOT NULL DEFAULT 'ACTIVO',
   FCCAR_MOTANU       VARCHAR(200)    NULL,
   constraint PK_CARGO_FACTURABLE primary key (FCCAR_CODIGO)
)
go

/*==============================================================*/
/* Table: FCPAG_PAGO                                            */
/*==============================================================*/
create table FCPAG_PAGO (
   FCPAG_CODIGO       INT             IDENTITY NOT NULL,
   FCCUE_CODIGO       INT             NOT NULL,
   FCPAG_NUMCOM       VARCHAR(20)     NOT NULL,
   FCPAG_MONTO        DECIMAL(12,2)   NOT NULL,
   FCPAG_FORMA        VARCHAR(15)     NOT NULL,
   FCPAG_FECHA        DATETIME        NOT NULL,
   AUD_AUTOR          CHAR(10)        NOT NULL,
   FCPAG_ESTADO       VARCHAR(10)     NOT NULL DEFAULT 'ACTIVO',
   FCPAG_MOTANU       VARCHAR(200)    NULL,
   constraint PK_FCPAG_PAGO primary key (FCPAG_CODIGO)
)
go

/*==============================================================*/
/* Table: FCDOC_DFAC                                            */
/*==============================================================*/
create table FCDOC_DFAC (
   FCDOC_CODIGO       INT             IDENTITY NOT NULL,
   FCCUE_CODIGO       INT             NOT NULL,
   FCDOC_NUMDOC       VARCHAR(30)     NOT NULL,
   FCDOC_TIPO         VARCHAR(20)     NOT NULL DEFAULT 'FACTURA',
   FCDOC_FECHA        DATETIME        NOT NULL,
   FCDOC_SUBTOT       DECIMAL(12,2)   NOT NULL,
   FCDOC_IMP          DECIMAL(12,2)   NOT NULL DEFAULT 0.00,
   FCDOC_TOTAL        DECIMAL(12,2)   NOT NULL,
   FCDOC_ESTADO       VARCHAR(15)     NOT NULL DEFAULT 'EMITIDO',
   FCDOC_URI          VARCHAR(500)    NULL,
   constraint PK_FCDOC_DFAC primary key (FCDOC_CODIGO)
)
go

/*==============================================================*/
/* Table: FCAJU_AJUS                                            */
/*==============================================================*/
create table FCAJU_AJUS (
   FCAJU_CODIGO       INT             IDENTITY NOT NULL,
   FCCUE_CODIGO       INT             NOT NULL,
   PEPER_CODIGO       CHAR(10)        NULL,
   FCAJU_TIPO         VARCHAR(20)     NOT NULL,
   FCAJU_MONTO        DECIMAL(12,2)   NOT NULL,
   FCAJU_MOTIVO       VARCHAR(300)    NOT NULL,
   FCAJU_FECHA        DATETIME        NOT NULL,
   FCAJU_ESTADO       VARCHAR(15)     NOT NULL DEFAULT 'APROBADO',
   constraint PK_FCAJU_AJUS primary key (FCAJU_CODIGO)
)
go

alter table XEOPC_OPCIO
   add constraint FK_XR_XESIS_XEOPC foreign key (XESIS_CODIGO)
      references XESIS_SISTE (XESIS_CODIGO)
go

alter table XEOXP_OPCPE
   add constraint FK_XR_XEOPC_XEOXP foreign key (XEOPC_CODIGO)
      references XEOPC_OPCIO (XEOPC_CODIGO)
go

alter table XEOXP_OPCPE
   add constraint FK_XR_XEPER_XEOXP foreign key (XEPER_CODIGO)
      references XEPER_PERFI (XEPER_CODIGO)
go

alter table PECAR_CARGO
   add constraint FK_PR_PEDEP_PECAR foreign key (PEDEP_CODIGO)
      references PEDEP_DEPAR (PEDEP_CODIGO)
go

alter table PEPER_PERSO
   add constraint FK_PR_PEGEN_PEPER foreign key (PEGEN_CODIGO)
      references PEGEN_GENERO (PEGEN_CODIGO)
go

alter table PEPER_PERSO
   add constraint FK_PR_PEESC_PEPER foreign key (PEESC_CODIGO)
      references PEESC_CIVIL (PEESC_CODIGO)
go

alter table XEUSU_USUAR
   add constraint FK_XR_XEEST_XEUSU foreign key (XEEST_CODIGO)
      references XEEST_ESTAD (XEEST_CODIGO)
go

alter table XEUSU_USUAR
   add constraint FK_XR_PEPER_XEUSU foreign key (PEPER_CODIGO)
      references PEPER_PERSO (PEPER_CODIGO)
go

alter table XEUXP_USUPE
   add constraint FK_XR_XEUSU_XEUXP foreign key (XEUSU_PASWD)
      references XEUSU_USUAR (XEUSU_PASWD)
go

alter table XEUXP_USUPE
   add constraint FK_XR_XEPER_XEUXP foreign key (XEPER_CODIGO)
      references XEPER_PERFI (XEPER_CODIGO)
go

alter table SEAUD_EVEN
   add constraint FK_PERSONA_EVENTO_AUDITORIA foreign key (PEPER_CODIGO)
      references PEPER_PERSO (PEPER_CODIGO)
go

alter table PEPRO_PROFE
   add constraint FK_PERSONA_PROFESIONAL foreign key (PEPER_CODIGO)
      references PEPER_PERSO (PEPER_CODIGO)
go

alter table PEPRO_PROFE
   add constraint FK_ESPECIALIDAD_PROFESIONAL foreign key (PEESP_CODIGO)
      references PEESP_ESPEC (PEESP_CODIGO)
go

alter table AGENDA
   add constraint FK_PROFESIONAL_AGENDA foreign key (PEPRO_CODIGO)
      references PEPRO_PROFE (PEPRO_CODIGO)
go

alter table AGENDA
   add constraint FK_ESPECIALIDAD_AGENDA foreign key (PEESP_CODIGO)
      references PEESP_ESPEC (PEESP_CODIGO)
go

alter table AGENDA
   add constraint FK_CONSULTORIO_AGENDA foreign key (CONS_CODIGO)
      references CONSULTORIO (CONS_CODIGO)
go

alter table CITA
   add constraint FK_PACIENTE_CITA foreign key (PAPAC_CODIGO)
      references PAPAC_PACIE (PAPAC_CODIGO)
go

alter table CITA
   add constraint FK_PROFESIONAL_CITA foreign key (PEPRO_CODIGO)
      references PEPRO_PROFE (PEPRO_CODIGO)
go

alter table CITA
   add constraint FK_AGENDA_CITA foreign key (AGEN_CODIGO)
      references AGENDA (AGEN_CODIGO)
go

alter table CLATE_ATENC
   add constraint FK_PACIENTE_ATENCION foreign key (PAPAC_CODIGO)
      references PAPAC_PACIE (PAPAC_CODIGO)
go

alter table CLATE_ATENC
   add constraint FK_PROFESIONAL_ATENCION foreign key (PEPRO_CODIGO)
      references PEPRO_PROFE (PEPRO_CODIGO)
go

alter table CLATE_ATENC
   add constraint FK_CITA_ATENCION foreign key (PACIT_CODIGO)
      references CITA (PACIT_CODIGO)
go

alter table CLDIA_DIAGN
   add constraint FK_ATENCION_DIAGNOSTICO foreign key (CLATE_CODIGO)
      references CLATE_ATENC (CLATE_CODIGO)
go

alter table CLALR_ALERG
   add constraint FK_PACIENTE_ALERGIA foreign key (PAPAC_CODIGO)
      references PAPAC_PACIE (PAPAC_CODIGO)
go

alter table CLDOC_DOCLI
   add constraint FK_ATENCION_DOCLI foreign key (CLATE_CODIGO)
      references CLATE_ATENC (CLATE_CODIGO)
go

alter table CLDOC_DOCLI
   add constraint FK_PERSONA_DOCLI foreign key (PEPER_CODIGO)
      references PEPER_PERSO (PEPER_CODIGO)
go

alter table CLDOC_DOCLI
   add constraint FK_DOCLI_PREDEC foreign key (CLDOC_PREDEC)
      references CLDOC_DOCLI (CLDOC_CODIGO)
go

alter table LAORD_ORDEN
   add constraint FK_ATENCION_ORDENLAB foreign key (CLATE_CODIGO)
      references CLATE_ATENC (CLATE_CODIGO)
go

alter table LARES_RESLA
   add constraint FK_ORDEN_DETALLE_LAB foreign key (LAORD_CODIGO)
      references LAORD_ORDEN (LAORD_CODIGO)
go

alter table IMORD_ORDIM
   add constraint FK_ATENCION_ORDEN_IMAGEN foreign key (CLATE_CODIGO)
      references CLATE_ATENC (CLATE_CODIGO)
go

alter table IMORD_ORDIM
   add constraint FK_PROFESIONAL_ORDEN_IMAGEN foreign key (PEPRO_CODIGO)
      references PEPRO_PROFE (PEPRO_CODIGO)
go

alter table IMORD_ORDIM
   add constraint FK_PROFESIONAL_INFORME_IMAGEN foreign key (IMINF_CODINF)
      references PEPRO_PROFE (PEPRO_CODIGO)
go

alter table CLPRE_PRESC
   add constraint FK_ATENCION_PRESC foreign key (CLATE_CODIGO)
      references CLATE_ATENC (CLATE_CODIGO)
go

alter table CLPRE_PRESC
   add constraint FK_MEDICAMENTO_PRESC foreign key (FAMED_CODIGO)
      references FAMED_MEDIC (FAMED_CODIGO)
go

alter table FALOT_LOTE
   add constraint FK_MEDICAMENTO_LOTE foreign key (FAMED_CODIGO)
      references FAMED_MEDIC (FAMED_CODIGO)
go

alter table FAMOV_MOVIN
   add constraint FK_LOTE_MOVIMIENTO foreign key (FALOT_CODIGO)
      references FALOT_LOTE (FALOT_CODIGO)
go

alter table FADIS_DISPE
   add constraint FK_PRESC_DISPENSACION foreign key (CLPRE_CODIGO)
      references CLPRE_PRESC (CLPRE_CODIGO)
go

alter table FADIS_DISPE
   add constraint FK_LOTE_DISPENSACION foreign key (FALOT_CODIGO)
      references FALOT_LOTE (FALOT_CODIGO)
go

alter table HABITACION
   add constraint FK_UNIDAD_HABITACION foreign key (UNHO_CODIGO)
      references UNIDAD_HOSPITALARIA (UNHO_CODIGO)
go

alter table CAMA
   add constraint FK_HABITACION_CAMA foreign key (HABI_CODIGO)
      references HABITACION (HABI_CODIGO)
go

alter table HOSPITALIZACION
   add constraint FK_PACIENTE_HOSPITALIZACION foreign key (PAPAC_CODIGO)
      references PAPAC_PACIE (PAPAC_CODIGO)
go

alter table HOSPITALIZACION
   add constraint FK_PROFESIONAL_HOSPITALIZACION foreign key (PEPRO_CODIGO)
      references PEPRO_PROFE (PEPRO_CODIGO)
go

alter table HOSPITALIZACION
   add constraint FK_CAMA_HOSPITALIZACION foreign key (HOCAM_CODIGO)
      references CAMA (HOCAM_CODIGO)
go

alter table HOSPITALIZACION
   add constraint FK_ATENCION_HOSPITALIZACION foreign key (CLATE_CODIGO)
      references CLATE_ATENC (CLATE_CODIGO)
go

alter table HOTRA_TRASL
   add constraint FK_HOSP_TRASLADO foreign key (HOHOS_CODIGO)
      references HOSPITALIZACION (HOHOS_CODIGO)
go

alter table HOTRA_TRASL
   add constraint FK_CAMA_ORIGEN_TRASLADO foreign key (HOCAM_ORIGEN)
      references CAMA (HOCAM_CODIGO)
go

alter table HOTRA_TRASL
   add constraint FK_CAMA_DESTINO_TRASLADO foreign key (HOCAM_DESTINO)
      references CAMA (HOCAM_CODIGO)
go

alter table ASIGNACION_CAMA
   add constraint FK_HOSP_ASIGNACION foreign key (HOHOS_CODIGO)
      references HOSPITALIZACION (HOHOS_CODIGO)
go

alter table ASIGNACION_CAMA
   add constraint FK_CAMA_ASIGNACION foreign key (HOCAM_CODIGO)
      references CAMA (HOCAM_CODIGO)
go

alter table ASIGNACION_CAMA
   add constraint FK_PERSONA_ASIGNACION foreign key (PEPER_CODIGO)
      references PEPER_PERSO (PEPER_CODIGO)
go

alter table QUPRO_PRQUI
   add constraint FK_ATENCION_QUIROFANO foreign key (CLATE_CODIGO)
      references CLATE_ATENC (CLATE_CODIGO)
go

alter table QUPRO_PRQUI
   add constraint FK_CIRUJANO_QUIROFANO foreign key (PEPRO_CODIGO)
      references PEPRO_PROFE (PEPRO_CODIGO)
go

alter table FCCUE_CUENT
   add constraint FK_PACIENTE_CUENTA foreign key (PAPAC_CODIGO)
      references PAPAC_PACIE (PAPAC_CODIGO)
go

alter table CARGO_FACTURABLE
   add constraint FK_CUENTA_CARGO foreign key (FCCUE_CODIGO)
      references FCCUE_CUENT (FCCUE_CODIGO)
go

alter table CARGO_FACTURABLE
   add constraint FK_TARIFA_CARGO foreign key (TASE_CODIGO)
      references TARIFA_SERVICIO (TASE_CODIGO)
go

alter table FCPAG_PAGO
   add constraint FK_CUENTA_PAGO foreign key (FCCUE_CODIGO)
      references FCCUE_CUENT (FCCUE_CODIGO)
go

alter table FCDOC_DFAC
   add constraint FK_CUENTA_FACTURA foreign key (FCCUE_CODIGO)
      references FCCUE_CUENT (FCCUE_CODIGO)
go

alter table FCAJU_AJUS
   add constraint FK_CUENTA_AJUSTE foreign key (FCCUE_CODIGO)
      references FCCUE_CUENT (FCCUE_CODIGO)
go

alter table FCAJU_AJUS
   add constraint FK_PERSONA_AJUSTE foreign key (PEPER_CODIGO)
      references PEPER_PERSO (PEPER_CODIGO)
go
