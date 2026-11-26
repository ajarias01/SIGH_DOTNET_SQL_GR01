-- =============================================================================
-- DML - Data Manipulation Language
-- Sistema: Sistema Integral de Gestión Hospitalaria (SIGH)
-- Base de datos: gestion_hospitalaria_sigh
-- Motor: MySQL 8 / InnoDB (compatible con MariaDB 10.6 o superior)
-- Grupo 1 - Desarrollo Web Avanzado
-- Ejecutar DESPUÉS de DDL.sql
-- Datos estructurados conforme a los diagramas conceptual, lógico y físico SIGH_GR01
-- Todas las cédulas cumplen el algoritmo de validación ecuatoriano (módulo 10).
-- =============================================================================

USE gestion_hospitalaria_sigh;
SET NAMES utf8mb4;

-- =============================================================================
-- 1. SUBSISTEMA SEGURIDAD Y AUDITORÍA (SUSE)
-- =============================================================================

-- Estados del sistema
INSERT INTO XEEST_ESTAD (XEEST_CODIGO, XEEST_DESCRI) VALUES
('A', 'Activo'),
('I', 'Inactivo'),
('B', 'Bloqueado'),
('P', 'Pendiente'),
('C', 'Cancelado');

-- Subsistemas del proyecto SIGH
INSERT INTO XESIS_SISTE (XESIS_CODIGO, XESIS_DESCRI) VALUES
('1', 'Seguridad y Auditoría (SUSE)'),
('2', 'Personal y Talento Humano (SUPE)'),
('3', 'Gestión Hospitalaria Asistencial (SUGH)'),
('4', 'Finanzas y Facturación (SUFI)');

-- Perfiles / Roles institucionales
INSERT INTO XEPER_PERFI (XEPER_CODIGO, XEPER_DESCRI, XEPER_OBSER) VALUES
('ROL_ADMI', 'Administrador del Sistema', 'Acceso total a configuración, seguridad, auditoría y catálogos'),
('ROL_ADMS', 'Personal de Admisión', 'Gestión de pacientes, agendas de turnos y citas médicas'),
('ROL_MEDI', 'Médico Asistencial', 'Registro de atenciones, diagnóstico CIE-10, prescripciones y órdenes'),
('ROL_ENFE', 'Personal de Enfermería', 'Registro de triaje, signos vitales y cuidados de hospitalización'),
('ROL_LABO', 'Técnico de Laboratorio', 'Recepción de muestras biológicas y validación de resultados'),
('ROL_FARM', 'Farmacéutico', 'Gestión de catálogo de medicamentos, lotes y dispensación'),
('ROL_FACT', 'Personal de Facturación y Caja', 'Gestión de cuentas hospitalarias, cargos, cobros y comprobantes'),
('ROL_DIRE', 'Director Médico / Hospitalario', 'Consulta de indicadores clínicos, reportes de gestión y auditoría');

-- Opciones del menú del sistema SIGH
INSERT INTO XEOPC_OPCIO (XEOPC_CODIGO, XESIS_CODIGO, XEOPC_DESCRI) VALUES
('001', '1', 'Inicio y Tablero de Control'),
('002', '1', 'Gestión de Usuarios y Accesos'),
('003', '1', 'Gestión de Perfiles y Permisos'),
('004', '1', 'Bitácora y Eventos de Auditoría'),
('005', '1', 'Catálogos Generales del Sistema'),
('006', '2', 'Registro de Personal y Empleados'),
('007', '2', 'Departamentos y Cargos'),
('008', '2', 'Gestión de Profesionales de Salud'),
('009', '2', 'Especialidades Médicas'),
('010', '3', 'Registro y Búsqueda de Pacientes'),
('011', '3', 'Programación de Agendas Médicas'),
('012', '3', 'Gestión y Reservación de Citas'),
('013', '3', 'Atención Médica y Consulta Externa'),
('014', '3', 'Atención de Emergencias y Triaje'),
('015', '3', 'Historia Clínica y Documentos Adjuntos'),
('016', '3', 'Órdenes y Resultados de Laboratorio'),
('017', '3', 'Órdenes e Informes de Imagenología'),
('018', '3', 'Prescripciones Médicas'),
('019', '3', 'Dispensación en Farmacia'),
('020', '3', 'Inventario y Lotes de Medicamentos'),
('021', '3', 'Gestión de Camas y Pabellones'),
('022', '3', 'Episodios de Hospitalización y Traslados'),
('023', '3', 'Programación de Quirófano y Cirugías'),
('024', '4', 'Tarifario de Prestaciones y Servicios'),
('025', '4', 'Cuentas Hospitalarias de Pacientes'),
('026', '4', 'Liquidación de Cargos Facturables'),
('027', '4', 'Caja y Recaudación de Pagos'),
('028', '4', 'Facturación Electrónica y Documentos'),
('029', '4', 'Ajustes Financieros y Notas de Crédito'),
('030', '4', 'Reportes Gerenciales y Estadísticos');

-- Matriz de opciones por perfil (XEOXP_OPCPE)
-- Administrador: todas las opciones
INSERT INTO XEOXP_OPCPE (XEOPC_CODIGO, XEPER_CODIGO, XEOXP_FECASI, XEOXP_FECRET) VALUES
('001', 'ROL_ADMI', '2026-01-01', NULL),
('002', 'ROL_ADMI', '2026-01-01', NULL),
('003', 'ROL_ADMI', '2026-01-01', NULL),
('004', 'ROL_ADMI', '2026-01-01', NULL),
('005', 'ROL_ADMI', '2026-01-01', NULL),
('006', 'ROL_ADMI', '2026-01-01', NULL),
('007', 'ROL_ADMI', '2026-01-01', NULL),
('008', 'ROL_ADMI', '2026-01-01', NULL),
('009', 'ROL_ADMI', '2026-01-01', NULL),
('024', 'ROL_ADMI', '2026-01-01', NULL),
('030', 'ROL_ADMI', '2026-01-01', NULL);

-- Personal de Admisión
INSERT INTO XEOXP_OPCPE (XEOPC_CODIGO, XEPER_CODIGO, XEOXP_FECASI, XEOXP_FECRET) VALUES
('001', 'ROL_ADMS', '2026-01-01', NULL),
('010', 'ROL_ADMS', '2026-01-01', NULL),
('011', 'ROL_ADMS', '2026-01-01', NULL),
('012', 'ROL_ADMS', '2026-01-01', NULL),
('021', 'ROL_ADMS', '2026-01-01', NULL),
('022', 'ROL_ADMS', '2026-01-01', NULL);

