-- ==========================================================
-- SCRIPT DE POBLADO DE DATOS (DML) - AJUSTADO
-- ==========================================================

USE `mydb`;

-- 1. CONFIGURACIÓN INICIAL
-- Desactivar revisiones para poder truncar y poblar sin bloqueos
SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;

-- 2. LIMPIEZA DE TABLAS (Orden inverso para evitar residuos)
TRUNCATE TABLE `Respuesta`;
TRUNCATE TABLE `Pregunta`;
TRUNCATE TABLE `Evaluacion_Docente`;
TRUNCATE TABLE `Cuestionario_Docente`;
TRUNCATE TABLE `Revalidacion`;
TRUNCATE TABLE `Calificacion`;
TRUNCATE TABLE `Materia_Estudiante`;
TRUNCATE TABLE `Horario`;
TRUNCATE TABLE `Carga_Academica`;
TRUNCATE TABLE `Materia_Periodo`;
TRUNCATE TABLE `Materia_Plan_Estudios`;
TRUNCATE TABLE `Docente`;
TRUNCATE TABLE `Usuario`;
TRUNCATE TABLE `Personal`;
TRUNCATE TABLE `Baja`;
TRUNCATE TABLE `Perido_Estudiante`;
TRUNCATE TABLE `Estudiante`;
TRUNCATE TABLE `Grupo`;
TRUNCATE TABLE `Carrera_Plantel`;
TRUNCATE TABLE `Plan_Estudios`;
TRUNCATE TABLE `Carrera`;
TRUNCATE TABLE `Materia`;
TRUNCATE TABLE `Periodo`;
TRUNCATE TABLE `Aula`;
TRUNCATE TABLE `Aspirante`;
TRUNCATE TABLE `Plantel`;
TRUNCATE TABLE `Padre_Tutor`;
TRUNCATE TABLE `Municipio`;
TRUNCATE TABLE `Estado`;
TRUNCATE TABLE `Pais`;
TRUNCATE TABLE `Lada`;

-- ==========================================================
-- 3. INSERCIÓN DE CATÁLOGOS BASE
-- ==========================================================

-- Lada, Pais, Estado, Municipio
INSERT INTO `Lada` (`lada`) VALUES ('+52');
INSERT INTO `Pais` (`nombre`, `nacionalidad`) VALUES ('México', 'Mexicana');
INSERT INTO `Estado` (`Nombre`, `id_pais`) VALUES ('Puebla', 1);

INSERT INTO `Municipio` (`id_municipio`, `nombre`, `id_estado`) VALUES 
(1, 'Puebla', 1),            
(2, 'Huejotzingo', 1),       
(3, 'Chignahuapan', 1),     
(4, 'San Andrés Cholula', 1);

-- Planteles
INSERT INTO `Plantel` (`id_plantel`, `nombre`, `clave`, `id_municipio`, `colonia`, `calle`, `id_lada`, `numero`, `codigo_postal`, `telefono`, `correo`, `horario_apertura`, `horario_cierre`) VALUES 
(1, 'CECyTE Plantel Magdalena', '21ETC0001A', 1, 'La Libertad', 'Av. Reforma', 1, 'SN', '72130', '2222334455', 'magdalena@cecyte.edu.mx', '07:00:00', '16:00:00'),
(2, 'CECyTE Plantel Huejotzingo', '21ETC0002B', 2, 'Centro', 'Calle Principal', 1, '100', '74160', '2272760000', 'huejotzingo@cecyte.edu.mx', '07:00:00', '15:00:00'),
(3, 'EMSaD Chignahuapan', '21EMS0001C', 3, 'Barrio Teotlalpan', 'Camino Real', 1, '20', '73300', '7979710000', 'emsad.chigna@cecyte.edu.mx', '08:00:00', '14:00:00');

-- Aulas
INSERT INTO `Aula` (`id_aula`, `nombre`, `capacidad`, `id_plantel`) VALUES 
(1, 'Aula 101', 40, 1), 
(2, 'Lab Computo', 30, 1), 
(3, 'Aula EMS-1', 25, 3);

-- ==========================================================
-- 4. ESTRUCTURA ACADÉMICA (Carreras, Planes, Materias)
-- ==========================================================

