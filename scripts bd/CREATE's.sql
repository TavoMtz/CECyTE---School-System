USE `mydb`;

-- ==========================================================
-- BLOQUE 1: GESTIÓN ACADÉMICA (Horarios y Profesores)
-- ==========================================================

-- 1. REPORTE DE HORARIO DETALLADO
SELECT 
    h.dia_semana, 
    TIME_FORMAT(h.hora_inicio, '%H:%i') AS Inicio, 
    TIME_FORMAT(h.hora_fin, '%H:%i') AS Fin, 
    m.nombre AS Materia, 
    au.nombre AS Aula,
    CONCAT(per.nombre, ' ', per.apellido_P) AS Docente
FROM Horario h
JOIN Carga_Academica ca ON h.id_cargaAcademica = ca.id_cargaAcademica
JOIN Grupo g ON ca.id_grupo = g.id_grupo
JOIN Carrera_Plantel cp ON g.id_carreraPlantel = cp.id_carreraPlantel
JOIN Plantel pl ON cp.id_plantel = pl.id_plantel
JOIN Carrera car ON cp.id_carrera = car.id_carrera
JOIN Materia_Periodo mp ON ca.id_materiaPeriodo = mp.id_materiaPeriodo -- Corregido
JOIN Materia m ON mp.id_materia = m.id_materia
JOIN Docente d ON ca.id_docente = d.id_docente
JOIN Personal per ON d.id_personal = per.id_personal
JOIN Aula au ON h.id_aula = au.id_aula
WHERE g.nombre = '1A-Software'      
  AND pl.id_plantel = 1             
  AND car.nomenclatura = 'Software' 
ORDER BY h.dia_semana, h.hora_inicio;

-- 2. DISPONIBILIDAD DOCENTE POR MATERIA
SELECT 
    m.nombre AS Materia, 
    COUNT(DISTINCT ca.id_docente) AS Cantidad_Docentes
FROM Materia m
JOIN Materia_Periodo mp ON m.id_materia = mp.id_materia
JOIN Carga_Academica ca ON mp.id_materiaPeriodo = ca.id_materiaPeriodo -- Corregido
JOIN Periodo p ON mp.id_periodo = p.id_periodo
WHERE p.estaActivo = 1 
GROUP BY m.nombre;


-- ==========================================================
-- BLOQUE 2: SEGUIMIENTO AL ESTUDIANTE (Kardex y Boletas)
-- ==========================================================

-- 3. CARGA ACADÉMICA ACTUAL
SELECT 
    e.matricula, e.id_grupo,
    CONCAT(asp.nombre, ' ', asp.apellido_P) AS Alumno,
    m.nombre AS Materia, 
    me.estado AS Estatus
FROM Materia_Estudiante me
JOIN Materia m ON me.id_materia = m.id_materia
JOIN Estudiante e ON me.id_estudianteAspirante = e.id_estudianteAspirante
JOIN Aspirante asp ON e.id_estudianteAspirante = asp.id_aspirante
WHERE asp.curp = 'HESG080210HPLRNS01' 
AND me.estado = 'Cursando';

-- 4. BOLETA DE CALIFICACIONES
SELECT 
    m.nombre AS Materia, e.matricula,
    COALESCE(c.parcial1, '-') AS P1,
    COALESCE(c.parcial2, '-') AS P2,
    COALESCE(c.parcial3, '-') AS P3,
    COALESCE(c.calif_final, 'Pendiente') AS Promedio_Final
FROM Calificacion c
JOIN Materia_Estudiante me ON c.id_materiaEstudiante = me.id_materiaEstudiante
JOIN Materia m ON me.id_materia = m.id_materia
JOIN Estudiante e ON me.id_estudianteAspirante = e.id_estudianteAspirante
JOIN Aspirante a ON e.id_estudianteAspirante = a.id_aspirante
WHERE a.curp = 'HESG080210HPLRNS01'; 

-- 5. REPORTE DE ALUMNOS EN RIESGO ACADÉMICO
SELECT 
    e.matricula,
    CONCAT(asp.nombre, ' ', asp.apellido_P) AS Alumno,
    pl.nombre AS Plantel,
    COUNT(me.id_materia) AS Materias_Reprobadas
FROM Materia_Estudiante me
JOIN Estudiante e ON me.id_estudianteAspirante = e.id_estudianteAspirante
JOIN Aspirante asp ON e.id_estudianteAspirante = asp.id_aspirante
JOIN Plantel pl ON e.id_plantel = pl.id_plantel
WHERE me.estado = 'Reprobada'
GROUP BY e.id_estudianteAspirante, e.matricula, Alumno, Plantel
HAVING Materias_Reprobadas > 2;


-- ==========================================================
-- BLOQUE 3: CONTROL ESCOLAR Y TRÁMITES
-- ==========================================================

-- 6. HISTORIAL DE REVALIDACIONES (PORTABILIDAD)
SELECT 
    e.matricula,
    CONCAT(a.nombre, ' ', a.apellido_P) AS Alumno,
    a.escuela_procedencia,
    r.nombre_materiaOrigen AS Materia_Externa,
    r.calificacion_obtenida AS Calif_Externa,
    m.nombre AS Equivalencia_CECyTE
FROM Estudiante e
JOIN Aspirante a ON e.id_estudianteAspirante = a.id_aspirante
JOIN Revalidacion r ON e.id_estudianteAspirante = r.id_estudianteAspirante
JOIN Materia m ON r.id_materia = m.id_materia;