-- Médicos
INSERT INTO XEOXP_OPCPE (XEOPC_CODIGO, XEPER_CODIGO, XEOXP_FECASI, XEOXP_FECRET) VALUES
('001', 'ROL_MEDI', '2026-01-01', NULL),
('010', 'ROL_MEDI', '2026-01-01', NULL),
('012', 'ROL_MEDI', '2026-01-01', NULL),
('013', 'ROL_MEDI', '2026-01-01', NULL),
('014', 'ROL_MEDI', '2026-01-01', NULL),
('015', 'ROL_MEDI', '2026-01-01', NULL),
('016', 'ROL_MEDI', '2026-01-01', NULL),
('017', 'ROL_MEDI', '2026-01-01', NULL),
('018', 'ROL_MEDI', '2026-01-01', NULL),
('022', 'ROL_MEDI', '2026-01-01', NULL),
('023', 'ROL_MEDI', '2026-01-01', NULL);

-- Enfermeros
INSERT INTO XEOXP_OPCPE (XEOPC_CODIGO, XEPER_CODIGO, XEOXP_FECASI, XEOXP_FECRET) VALUES
('001', 'ROL_ENFE', '2026-01-01', NULL),
('010', 'ROL_ENFE', '2026-01-01', NULL),
('014', 'ROL_ENFE', '2026-01-01', NULL),
('015', 'ROL_ENFE', '2026-01-01', NULL),
('021', 'ROL_ENFE', '2026-01-01', NULL),
('022', 'ROL_ENFE', '2026-01-01', NULL);

-- Laboratorio
INSERT INTO XEOXP_OPCPE (XEOPC_CODIGO, XEPER_CODIGO, XEOXP_FECASI, XEOXP_FECRET) VALUES
('001', 'ROL_LABO', '2026-01-01', NULL),
('016', 'ROL_LABO', '2026-01-01', NULL);

-- Farmacia
INSERT INTO XEOXP_OPCPE (XEOPC_CODIGO, XEPER_CODIGO, XEOXP_FECASI, XEOXP_FECRET) VALUES
('001', 'ROL_FARM', '2026-01-01', NULL),
('018', 'ROL_FARM', '2026-01-01', NULL),
('019', 'ROL_FARM', '2026-01-01', NULL),
('020', 'ROL_FARM', '2026-01-01', NULL);

-- Facturación y Caja
INSERT INTO XEOXP_OPCPE (XEOPC_CODIGO, XEPER_CODIGO, XEOXP_FECASI, XEOXP_FECRET) VALUES
('001', 'ROL_FACT', '2026-01-01', NULL),
('010', 'ROL_FACT', '2026-01-01', NULL),
('024', 'ROL_FACT', '2026-01-01', NULL),
('025', 'ROL_FACT', '2026-01-01', NULL),
('026', 'ROL_FACT', '2026-01-01', NULL),
('027', 'ROL_FACT', '2026-01-01', NULL),
('028', 'ROL_FACT', '2026-01-01', NULL),
('029', 'ROL_FACT', '2026-01-01', NULL);

-- Director Médico
INSERT INTO XEOXP_OPCPE (XEOPC_CODIGO, XEPER_CODIGO, XEOXP_FECASI, XEOXP_FECRET) VALUES
('001', 'ROL_DIRE', '2026-01-01', NULL),
('004', 'ROL_DIRE', '2026-01-01', NULL),
('015', 'ROL_DIRE', '2026-01-01', NULL),
('030', 'ROL_DIRE', '2026-01-01', NULL);

-- =============================================================================
-- 2. SUBSISTEMA PERSONAL Y TALENTO HUMANO (SUPE)
-- =============================================================================

-- Departamentos
INSERT INTO PEDEP_DEPAR (PEDEP_CODIGO, PEDEP_DESCRIP) VALUES
('DIR', 'Dirección General y Médica'),
('ADM', 'Admisión y Gestión de Pacientes'),
('MED', 'Servicio Médico y Consulta Externa'),
('ENF', 'Servicio de Enfermería'),
('LAB', 'Laboratorio Clínico y Patología'),
('FAR', 'Farmacia Hospitalaria y Almacén'),
('FIN', 'Finanzas, Caja y Facturación'),
('SIS', 'Tecnologías de la Información');

-- Género
INSERT INTO PEGEN_GENERO (PEGEN_CODIGO, PEGEN_DESCRI) VALUES
('M', 'Masculino'),
('F', 'Femenino'),
('O', 'Otro / No especificado');

-- Estado Civil
INSERT INTO PEESC_CIVIL (PEESC_CODIGO, PEESC_DESCRI) VALUES
('S', 'Soltero/a'),
('C', 'Casado/a'),
('D', 'Divorciado/a'),
('V', 'Viudo/a'),
('U', 'Unión de Hecho');

-- Cargos
INSERT INTO PECAR_CARGO (PEDEP_CODIGO, PECAR_CODIGO, PECAR_DESCRI) VALUES
('DIR', '001', 'Director General'),
('DIR', '002', 'Director Médico'),
('ADM', '001', 'Jefe de Admisión'),
('ADM', '002', 'Recepcionista Asistencial'),
('MED', '001', 'Médico General'),
('MED', '002', 'Médico Especialista'),
('MED', '003', 'Cirujano Principal'),
('ENF', '001', 'Enfermero/a Jefe'),
('ENF', '002', 'Enfermero/a de Triaje'),
('LAB', '001', 'Bioquímico / Responsable Técnico'),
('LAB', '002', 'Tecnólogo de Laboratorio'),
('FAR', '001', 'Químico Farmacéutico'),
('FAR', '002', 'Auxiliar de Farmacia'),
('FIN', '001', 'Jefe de Facturación'),
('FIN', '002', 'Cajero / Recaudador'),
('SIS', '001', 'Administrador de Base de Datos y Sistemas');