INSERT INTO `Carrera` (`id_carrera`, `nombre`, `nomenclatura`, `clave`, `estado`, `fechaAlta`) VALUES 
(1, 'Técnico en Desarrollo de Software', 'Software', 'DS-23', 'Activa', '2023-01-01'),
(2, 'Técnico en Mecatrónica', 'Mecatrónica', 'ME-23', 'Activa', '2023-01-01'),
(3, 'Técnico en Procesos de Gestión', 'Gestión', 'TPG-23', 'Activa', '2023-01-01');

INSERT INTO `Carrera_Plantel` (`id_carreraPlantel`, `id_plantel`, `id_carrera`) VALUES 
(1, 1, 1), -- Magdalena tiene Software
(2, 1, 2), -- Magdalena tiene Mecatrónica
(3, 2, 2), -- Huejotzingo tiene Mecatrónica
(4, 3, 3); -- EMSaD tiene Gestión

INSERT INTO `Plan_Estudios` (`id_planEstudios`, `id_carrera`, `clave`, `fecha_inicio`, `estado`) VALUES 
(1, 1, 'PLAN-SW23', '2023-08-01', 'Activo'), 
(2, 2, 'PLAN-MC23', '2023-08-01', 'Activo'),
(3, 3, 'PLAN-GS23', '2023-08-01', 'Activo');

INSERT INTO `Periodo` (`id_periodo`, `año`, `nombre`, `estaActivo`, `fecha_inicio`, `fecha_fin`) VALUES 
(1, '2024-01-01', '2024-B', 1, '2024-08-01 00:00:00', '2025-01-15 23:59:59');

-- Materias
INSERT INTO `Materia` (`id_materia`, `nombre`, `tipo`, `tipo_curriculum`, `credito`, `no_semestre`, `estado`, `id_materiaPadre`) VALUES 
(1, 'Cálculo Diferencial', 'Ordinaria', 'Fundamental', 6, '1', 'Activo', NULL),
(2, 'Inglés Técnico', 'Ordinaria', 'Fundamental', 4, '1', 'Activo', NULL),
(3, 'Física I', 'Ordinaria', 'Fundamental', 5, '1', 'Activo', NULL),
(4, 'Módulo I: Desarrolla Software', 'Modulo', 'Laboral', 10, '1', 'Activo', NULL), -- Padre
(5, 'Submódulo: Programación OO', 'Submodulo', 'Laboral', 10, '1', 'Activo', 4), -- Hijo de 4
(6, 'Habilidades Socioemocionales I', 'Ordinaria', 'Fundamental extendido obligatorio', 2, '1', 'Activo', NULL),
-- Mecatrónica
(7, 'Algebra Lineal', 'Ordinaria', 'Fundamental', 6, '1', 'Activo', NULL),
(8, 'Lectura y Redacción', 'Ordinaria', 'Fundamental', 4, '1', 'Activo', NULL),
(9, 'Química Básica', 'Ordinaria', 'Fundamental', 5, '1', 'Activo', NULL),
(10, 'Módulo I: Circuitos Eléctricos', 'Modulo', 'Laboral', 10, '1', 'Activo', NULL), -- Padre
(11, 'Submódulo: Soldadura', 'Submodulo', 'Laboral', 10, '1', 'Activo', 10), -- Hijo de 10
(12, 'Tutoría y Construye-T', 'Ordinaria', 'Fundamental extendido obligatorio', 2, '1', 'Activo', NULL),
-- Gestión (Extra para movilidad)
(13, 'Administración I', 'Ordinaria', 'Fundamental', 5, '1', 'Activo', NULL);

-- Relación Materia - Periodo - Carrera
INSERT INTO `Materia_Periodo` (`id_materiaPeriodo`, `id_materia`, `id_periodo`, `id_carrera`) VALUES 
(1, 1, 1, 1), (2, 2, 1, 1), (3, 3, 1, 1), (4, 4, 1, 1), (5, 6, 1, 1), -- Software
(6, 7, 1, 2), (7, 8, 1, 2), (8, 9, 1, 2), (9, 10, 1, 2), (10, 12, 1, 2), -- Mecatrónica
(11, 13, 1, 3); -- Gestión

-- Relación Materia - Plan de Estudios
INSERT INTO `Materia_Plan_Estudios` (`id_materiaPlan`, `id_planEstudios`, `id_materia`) VALUES 
(1, 1, 1), (2, 1, 2), (3, 1, 3), (4, 1, 4), (5, 1, 5), (6, 1, 6),
(7, 2, 7), (8, 2, 8), (9, 2, 9), (10, 2, 10), (11, 2, 11), (12, 2, 12),
(13, 3, 13);