-- 7. REPORTE DE MOVILIDAD Y NUEVO INGRESO
SELECT 
    CONCAT(a.nombre, ' ', a.apellido_P) AS Aspirante,
    a.escuela_procedencia AS Origen,
    p.nombre AS Plantel_Destino,
    a.tipo_ingreso
FROM Aspirante a
JOIN Plantel p ON a.id_plantel = p.id_plantel -- Corregido
WHERE a.tipo_ingreso IN ('Traslado', 'Nuevo', 'Portabilidad')
ORDER BY p.nombre;


-- ==========================================================
-- BLOQUE 4: REPORTES DIRECTIVOS (Estadísticas)
-- ==========================================================

-- 8. ESTADÍSTICA DE DEMANDA POR PLANTEL
SELECT 
    p.nombre AS Plantel,
    COUNT(a.id_aspirante) AS Total_Aspirantes,
    SUM(CASE WHEN a.estado = 'Aceptado' THEN 1 ELSE 0 END) AS Aceptados,
    SUM(CASE WHEN a.estado = 'Rechazado' THEN 1 ELSE 0 END) AS Rechazados
FROM Plantel p
LEFT JOIN Aspirante a ON p.id_plantel = a.id_plantel -- Corregido
GROUP BY p.id_plantel, p.nombre
ORDER BY Total_Aspirantes DESC;

-- 9. RESULTADOS DE EVALUACIÓN DOCENTE
SELECT 
    CONCAT(per.nombre, ' ', per.apellido_P) AS Docente,
    m.nombre AS Materia,
    pre.texto_pregunta,
    AVG(r.calificacion_escala) AS Calificacion_Promedio
FROM Evaluacion_Docente ed
JOIN Docente d ON ed.id_docente = d.id_docente
JOIN Personal per ON d.id_personal = per.id_personal
JOIN Materia m ON ed.id_materia = m.id_materia
JOIN Pregunta pre ON ed.id_cuestionarioDocente = pre.id_cuestionario_Docente
JOIN Respuesta r ON pre.id_pregunta = r.id_pregunta
GROUP BY 
    per.nombre, 
    per.apellido_P, 
    m.nombre, 
    pre.id_pregunta, 
    pre.texto_pregunta;
-- 10. DATOS DE DOCENTE POR PLANTEL
SELECT 
    concat(p.nombre, ' ', p.apellido_P, ' ', p.apellido_M) AS Docente,
    d.especialidad AS Especialidad,
    p.sexo AS Sexo,
    pl.nombre AS Plantel,
    p.rfc AS RFC,
    concat(l.lada, ' ', p.telefono) AS Telefono
FROM Personal p
    JOIN Docente d ON p.id_personal = d.id_personal
    JOIN Plantel pl ON p.id_plantel = pl.id_plantel
    JOIN Lada l ON p.id_lada = l.id_lada
WHERE p.puesto = 'Docente';

-- 11. DATOS DE PERSONAL POR PLANTEL
SELECT 
    concat(p.nombre, ' ', p.apellido_P, ' ', p.apellido_M) AS Personal,
    p.sexo AS Sexo,
    pl.nombre AS Plantel,
    p.rfc AS RFC,
    concat(l.lada, ' ', p.telefono) AS Telefono,
    p.puesto AS Puesto
FROM Personal p
    JOIN Plantel pl ON p.id_plantel = pl.id_plantel
    JOIN Lada l ON p.id_lada = l.id_lada;
    
-- 12. MATERIAS QUE IMPARTE CADA DOCENTE
SELECT 
    concat(p.nombre, ' ', p.apellido_P, ' ', p.apellido_M) AS Docente,
    m.nombre AS "Nombre Materia",
    pl.nombre AS Plantel
FROM Personal p
    JOIN Docente d ON p.id_personal = d.id_personal
    JOIN Plantel pl ON p.id_plantel = pl.id_plantel
    JOIN Carga_Academica ca ON d.id_docente = ca.id_docente
    JOIN Materia_Periodo mp ON ca.id_materiaPeriodo = mp.id_materiaPeriodo -- Corregido
    JOIN Materia m ON mp.id_materia = m.id_materia
WHERE p.puesto = 'Docente';

-- 13. ALUMNOS POR GRUPO
SELECT 
    g.nombre AS Grupo,
    c.nombre AS Carrera,
    count(e.id_estudianteAspirante) AS "Estudiantes en grupo"
FROM Grupo g
    JOIN Estudiante e ON g.id_grupo = e.id_grupo
    JOIN Carrera_Plantel cp ON g.id_carreraPlantel = cp.id_carreraPlantel
    JOIN Carrera c ON cp.id_carrera = c.id_carrera
WHERE g.id_grupo = 1;

-- 14. INFORMACION ESTUDIANTE PARA TARJETA FISICA
SELECT 
    e.matricula,
    concat(a.nombre, ' ', a.apellido_P, ' ', a.apellido_M) AS Estudiante,
    a.sexo AS Sexo,
    c.nombre AS Carrera,
    p.nombre AS Plantel
FROM Aspirante a
    JOIN Estudiante e ON a.id_aspirante = e.id_estudianteAspirante
    JOIN Plan_Estudios pe ON e.id_planEstudios = pe.id_planEstudios -- Corregido
    JOIN Carrera c ON pe.id_carrera = c.id_carrera
    JOIN Plantel p ON e.id_plantel = p.id_plantel
WHERE e.id_estudianteAspirante = 1;