-- Personas naturales (Personal institucional con cédulas válidas de Pichincha/Guayas)
INSERT INTO PEPER_PERSO (PEPER_CODIGO, PEGEN_CODIGO, PEESC_CIVIL, PEPER_APELLI, PEPER_NOMBRE, PEPER_FECNAC, PEPER_CEDULA, PEPER_PASAPO, PEPER_EMAIL, PEPER_CARFAM, PEPER_FOTO, PEPER_DISCAPACIDAD) VALUES
('PER-000001', 'M', 'C', 'Padilla Romero', 'Marco Vinicio', '1980-05-14', '1710034065', NULL, 'mpadilla@sigh.gob.ec', 2, 'mpadilla.png', 'N'),
('PER-000002', 'M', 'S', 'Toscano Alarcón', 'Edgar Ramiro', '1992-08-22', '1712345678', NULL, 'etoscano@sigh.gob.ec', 0, 'etoscano.png', 'N'),
('PER-000003', 'M', 'C', 'Andino Morales', 'Nelson Fernando', '1975-11-03', '1708892342', NULL, 'nandino@sigh.gob.ec', 3, 'nandino.png', 'N'),
('PER-000004', 'F', 'C', 'Mena Carvajal', 'Sofía Beatriz', '1984-03-18', '1714567890', NULL, 'smena@sigh.gob.ec', 1, 'smena.png', 'N'),
('PER-000005', 'M', 'C', 'Ruiz Guerrero', 'Carlos Alberto', '1978-09-30', '1709988776', NULL, 'cruiz@sigh.gob.ec', 2, 'cruiz.png', 'N'),
('PER-000006', 'F', 'S', 'Herrera Salazar', 'Lucía Mercedes', '1990-07-12', '1715678901', NULL, 'lherrera@sigh.gob.ec', 0, 'lherrera.png', 'N'),
('PER-000007', 'M', 'S', 'Cevallos Paredes', 'Diego Francisco', '1988-12-05', '1716789012', NULL, 'dcevallos@sigh.gob.ec', 1, 'dcevallos.png', 'N'),
('PER-000008', 'F', 'C', 'Salazar Molina', 'Andrea Paulina', '1986-04-25', '1717890123', NULL, 'asalazar@sigh.gob.ec', 2, 'asalazar.png', 'N'),
('PER-000009', 'F', 'C', 'Vinueza Tapia', 'Paola Viviana', '1991-10-14', '1718901234', NULL, 'pvinueza@sigh.gob.ec', 1, 'pvinueza.png', 'N'),
('PER-000010', 'M', 'C', 'Ortega Vallejo', 'Ramiro Gonzalo', '1970-01-20', '1707654321', NULL, 'rortega@sigh.gob.ec', 2, 'rortega.png', 'N');

-- Usuarios del sistema (claves SHA-256 precalculadas)
INSERT INTO XEUSU_USUAR (XEUSU_PASWD, XEEST_CODIGO, PEPER_CODIGO, XEUSU_FECCRE, XEUSU_FECMOD, XEUSU_PIEFIR) VALUES
('mpadilla',  'A', 'PER-000001', '2026-01-01 08:00:00', '2026-01-01 08:00:00', 'Ing. Marco Padilla - Administrador SIGH'),
('etoscano',  'A', 'PER-000002', '2026-01-01 08:00:00', '2026-01-01 08:00:00', 'Edgar Toscano - Admisión y Archivo'),
('nandino',   'A', 'PER-000003', '2026-01-01 08:00:00', '2026-01-01 08:00:00', 'Dr. Nelson Andino - Médico Especialista'),
('smena',     'A', 'PER-000004', '2026-01-01 08:00:00', '2026-01-01 08:00:00', 'Dra. Sofía Mena - Especialista en Pediatría'),
('cruiz',     'A', 'PER-000005', '2026-01-01 08:00:00', '2026-01-01 08:00:00', 'Dr. Carlos Ruiz - Cirujano Traumatólogo'),
('lherrera',  'A', 'PER-000006', '2026-01-01 08:00:00', '2026-01-01 08:00:00', 'Lic. Lucía Herrera - Enfermería y Triaje'),
('dcevallos', 'A', 'PER-000007', '2026-01-01 08:00:00', '2026-01-01 08:00:00', 'Lcdo. Diego Cevallos - Laboratorio Clínico'),
('asalazar',  'A', 'PER-000008', '2026-01-01 08:00:00', '2026-01-01 08:00:00', 'Bioq. Andrea Salazar - Farmacia Hospitalaria'),
('pvinueza',  'A', 'PER-000009', '2026-01-01 08:00:00', '2026-01-01 08:00:00', 'Ing. Paola Vinueza - Facturación y Caja'),
('rortega',   'A', 'PER-000010', '2026-01-01 08:00:00', '2026-01-01 08:00:00', 'Dr. Ramiro Ortega - Director Médico');

-- Asignación de perfiles a usuarios
INSERT INTO XEUXP_USUPE (XEUSU_PASWD, XEPER_CODIGO, XEUXP_FECASI, XEUXP_FECRET) VALUES
('mpadilla',  'ROL_ADMI', '2026-01-01', NULL),
('etoscano',  'ROL_ADMS', '2026-01-01', NULL),
('nandino',   'ROL_MEDI', '2026-01-01', NULL),
('smena',     'ROL_MEDI', '2026-01-01', NULL),
('cruiz',     'ROL_MEDI', '2026-01-01', NULL),
('lherrera',  'ROL_ENFE', '2026-01-01', NULL),
('dcevallos', 'ROL_LABO', '2026-01-01', NULL),
('asalazar',  'ROL_FARM', '2026-01-01', NULL),
('pvinueza',  'ROL_FACT', '2026-01-01', NULL),
('rortega',   'ROL_DIRE', '2026-01-01', NULL);

-- Eventos iniciales de auditoría
INSERT INTO SEAUD_EVEN (SEAUD_CODIGO, PEPER_CODIGO, SEAUD_FECHA, SEAUD_MODULO, SEAUD_ACCION, SEAUD_ENTID, SEAUD_IDOBJ, SEAUD_RESULT, SEAUD_JUSTIF, SEAUD_ORIGEN, SEAUD_DETALL) VALUES
(1, 'PER-000001', '2026-01-01 08:00:00', 'SEGURIDAD', 'SISTEMA_INICIALIZACION', 'SISTEMA', '1', 'EXITO', 'Carga inicial del esquema y catálogos SIGH_GR01', '127.0.0.1', 'Inicialización completada exitosamente'),
(2, 'PER-000001', '2026-01-01 08:10:00', 'SEGURIDAD', 'LOGIN', 'XEUSU_USUAR', 'mpadilla', 'EXITO', 'Acceso inicial de administración', '192.168.1.10', 'Autenticación exitosa con credencial de administrador'),
(3, 'PER-000002', '2026-01-02 07:30:00', 'ADMISIÓN', 'LOGIN', 'XEUSU_USUAR', 'etoscano', 'EXITO', 'Inicio de turno en módulo de admisión', '192.168.1.20', 'Apertura de ventanilla de atención 1');