-- ==========================================================
-- 5. RECURSOS HUMANOS Y USUARIOS
-- ==========================================================

INSERT INTO `Personal` (`id_personal`, `curp`, `nombre`, `apellido_P`, `apellido_M`, `sexo`, `id_lada`, `telefono`, `grupo_sanguineo`, `fecha_nacimiento`, `seguro_social`, `rfc`, `correo`, `id_municipio`, `colonia`, `calle`, `numero`, `codigo_postal`, `id_plantel`, `puesto`) VALUES 
(1, 'DOC1', 'Juan', 'Pérez', 'Gómez', 'Masculino', 1, '2221111111', 'O positivo', '1980-01-01', 'SS1', 'RFC1', 'juan.p@cecyte.edu.mx', 1, 'Centro', 'C1', '1', '72000', 1, 'Docente'),
(2, 'DOC2', 'María', 'López', 'Rámos', 'Femenino', 1, '2222222222', 'A positivo', '1985-02-02', 'SS2', 'RFC2', 'maria.l@cecyte.edu.mx', 1, 'Centro', 'C2', '2', '72000', 1, 'Docente'),
(3, 'DOC3', 'Pedro', 'Sánchez', 'Díaz', 'Masculino', 1, '2223333333', 'B positivo', '1978-03-03', 'SS3', 'RFC3', 'pedro.s@cecyte.edu.mx', 1, 'Centro', 'C3', '3', '72000', 1, 'Docente'),
(4, 'DOC4', 'Luisa', 'Méndez', 'Torres', 'Femenino', 1, '2224444444', 'O negativo', '1990-04-04', 'SS4', 'RFC4', 'luisa.m@cecyte.edu.mx', 1, 'Centro', 'C4', '4', '72000', 1, 'Docente'),
(5, 'DOC5', 'Roberto', 'García', 'Luna', 'Masculino', 1, '2225555555', 'A negativo', '1982-05-05', 'SS5', 'RFC5', 'roberto.g@cecyte.edu.mx', 1, 'Centro', 'C5', '5', '72000', 1, 'Docente');

-- Usuarios (Generados automáticamente para el personal creado arriba)
INSERT INTO `Usuario` (`username`, `contrasenia`, `correo`, `estado`, `rol`, `id_personal`) VALUES
('admin', 'admin123', 'admin@cecyte.edu.mx', 'Activo', 'Admin', 1), -- Juan Perez como Admin Temporal
('profe.maria', '12345', 'maria.l@cecyte.edu.mx', 'Activo', 'Profesor', 2),
('profe.pedro', '12345', 'pedro.s@cecyte.edu.mx', 'Activo', 'Profesor', 3),
('profe.luisa', '12345', 'luisa.m@cecyte.edu.mx', 'Activo', 'Profesor', 4),
('profe.roberto', '12345', 'roberto.g@cecyte.edu.mx', 'Activo', 'Profesor', 5);

INSERT INTO `Docente` (`id_docente`, `especialidad`, `id_personal`, `id_plantel`) VALUES 
(1, 'Matemáticas', 1, 1), (2, 'Idiomas', 2, 1), (3, 'Ingeniería', 3, 1), (4, 'Psicología', 4, 1), (5, 'Ciencias', 5, 1);

-- ==========================================================
-- 6. GRUPOS Y HORARIOS
-- ==========================================================

INSERT INTO `Grupo` (`id_grupo`, `nombre`, `cupo`, `id_carreraPlantel`) VALUES 
(1, '1A-Software', '40', 1),  -- Magdalena
(2, '1B-Mecatronica', '40', 2), -- Magdalena
(3, '1A-Gestion', '30', 4);   -- EMSaD

-- Cargas Académicas
INSERT INTO `Carga_Academica` (`id_cargaAcademica`, `id_docente`, `id_grupo`, `id_materiaPeriodo`) VALUES 
-- Software
(1, 1, 1, 1), -- Juan da Calculo
(2, 2, 1, 2), -- Maria da Ingles
(3, 3, 1, 3), -- Pedro da Fisica
(4, 3, 1, 4), -- Pedro da Modulo
(5, 4, 1, 5), -- Luisa da Socioemocional
-- Mecatrónica
(6, 1, 2, 6), -- Juan da Algebra
(7, 2, 2, 7), -- Maria da Lectura
(8, 5, 2, 8), -- Roberto da Quimica
(9, 5, 2, 9), -- Roberto da Modulo
(10, 4, 2, 10); -- Luisa da Tutoria

INSERT INTO `Horario` (`dia_semana`, `hora_inicio`, `hora_fin`, `id_aula`, `id_cargaAcademica`) VALUES ('2024-01-01', '08:00:00', '10:00:00', 1, 1);

-- ==========================================================
-- 7. ESTUDIANTES Y ASPIRANTES
-- ==========================================================

INSERT INTO `Padre_Tutor` (`id_padreTutor`, `nombre`, `apellido_P`, `apellido_M`, `id_lada`, `telefono`, `relacion`, `correo`) VALUES 
(1, 'Juan', 'Hernández', 'Ruiz', 1, '5586493728', 'Padre', 'juanUnbuntu@ymail.com');

-- Aspirantes (Se incluye columna promedio_portabilidad explícitamente)
INSERT INTO `Aspirante` (`id_aspirante`, `curp`, `nombre`, `apellido_P`, `apellido_M`, `sexo`, `id_lada`, `telefono`, `grupo_sanguineo`, `fecha_nacimiento`, `correo`, `seguro_social`, `id_municipio`, `id_padreTutor`, `colonia`, `calle`, `numero`, `codigo_postal`, `estado`, `folio_certificado_secu`, `escuela_procedencia`, `fecha_registro`, `tipo_ingreso`, `folio_portabilidad`, `promedio_portabilidad`, `calif_examenAdmi`, `id_plantel`) VALUES 
-- 5 Software (Base)
(1, 'HESG080210HPLRNS01', 'Santiago', 'Hernández', 'Sánchez', 'Masculino', 1, '222', 'O positivo', '2008-01-01', 'santi@mail.com', '1', 1, 1, 'X', 'X', '1', '72', 'Aceptado', 'F1', 'Sec 1', '2024-01-01', 'Nuevo', NULL, NULL, 'AC', 1),
(2, 'CURP_SOFIA', 'Sofía', 'Martínez', 'López', 'Femenino', 1, '222', 'O positivo', '2008-01-01', 'sofia@mail.com', '2', 1, 1, 'X', 'X', '1', '72', 'Aceptado', 'F2', 'Sec 1', '2024-01-01', 'Nuevo', NULL, NULL, 'AC', 1),
(3, 'CURP_MATEO', 'Mateo', 'González', 'Pérez', 'Masculino', 1, '222', 'O positivo', '2008-01-01', 'mateo@mail.com', '3', 1, 1, 'X', 'X', '1', '72', 'Aceptado', 'F3', 'Sec 1', '2024-01-01', 'Nuevo', NULL, NULL, 'AC', 1),
(4, 'CURP_VALE', 'Valentina', 'Rodríguez', 'Ruiz', 'Femenino', 1, '222', 'O positivo', '2008-01-01', 'vale@mail.com', '4', 1, 1, 'X', 'X', '1', '72', 'Aceptado', 'F4', 'Sec 1', '2024-01-01', 'Nuevo', NULL, NULL, 'AC', 1),
(5, 'CURP_PEDRO_RIESGO', 'Pedro', 'Riesgo', 'Software', 'Masculino', 1, '222', 'O positivo', '2008-01-01', 'pedro@mail.com', '5', 1, 1, 'X', 'X', '1', '72', 'Aceptado', 'F5', 'Sec 1', '2024-01-01', 'Nuevo', NULL, NULL, 'AC', 1),
-- 5 Mecatrónica (Base)
(6, 'CURP_LUIS', 'Luis', 'Fernández', 'García', 'Masculino', 1, '222', 'O positivo', '2008-01-01', 'luis@mail.com', '6', 1, 1, 'X', 'X', '1', '72', 'Aceptado', 'F6', 'Sec 1', '2024-01-01', 'Nuevo', NULL, NULL, 'AC', 1),
(7, 'CURP_CAMILA', 'Camila', 'Torres', 'Vargas', 'Femenino', 1, '222', 'O positivo', '2008-01-01', 'camila@mail.com', '7', 1, 1, 'X', 'X', '1', '72', 'Aceptado', 'F7', 'Sec 1', '2024-01-01', 'Nuevo', NULL, NULL, 'AC', 1),
(8, 'CURP_GABRIEL', 'Gabriel', 'Ramírez', 'Castro', 'Masculino', 1, '222', 'O positivo', '2008-01-01', 'gabriel@mail.com', '8', 1, 1, 'X', 'X', '1', '72', 'Aceptado', 'F8', 'Sec 1', '2024-01-01', 'Nuevo', NULL, NULL, 'AC', 1),
(9, 'CURP_NATALIA', 'Natalia', 'Herrera', 'Jiménez', 'Femenino', 1, '222', 'O positivo', '2008-01-01', 'natalia@mail.com', '9', 1, 1, 'X', 'X', '1', '72', 'Aceptado', 'F9', 'Sec 1', '2024-01-01', 'Nuevo', NULL, NULL, 'AC', 1),
(10, 'CURP_FER_RIESGO', 'Fernanda', 'Riesgo', 'Meca', 'Femenino', 1, '222', 'O positivo', '2008-01-01', 'fer@mail.com', '10', 1, 1, 'X', 'X', '1', '72', 'Aceptado', 'F10', 'Sec 1', '2024-01-01', 'Nuevo', NULL, NULL, 'AC', 1),
-- 4 MOVILIDAD (Portabilidad y Traslados)
(11, 'PORT240001HPLRNS01', 'Roberto', 'Porta', 'Bilidad', 'Masculino', 1, '222', 'O positivo', '2008-03-01', 'roberto@mail.com', '11', 1, 1, 'X', 'X', '10', '72', 'Aceptado', 'P1', 'CETIS', '2024-01-20', 'Portabilidad', 'FOL-P-01', 8.5, 'AC', 1),
(12, 'TRAS240002MPLRNS02', 'Ana', 'Traslado', 'Cecyte', 'Femenino', 1, '222', 'A positivo', '2008-04-15', 'ana@mail.com', '12', 2, 1, 'X', 'X', '20', '74', 'Aceptado', 'T1', 'Huejotzingo', '2024-01-21', 'Traslado', NULL, NULL, 'AC', 1),
(13, 'EMSA240003HPLRNS03', 'Carlos', 'Emsad', 'Cecyte', 'Masculino', 1, '222', 'B positivo', '2008-02-10', 'carlos@mail.com', '13', 3, 1, 'X', 'X', '5', '73', 'Aceptado', 'T2', 'Chignahuapan', '2024-01-22', 'Traslado', NULL, NULL, 'AC', 1),
(14, 'CECY240004MPLRNS04', 'Diana', 'Cecyte', 'Emsad', 'Femenino', 1, '222', 'O negativo', '2008-06-20', 'diana@mail.com', '14', 1, 1, 'X', 'X', '30', '72', 'Aceptado', 'T3', 'Magdalena', '2024-01-23', 'Traslado', NULL, NULL, 'AC', 3);