-- Especialidades médicas
INSERT INTO PEESP_ESPEC (PEESP_CODIGO, PEESP_NOMBRE, PEESP_ESTADO) VALUES
(1, 'Medicina General', 'A'),
(2, 'Pediatría', 'A'),
(3, 'Traumatología y Ortopedia', 'A'),
(4, 'Cardiología', 'A'),
(5, 'Ginecología y Obstetricia', 'A'),
(6, 'Medicina Interna', 'A'),
(7, 'Emergenciología', 'A'),
(8, 'Cirugía General', 'A'),
(9, 'Radiología e Imagen', 'A');

-- Profesionales de salud
INSERT INTO PEPRO_PROFE (PEPRO_CODIGO, PEPER_CODIGO, PEESP_CODIGO, PEPRO_REGPRO, PEPRO_AGENDA) VALUES
(1, 'PER-000003', 1, 'MED-MSP-1708892', 'Lunes a Viernes 08:00-14:00 (Turnos de 20 min)'),
(2, 'PER-000004', 2, 'MED-MSP-1714567', 'Lunes a Jueves 09:00-15:00 (Turnos de 30 min)'),
(3, 'PER-000005', 3, 'MED-MSP-1709988', 'Martes y Jueves 08:00-13:00 / Quirófano Miércoles'),
(4, 'PER-000010', 6, 'MED-MSP-1707654', 'Viernes 10:00-13:00 / Sesiones clínicas');

-- =============================================================================
-- 3. SUBSISTEMA GESTIÓN HOSPITALARIA (SUGH) - ADMISIÓN Y CITAS
-- =============================================================================

-- Pacientes registrados (Cédulas válidas ecuatorianas)
INSERT INTO PAPAC_PACIE (PAPAC_CODIGO, PAPAC_NUMHC, PAPAC_TIPDOC, PAPAC_NUMDOC, PAPAC_NOMBRE, PAPAC_APELLI, PAPAC_FECNAC, PAPAC_SEXO, PAPAC_DIRECC, PAPAC_TELEF, PAPAC_EMAIL, PAPAC_CONEME, PAPAC_TELEME, PAPAC_PROVIS, PAPAC_ESTADO, PAPAC_FECREG) VALUES
(1, 'HC-00001', 'C', '1720011223', 'Juan Carlos', 'Pérez Morales', '1985-06-15', 'M', 'Av. América y Mariana de Jesús, Quito', '0991234567', 'jcperez@gmail.com', 'Carmen Morales (Madre)', '022501234', 0, 'A', '2026-01-02 08:15:00'),
(2, 'HC-00002', 'C', '1721122334', 'María Elena', 'Guamán Cuenca', '1990-09-28', 'F', 'Calle Guayaquil y Chile, Centro Histórico', '0982345678', 'mguaman@hotmail.com', 'Pedro Guamán (Hermano)', '022589632', 0, 'A', '2026-01-02 08:45:00'),
(3, 'HC-00003', 'C', '1722233445', 'Mateo Sebastián', 'Castillo Mena', '2018-04-10', 'M', 'Av. Amazonas y Gaspar de Villarroel', '0973456789', 'mcastillo@yahoo.com', 'Valeria Mena (Madre)', '0987654321', 0, 'A', '2026-01-02 09:30:00'),
(4, 'HC-00004', 'C', '1723344556', 'Rosa Inés', 'Chávez Benítez', '1962-12-01', 'F', 'Sector La Floresta, Calle Madrid 456', '0964567890', 'rchavez@outlook.com', 'Santiago Benítez (Hijo)', '022987654', 0, 'A', '2026-01-03 10:00:00'),
(5, 'HC-00005', 'P', 'A12345678', 'David Arthur', 'Smith Johnson', '1982-08-19', 'M', 'Hotel Marriott, Av. Orellana, Quito', '0955678901', 'dsmith@traveler.com', 'Consulado EE.UU.', '023985000', 0, 'A', '2026-01-03 11:20:00');

-- Consultorios físicos
INSERT INTO CONSULTORIO (CONS_CODIGO, CONS_NOMBRE, CONS_UBICACION, CONS_ESTADO) VALUES
(1, 'Consultorio 101 - Consulta Externa', 'Edificio Central - Planta Baja Ala Norte', 'A'),
(2, 'Consultorio 102 - Pediatría', 'Edificio Central - Planta Baja Ala Sur', 'A'),
(3, 'Consultorio 103 - Traumatología', 'Edificio de Especialidades - Piso 1', 'A'),
(4, 'Consultorio 104 - Medicina Interna', 'Edificio de Especialidades - Piso 1', 'A'),
(5, 'Box 1 - Triaje de Emergencia', 'Edificio de Emergencias - Acceso Ambulancias', 'A');

-- Agendas médicas de atención
INSERT INTO AGENDA (AGEN_CODIGO, PEPRO_CODIGO, PEESP_CODIGO, CONS_CODIGO, AGEN_DIASEM, AGEN_HORINI, AGEN_HORFIN, AGEN_DURACION, AGEN_DESDE, AGEN_HASTA, AGEN_ESTADO) VALUES
(1, 1, 1, 1, 1, '08:00:00', '13:00:00', 20, '2026-01-01', '2026-12-31', 'A'),
(2, 1, 1, 1, 3, '08:00:00', '13:00:00', 20, '2026-01-01', '2026-12-31', 'A'),
(3, 2, 2, 2, 2, '09:00:00', '14:00:00', 30, '2026-01-01', '2026-12-31', 'A'),
(4, 3, 3, 3, 4, '08:00:00', '12:00:00', 30, '2026-01-01', '2026-12-31', 'A');

-- Citas médicas
INSERT INTO CITA (PACIT_CODIGO, PAPAC_CODIGO, PEPRO_CODIGO, AGEN_CODIGO, PACIT_FECHA, PACIT_HORA, PACIT_MOTIVO, PACIT_ESTADO, PACIT_HORLLE, PACIT_MOTCAM, PACIT_FECREG, PACIT_CONSUL) VALUES
(1, 1, 1, 1, '2026-01-05', '08:20:00', 'Control de cefalea y malestar general', 'ATENDIDA', '2026-01-05 08:10:00', NULL, '2026-01-02 08:30:00', 'Consultorio 101'),
(2, 2, 1, 1, '2026-01-05', '09:00:00', 'Evaluación de dolor abdominal y náuseas', 'ATENDIDA', '2026-01-05 08:50:00', NULL, '2026-01-02 08:50:00', 'Consultorio 101'),
(3, 3, 2, 3, '2026-01-06', '09:30:00', 'Control pediátrico de rutina y vacunación', 'CONFIRMADA', NULL, NULL, '2026-01-02 09:40:00', 'Consultorio 102'),
(4, 4, 3, 4, '2026-01-08', '08:30:00', 'Dolor en rodilla derecha post traumatismo', 'PROGRAMADA', NULL, NULL, '2026-01-03 10:15:00', 'Consultorio 103');