-- Estudiantes
-- 'foto' es MEDIUMBLOB NOT NULL. Se inserta una cadena vacía '' como placeholder válido.
INSERT INTO `Estudiante` (`id_estudianteAspirante`, `matricula`, `id_plantel`, `id_planEstudios`, `id_grupo`, `foto`, `archivoExtra1`, `archivoExtra2`) VALUES 
(1, 'MAT21001', 1, 1, 1, '', NULL, NULL),
(2, 'MAT21002', 1, 1, 1, '', NULL, NULL),
(3, 'MAT21003', 1, 1, 1, '', NULL, NULL),
(4, 'MAT21004', 1, 1, 1, '', NULL, NULL),
(5, 'MAT21005', 1, 1, 1, '', NULL, NULL),
(6, 'MAT21006', 1, 2, 2, '', NULL, NULL),
(7, 'MAT21007', 1, 2, 2, '', NULL, NULL),
(8, 'MAT21008', 1, 2, 2, '', NULL, NULL),
(9, 'MAT21009', 1, 2, 2, '', NULL, NULL),
(10, 'MAT21010', 1, 2, 2, '', NULL, NULL),
-- Movilidad
(11, 'PORT21011', 1, 1, 1, '', NULL, NULL),
(12, 'TRAS21012', 1, 1, 1, '', NULL, NULL),
(13, 'EMSA21013', 1, 1, 1, '', NULL, NULL),
(14, 'CECY21014', 3, 3, 3, '', NULL, NULL);