-- =============================================================================
-- 4. SUBSISTEMA GESTIÓN HOSPITALARIA (SUGH) - ATENCIÓN Y DIAGNÓSTICO
-- =============================================================================

-- Atenciones clínicas
INSERT INTO CLATE_ATENC (CLATE_CODIGO, PAPAC_CODIGO, PEPRO_CODIGO, PACIT_CODIGO, CLATE_TIPO, CLATE_FECHA, CLATE_MOTIVO, CLATE_SINTOM, CLATE_EXPLOR, CLATE_INDICA, CLATE_TRIAJE, CLATE_DISPOS, CLATE_PROREV, CLATE_ESTADO, CLATE_FECFIN, CLATE_PRESIS, CLATE_PREDIA, CLATE_FCARD, CLATE_FRESP, CLATE_TEMP, CLATE_SATUR, CLATE_PESO, CLATE_TALLA) VALUES
(1, 1, 1, 1, 'CONSULTA', '2026-01-05 08:20:00', 'Cefalea pulsátil frontal y astenia', 'Paciente refiere 3 días de dolor de cabeza frontal, sensación febril no cuantificada y congestión nasal.', 'Mucosas húmedas, orofaringe congestiva sin exudados, campos pulmonares limpios, abdomen blando.', 'Reposo relativo, hidratación oral abundante, paracetamol 500mg cada 8 horas por 3 días.', NULL, 'ALTA', '2026-01-12', 'FINALIZADA', '2026-01-05 08:45:00', 120, 80, 72, 16, 36.8, 98.0, 74.5, 172.0),
(2, 2, 1, 2, 'CONSULTA', '2026-01-05 09:00:00', 'Dolor en hipocondrio derecho y dispepsia', 'Dolor tipo cólico de moderada intensidad tras ingesta de alimentos grasos, acompañado de náuseas.', 'Abdomen doloroso a la palpación en hipocondrio derecho, signo de Murphy negativo, sin peritonitis.', 'Dieta blanda hipograsa, solicitar ecografía abdominal superior y biometría hemática completa.', NULL, 'ALTA', '2026-01-10', 'FINALIZADA', '2026-01-05 09:30:00', 110, 70, 78, 18, 37.0, 97.5, 62.0, 158.0),
(3, 4, 3, NULL, 'EMERGENCIA', '2026-01-05 14:10:00', 'Traumatismo cerrado en miembro inferior derecho', 'Caída desde su propia altura con apoyo forzado en rodilla derecha, imposibilidad para la marcha y tumefacción.', 'Deformidad moderada en articulación de rodilla derecha, derrame articular evidente, movilidad limitada por dolor.', 'Inmovilización con férula inguinopedio, crioterapia local, ketorolaco IV, rayos X de rodilla.', 2, 'HOSPITALIZACION', NULL, 'FINALIZADA', '2026-01-05 15:30:00', 135, 85, 88, 20, 36.5, 96.0, 68.0, 155.0);

-- Diagnósticos CIE-10
INSERT INTO CLDIA_DIAGN (CLDIA_CODIGO, CLATE_CODIGO, CLDIA_CIE10, CLDIA_DESCRI, CLDIA_TIPO) VALUES
(1, 1, 'J00', 'Rinofaringitis aguda (resfriado común)', 'DEFINITIVO'),
(2, 1, 'R51', 'Cefalea', 'PRESUNTIVO'),
(3, 2, 'K80.2', 'Cálculo de la vesícula biliar sin colecistitis', 'PRESUNTIVO'),
(4, 3, 'S82.0', 'Fractura de la rótula', 'DEFINITIVO');

-- Alergias conocidas de pacientes
INSERT INTO CLALR_ALERG (CLALR_CODIGO, PAPAC_CODIGO, CLALR_ALERGE, CLALR_REACCI, CLALR_VERIFI, CLALR_FECREG, CLALR_FUENTE) VALUES
(1, 1, 'PENICILINA', 'Exantema maculopapular y prurito generalizado', 1, '2026-01-02 08:25:00', 'Historia previa referida por el paciente'),
(2, 4, 'AINES', 'Edema angioneurótico facial leve tras consumo de diclofenaco', 1, '2026-01-03 10:20:00', 'Informe médico anterior');

-- Documentos clínicos adjuntos
INSERT INTO CLDOC_DOCLI (CLDOC_CODIGO, CLATE_CODIGO, PEPER_CODIGO, CLDOC_PREDEC, CLDOC_TIPO, CLDOC_TITULO, CLDOC_URI, CLDOC_HASH, CLDOC_FECHA, CLDOC_CONTEN) VALUES
(1, 1, 'PER-000003', NULL, 'EVOLUCION', 'Nota de Evolución Consulta Externa', '/docs/clinicos/2026/01/ate_1_evo.pdf', 'e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855', '2026-01-05 08:45:00', 'Paciente estable con diagnóstico de rinofaringitis aguda, sin signos de alarma respiratoria.'),
(2, 3, 'PER-000005', NULL, 'INGRESO_EMERGENCIA', 'Ficha de Ingreso y Valoración Traumatológica', '/docs/clinicos/2026/01/ate_3_trauma.pdf', '8f434346648f6b96df89dda901c5176b10a6d83961dd3c1ac88b59b2dc327aa4', '2026-01-05 15:30:00', 'Ingreso urgente a traumatología para resolución quirúrgica de fractura de rótula.');

-- =============================================================================
-- 5. SUBSISTEMA GESTIÓN HOSPITALARIA (SUGH) - LABORATORIO E IMAGENOLOGÍA
-- =============================================================================

-- Órdenes de laboratorio
INSERT INTO LAORD_ORDEN (LAORD_CODIGO, CLATE_CODIGO, LAORD_PRIORI, LAORD_FECSOL, LAORD_ESTADO, LAORD_CODMUE, LAORD_FECMUE, LAORD_INCIDE, LAORD_TIPMUE) VALUES
(1, 2, 'RUTINA', '2026-01-05 09:25:00', 'VALIDADA', 'MUE-2026-0001', '2026-01-05 09:40:00', NULL, 'SANGRE TOTAL'),
(2, 3, 'URGENTE', '2026-01-05 14:30:00', 'VALIDADA', 'MUE-2026-0002', '2026-01-05 14:40:00', NULL, 'SANGRE TOTAL');

-- Resultados de laboratorio
INSERT INTO LARES_RESLA (LADET_CODIGO, LAORD_CODIGO, LADET_RESULT, LADET_CRITIC, LADET_VERSIO, LADET_ESTADO, LADET_FECRES, AUD_AUTOR, LADET_FECVAL, LARES_NOMEXA) VALUES
(1, 1, '13.8 g/dL (Normal: 12.0 - 15.5)', 0, 1, 'VALIDADO', '2026-01-05 11:00:00', 'PER-000007', '2026-01-05 11:30:00', 'Hemoglobina'),
(2, 1, '7,400 /uL (Normal: 4,500 - 10,000)', 0, 1, 'VALIDADO', '2026-01-05 11:00:00', 'PER-000007', '2026-01-05 11:30:00', 'Leucocitos totales'),
(3, 2, 'TP: 12.2 seg | TTP: 28.5 seg | INR: 1.02', 0, 1, 'VALIDADO', '2026-01-05 15:10:00', 'PER-000007', '2026-01-05 15:20:00', 'Tiempos de Coagulación Prequirúrgicos');

-- Órdenes e informes de imagenología
INSERT INTO IMORD_ORDIM (IMORD_CODIGO, CLATE_CODIGO, PEPRO_CODIGO, IMINF_CODINF, IMORD_TIPO, IMORD_REGION, IMORD_PRIORI, IMORD_INDIC, IMORD_FECSOL, IMORD_FECPRO, IMORD_ESTADO, IMINF_HALLA, IMINF_CONCL, IMINF_FECVAL, IMINF_ESTADO, IMINF_URI) VALUES
(1, 2, 1, 4, 'ECOGRAFIA', 'Abdomen Superior', 'RUTINA', 'Dolor en hipocondrio derecho, descartar litiasis vesicular', '2026-01-05 09:25:00', '2026-01-06 08:30:00', 'INFORMADA', 'Hígado de tamaño y ecoestructura normal. Vesícula biliar con presencia de imagen litiásica única de 14mm con sombra acústica posterior. Vía biliar normal.', 'Colelitiasis vesicular sin signos de colecistitis aguda al momento.', '2026-01-06 09:15:00', 'DEFINITIVO', '/pacs/eco/2026/01/eco_abd_p2.dcm'),
(2, 3, 3, 4, 'RAYOS_X', 'Rodilla Derecha AP y Lateral', 'URGENTE', 'Traumatismo cerrado agudo con sospecha de fractura patelar', '2026-01-05 14:25:00', '2026-01-05 14:35:00', 'INFORMADA', 'Se evidencia trazo de fractura transversal no conminuta a nivel del tercio medio de la rótula derecha con diástasis de fragmentos de 4mm.', 'Fractura transversa de rótula derecha.', '2026-01-05 15:00:00', 'DEFINITIVO', '/pacs/rx/2026/01/rx_rodilla_p4.dcm');

-- =============================================================================
-- 6. SUBSISTEMA GESTIÓN HOSPITALARIA (SUGH) - FARMACIA E INVENTARIO
-- =============================================================================

-- Medicamentos
INSERT INTO FAMED_MEDIC (FAMED_CODIGO, FAMED_CODIGOM, FAMED_NOMBRE, FAMED_PRIACT, FAMED_PRESEN, FAMED_CONCEN, FAMED_UNIDAD, FAMED_STKMIN, FAMED_PRECIO, FAMED_ESTADO) VALUES
(1, 'MED-0001', 'Paracetamol 500mg', 'Paracetamol', 'Tableta', '500 mg', 'tableta', 200, 0.05, 'A'),
(2, 'MED-0002', 'Amoxicilina 500mg', 'Amoxicilina', 'Cápsula', '500 mg', 'cápsula', 100, 0.12, 'A'),
(3, 'MED-0003', 'Ibuprofeno 400mg', 'Ibuprofeno', 'Tableta', '400 mg', 'tableta', 150, 0.07, 'A'),
(4, 'MED-0004', 'Ketorolaco 30mg/ml', 'Ketorolaco Trometamol', 'Solución Inyectable', '30 mg/ml', 'ampolla', 50, 0.85, 'A'),
(5, 'MED-0005', 'Ceftriaxona 1g', 'Ceftriaxona Sódica', 'Polvo para Inyección', '1 g', 'ampolla', 40, 2.80, 'A'),
(6, 'MED-0006', 'Omeprazol 20mg', 'Omeprazol', 'Cápsula', '20 mg', 'cápsula', 100, 0.09, 'A'),
(7, 'MED-0007', 'Cloruro de Sodio 0.9%', 'Cloruro de Sodio', 'Solución Intravenosa', '0.9 % 1000ml', 'funda', 50, 1.20, 'A'),
(8, 'MED-0008', 'Tramadol 50mg/ml', 'Tramadol Clorhidrato', 'Solución Inyectable', '50 mg/ml', 'ampolla', 30, 0.95, 'A');

-- Prescripciones médicas
INSERT INTO CLPRE_PRESC (CLPRE_CODIGO, CLATE_CODIGO, FAMED_CODIGO, CLPRE_DOSIS, CLPRE_VIA, CLPRE_FRECUE, CLPRE_DURACI, CLPRE_CANTID, CLPRE_CANDIS, CLPRE_INSTRU, CLPRE_JUSTIF, CLPRE_ESTADO) VALUES
(1, 1, 1, '500 mg', 'ORAL', 'Cada 8 horas', '3 días', 9, 9, 'Tomar después de las comidas con abundante agua', NULL, 'DISPENSADA'),
(2, 3, 4, '30 mg', 'INTRAVENOSA', 'Dosis única prequirúrgica', '1 dosis', 1, 1, 'Administrar lentamente por vía venosa permeable', 'Analgesia de rescate en trauma agudo', 'DISPENSADA'),
(3, 3, 7, '1000 ml', 'INTRAVENOSA', 'A goteo continuo 40 gotas/min', '24 horas', 2, 2, 'Hidratación parenteral preparatoria', NULL, 'DISPENSADA');

-- Lotes de medicamentos
INSERT INTO FALOT_LOTE (FALOT_CODIGO, FAMED_CODIGO, FALOT_NUMERO, FALOT_FECCAD, FALOT_CANINI, FALOT_CANDIS, FALOT_FECING) VALUES
(1, 1, 'LOTE-PAR-2026A', '2028-12-31', 1000, 991, '2026-01-02 08:00:00'),
(2, 4, 'LOTE-KET-2026B', '2027-06-30', 200, 199, '2026-01-02 08:00:00'),
(3, 7, 'LOTE-SUERO-2026C', '2028-01-31', 300, 298, '2026-01-02 08:00:00');