-- ==========================================================
-- 8. CONTROL ESCOLAR Y EVALUACIONES
-- ==========================================================

-- SANTIAGO (ID 1): Regular
INSERT INTO `Materia_Estudiante` (`id_materiaEstudiante`, `id_materia`, `estado`, `id_estudianteAspirante`) VALUES 
(1, 1, 'Cursando', 1), (2, 2, 'Cursando', 1), (3, 3, 'Cursando', 1), (4, 4, 'Cursando', 1), (5, 6, 'Aprobada', 1);

INSERT INTO `Calificacion` (`id_calificacion`, `acreditado`, `parcial1`, `parcial2`, `calif_final`, `id_materiaEstudiante`) VALUES 
(1, NULL, 8.0, 9.0, NULL, 1), (2, NULL, 9.0, 9.0, NULL, 2), (3, NULL, 7.5, 8.0, NULL, 3), (4, NULL, 10.0, 9.5, NULL, 4), (5, 'AC', NULL, NULL, NULL, 5);

-- PEDRO RIESGO (ID 5): >2 Reprobadas
INSERT INTO `Materia_Estudiante` (`id_materiaEstudiante`, `id_materia`, `estado`, `id_estudianteAspirante`) VALUES 
(10, 1, 'Reprobada', 5), (11, 2, 'Reprobada', 5), (12, 3, 'Reprobada', 5), (13, 4, 'Cursando', 5), (14, 6, 'Reprobada', 5);

INSERT INTO `Calificacion` (`id_calificacion`, `acreditado`, `parcial1`, `parcial2`, `calif_final`, `id_materiaEstudiante`) VALUES 
(10, NULL, 5.0, 4.0, 5.0, 10), (11, NULL, 3.0, 5.0, 4.0, 11), (12, NULL, 4.0, 4.0, 4.0, 12), (13, NULL, 8.0, 7.0, NULL, 13), (14, 'NAC', NULL, NULL, NULL, 14);

-- FERNANDA RIESGO (ID 10): >2 Reprobadas
INSERT INTO `Materia_Estudiante` (`id_materiaEstudiante`, `id_materia`, `estado`, `id_estudianteAspirante`) VALUES 
(20, 7, 'Reprobada', 10), (21, 8, 'Reprobada', 10), (22, 9, 'Reprobada', 10), (23, 10, 'Aprobada', 10), (24, 12, 'Aprobada', 10);

INSERT INTO `Calificacion` (`id_calificacion`, `acreditado`, `parcial1`, `calif_final`, `id_materiaEstudiante`) VALUES 
(20, NULL, 4.0, 4.0, 20), (21, NULL, 5.0, 5.0, 21), (22, NULL, 3.0, 3.0, 22), (23, NULL, 9.0, 9.0, 23), (24, 'AC', NULL, NULL, 24);

-- REVALIDACION (Roberto - ID 11)
INSERT INTO `Revalidacion` (`nombre_materiaOrigen`, `calificacion_obtenida`, `creditos_otorgados`, `fecha_revalidacion`, `id_materia`, `id_estudianteAspirante`) VALUES 
('Logica Previa', 9.0, 10, '2024-01-20', 4, 11);

-- EVALUACION DOCENTE
INSERT INTO `Cuestionario_Docente` (`id_cuestionarioDocente`, `titulo`, `fecha`) VALUES (1, 'Eval 2024', '2024-06-01');
INSERT INTO `Pregunta` (`id_pregunta`, `texto_pregunta`, `orden`, `id_cuestionario_Docente`) VALUES (1, 'Dominio del tema', 1, 1);
INSERT INTO `Evaluacion_Docente` (`id_evaluacionDocente`, `fecha`, `comentario`, `estado`, `id_docente`, `id_materia`, `id_estudianteAspirante`, `id_cuestionarioDocente`) VALUES (1, '2024-06-01', 'Bien', 'Activa', 1, 1, 1, 1);
INSERT INTO `Respuesta` (`calificacion_escala`, `id_pregunta`) VALUES (5, 1);

-- 9. FINALIZAR
-- Reactivar las llaves foráneas y comprobaciones
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;