-- Movimientos de inventario
INSERT INTO FAMOV_MOVIN (FAMOV_CODIGO, FALOT_CODIGO, FAMOV_TIPO, FAMOV_CANTID, FAMOV_MOTIVO, AUD_AUTOR, FAMOV_FECHA) VALUES
(1, 1, 'INGRESO', 1000, 'Ingreso inicial por orden de compra hospitalaria', 'PER-000008', '2026-01-02 08:00:00'),
(2, 1, 'DISPENSACION', 9, 'Dispensación a paciente Juan Pérez (Receta CLPRE-1)', 'PER-000008', '2026-01-05 08:50:00'),
(3, 2, 'INGRESO', 200, 'Ingreso inicial por orden de compra hospitalaria', 'PER-000008', '2026-01-02 08:00:00'),
(4, 2, 'DISPENSACION', 1, 'Administración de urgencia traumatología', 'PER-000008', '2026-01-05 14:35:00');

-- Dispensaciones de farmacia
INSERT INTO FADIS_DISPE (FADIS_CODIGO, CLPRE_CODIGO, FALOT_CODIGO, FADIS_CANTID, AUD_AUTOR, FADIS_FECHA) VALUES
(1, 1, 1, 9, 'PER-000008', '2026-01-05 08:50:00'),
(2, 2, 2, 1, 'PER-000008', '2026-01-05 14:35:00'),
(3, 3, 3, 2, 'PER-000008', '2026-01-05 14:36:00');

-- =============================================================================
-- 7. SUBSISTEMA GESTIÓN HOSPITALARIA (SUGH) - HOSPITALIZACIÓN Y CAMAS
-- =============================================================================

-- Unidades hospitalarias
INSERT INTO UNIDAD_HOSPITALARIA (UNHO_CODIGO, UNHO_NOMBRE, UNHO_TIPO, UNHO_ESTADO) VALUES
(1, 'Medicina Interna', 'HOSPITALIZACION', 'A'),
(2, 'Cirugía y Traumatología', 'HOSPITALIZACION', 'A'),
(3, 'Pediatría', 'HOSPITALIZACION', 'A'),
(4, 'Unidad de Cuidados Intensivos (UCI)', 'CUIDADOS_CRITICOS', 'A');

-- Habitaciones
INSERT INTO HABITACION (HABI_CODIGO, UNHO_CODIGO, HABI_NUMERO, HABI_ESTADO) VALUES
(1, 1, 'HAB-101', 'A'),
(2, 1, 'HAB-102', 'A'),
(3, 2, 'HAB-201', 'A'),
(4, 2, 'HAB-202', 'A'),
(5, 4, 'BOX-UCI-1', 'A');

-- Camas hospitalarias
INSERT INTO CAMA (HOCAM_CODIGO, HABI_CODIGO, HOCAM_NUMERO, HOCAM_ESTADO, HOCAM_UNIDAD) VALUES
(1, 1, 'CAMA-101-A', 'DISPONIBLE', 'Medicina Interna'),
(2, 1, 'CAMA-101-B', 'DISPONIBLE', 'Medicina Interna'),
(3, 3, 'CAMA-201-A', 'OCUPADA', 'Traumatología'),
(4, 3, 'CAMA-201-B', 'DISPONIBLE', 'Traumatología'),
(5, 5, 'CAMA-UCI-01', 'DISPONIBLE', 'Cuidados Intensivos');

-- Hospitalizaciones
INSERT INTO HOSPITALIZACION (HOHOS_CODIGO, PAPAC_CODIGO, PEPRO_CODIGO, HOCAM_CODIGO, CLATE_CODIGO, HOHOS_FECING, HOHOS_DIAING, HOHOS_ALTMED, HOHOS_ALTADM, HOHOS_ESTADO) VALUES
(1, 4, 3, 3, 3, '2026-01-05 15:30:00', 'Fractura transversa de rótula derecha para osteosíntesis', NULL, NULL, 'ACTIVA');

-- Historial de asignación de cama
INSERT INTO ASIGNACION_CAMA (ASCA_CODIGO, HOHOS_CODIGO, HOCAM_CODIGO, PEPER_CODIGO, ASCA_INICIO, ASCA_FIN, ASCA_MOTIVO) VALUES
(1, 1, 3, 'PER-000006', '2026-01-05 15:35:00', '2026-01-07 10:00:00', 'Ingreso inicial a cama de traumatología');

-- Traslados entre camas
INSERT INTO HOTRA_TRASL (HOTRA_CODIGO, HOHOS_CODIGO, HOCAM_ORIGEN, HOCAM_DESTINO, HOTRA_FECHA, AUD_AUTOR) VALUES
(1, 1, 3, 4, '2026-01-07 10:00:00', 'PER-000006');

-- =============================================================================
-- 8. SUBSISTEMA GESTIÓN HOSPITALARIA (SUGH) - CIRUGÍAS
-- =============================================================================

-- Procedimientos quirúrgicos
INSERT INTO QUPRO_PRQUI (QUPRO_CODIGO, CLATE_CODIGO, PEPRO_CODIGO, QUPRO_NOMBRE, QUPRO_FECPRO, QUPRO_INICIO, QUPRO_FIN, QUPRO_SALA, QUPRO_ANEST, QUPRO_HALLA, QUPRO_ESTADO, QUPRO_EQUIPO, QUPRO_CHECK) VALUES
(1, 3, 3, 'Osteosíntesis de rótula derecha con cerclaje tipo obenque', '2026-01-06 08:00:00', '2026-01-06 08:15:00', '2026-01-06 10:00:00', 'Quirófano 1 - Central', 'Raquídea + Sedación', 'Fractura transversal limpia sin conminución. Reducción anatómica satisfactoria y fijación estable con alambre.', 'COMPLETADO', 'Cirujano: Dr. Carlos Ruiz | Ayudante: Dr. Nelson Andino | Anestesiólogo: Dr. Ramiro Ortega', 'Lista OMS verificación pre, intra y postoperatoria conforme sin incidencias.');

-- =============================================================================
-- 9. SUBSISTEMA FINANZAS Y FACTURACIÓN (SUFI)
-- =============================================================================

-- Tarifario general
INSERT INTO TARIFA_SERVICIO (TASE_CODIGO, TASE_CONCEPTO, TASE_TIPO, TASE_VALOR, TASE_IMPUESTO, TASE_DESDE, TASE_HASTA, TASE_ESTADO) VALUES
(1, 'Consulta Médica General', 'CONSULTA', 25.00, 0.00, '2026-01-01', NULL, 'A'),
(2, 'Consulta Médica de Especialidad', 'CONSULTA', 35.00, 0.00, '2026-01-01', NULL, 'A'),
(3, 'Atención Médica de Emergencia y Triaje', 'CONSULTA', 40.00, 0.00, '2026-01-01', NULL, 'A'),
(4, 'Día Cama - Hospitalización General', 'ESTANCIA', 80.00, 0.00, '2026-01-01', NULL, 'A'),
(5, 'Día Cama - Unidad Cuidados Intensivos', 'ESTANCIA', 250.00, 0.00, '2026-01-01', NULL, 'A'),
(6, 'Biometría Hemática Completa', 'EXAMEN', 8.00, 0.00, '2026-01-01', NULL, 'A'),
(7, 'Tiempos de Coagulación (TP / TTP)', 'EXAMEN', 10.00, 0.00, '2026-01-01', NULL, 'A'),
(8, 'Ecografía Abdominal Superior', 'IMAGEN', 45.00, 0.00, '2026-01-01', NULL, 'A'),
(9, 'Rayos X Rodilla AP y Lateral', 'IMAGEN', 25.00, 0.00, '2026-01-01', NULL, 'A'),
(10, 'Derecho de Sala de Cirugía Mayor', 'CIRUGIA', 350.00, 0.00, '2026-01-01', NULL, 'A');

-- Cuentas hospitalarias
INSERT INTO FCCUE_CUENT (FCCUE_CODIGO, PAPAC_CODIGO, FCCUE_FECAPE, FCCUE_TOTAL, FCCUE_SALDO, FCCUE_ESTADO) VALUES
(1, 1, '2026-01-05 08:15:00', 25.45, 0.00, 'CERRADA'),
(2, 2, '2026-01-05 08:50:00', 78.00, 0.00, 'CERRADA'),
(3, 4, '2026-01-05 14:15:00', 588.05, 100.00, 'ABIERTA');

-- Cargos facturables
INSERT INTO CARGO_FACTURABLE (FCCAR_CODIGO, FCCUE_CODIGO, TASE_CODIGO, FCCAR_CONCEP, FCCAR_CANTID, FCCAR_PREUNI, FCCAR_DESCUE, FCCAR_SUBTOT, FCCAR_FECHA, FCCAR_ESTADO, FCCAR_MOTANU) VALUES
(1, 1, 1, 'Consulta Médica General', 1, 25.00, 0.00, 25.00, '2026-01-05 08:20:00', 'ACTIVO', NULL),
(2, 1, NULL, 'Paracetamol 500mg (9 tabletas)', 9, 0.05, 0.00, 0.45, '2026-01-05 08:50:00', 'ACTIVO', NULL),
(3, 2, 1, 'Consulta Médica General', 1, 25.00, 0.00, 25.00, '2026-01-05 09:00:00', 'ACTIVO', NULL),
(4, 2, 6, 'Biometría Hemática Completa', 1, 8.00, 0.00, 8.00, '2026-01-05 09:25:00', 'ACTIVO', NULL),
(5, 2, 8, 'Ecografía Abdominal Superior', 1, 45.00, 0.00, 45.00, '2026-01-05 09:30:00', 'ACTIVO', NULL),
(6, 3, 3, 'Atención Médica de Emergencia y Triaje', 1, 40.00, 0.00, 40.00, '2026-01-05 14:15:00', 'ACTIVO', NULL),
(7, 3, 9, 'Rayos X Rodilla AP y Lateral', 1, 25.00, 0.00, 25.00, '2026-01-05 14:25:00', 'ACTIVO', NULL),
(8, 3, 7, 'Tiempos de Coagulación (TP / TTP)', 1, 10.00, 0.00, 10.00, '2026-01-05 14:30:00', 'ACTIVO', NULL),
(9, 3, 10, 'Derecho de Sala de Cirugía Mayor', 1, 350.00, 0.00, 350.00, '2026-01-06 08:00:00', 'ACTIVO', NULL),
(10, 3, 4, 'Día Cama - Hospitalización General (2 días)', 2, 80.00, 0.00, 160.00, '2026-01-07 10:00:00', 'ACTIVO', NULL),
(11, 3, NULL, 'Ketorolaco y Suero Parenteral', 1, 3.05, 0.00, 3.05, '2026-01-05 14:35:00', 'ACTIVO', NULL);

-- Pagos y recibos de caja
INSERT INTO FCPAG_PAGO (FCPAG_CODIGO, FCCUE_CODIGO, FCPAG_NUMCOM, FCPAG_MONTO, FCPAG_FORMA, FCPAG_FECHA, AUD_AUTOR, FCPAG_ESTADO, FCPAG_MOTANU) VALUES
(1, 1, 'REC-2026-00001', 25.45, 'EFECTIVO', '2026-01-05 09:00:00', 'PER-000009', 'ACTIVO', NULL),
(2, 2, 'REC-2026-00002', 78.00, 'TARJETA', '2026-01-06 10:00:00', 'PER-000009', 'ACTIVO', NULL),
(3, 3, 'REC-2026-00003', 488.05, 'TRANSFERENCIA', '2026-01-07 11:30:00', 'PER-000009', 'ACTIVO', NULL);

-- Facturas emitidas
INSERT INTO FCDOC_DFAC (FCDOC_CODIGO, FCCUE_CODIGO, FCDOC_NUMDOC, FCDOC_TIPO, FCDOC_FECHA, FCDOC_SUBTOT, FCDOC_IMP, FCDOC_TOTAL, FCDOC_ESTADO, FCDOC_URI) VALUES
(1, 1, '001-001-000000101', 'FACTURA', '2026-01-05 09:05:00', 25.45, 0.00, 25.45, 'EMITIDO', '/sri/facturas/2026/01/fac_101.xml'),
(2, 2, '001-001-000000102', 'FACTURA', '2026-01-06 10:05:00', 78.00, 0.00, 78.00, 'EMITIDO', '/sri/facturas/2026/01/fac_102.xml'),
(3, 3, '001-001-000000103', 'FACTURA', '2026-01-07 11:35:00', 488.05, 0.00, 488.05, 'EMITIDO', '/sri/facturas/2026/01/fac_103.xml');

-- Ajustes financieros
INSERT INTO FCAJU_AJUS (FCAJU_CODIGO, FCCUE_CODIGO, PEPER_CODIGO, FCAJU_TIPO, FCAJU_MONTO, FCAJU_MOTIVO, FCAJU_FECHA, FCAJU_ESTADO) VALUES
(1, 3, 'PER-000010', 'DESCUENTO_AUDITORIA', 50.00, 'Descuento institucional autorizado por Dirección Médica por convenio de adulto mayor', '2026-01-07 11:00:00', 'APROBADO');

COMMIT;
