# Especificación de Requerimientos de Software (ERS)
## Sistema de Control Escolar Integral (CECyTE / EMSaD)

| Metadatos | Detalle |
| :--- | :--- |
| **Versión** | 1.1.0 |
| **Estado** | En Desarrollo |
| **Fecha** | 18/12/2025 |
| **Alcance** | Multi-plantel, Control Escolar, Académico |

---

## 1. Introducción
El propósito del sistema es gestionar la información administrativa y académica de los planteles CECyTE. El sistema centralizará el ciclo de vida del estudiante desde su etapa de **aspirante** hasta su **titulación**, manejando reglas complejas de revalidación, recursamientos y módulos profesionales.

### 1.1 Objetivos Específicos
* Gestionar matrículas y expedientes digitales para reducir el uso de papel.
* Automatizar el cálculo de promedios aplicando reglas de redondeo y seriación.
* Controlar los candados de reinscripción (máximo de reprobadas y adeudos).
* Distinguir procesos de ingreso: Nuevo Ingreso vs. Portabilidad vs. Traslado.

---

## 2. Actores y Roles

| Rol | Descripción |
| :--- | :--- |
| **Administrador General** | Configuración de planteles, periodos, planes de estudio y usuarios globales. |
| **Control Escolar** | Encargado operativo por plantel. Gestiona inscripciones, valida documentos (expediente), procesa bajas y emite boletas. |
| **Docente** | Captura calificaciones y asistencias de los grupos asignados. |
| **Estudiante** | Consulta de historial académico, horario y estatus de reinscripción. |
| **Aspirante** | Usuario temporal que realiza el registro para el examen de admisión. |

---

## 3. Requerimientos Funcionales (RF)

### Módulo A: Admisión (Aspirantes)
*Basado en el flujo de "Ficha de Admisión" y "Examen".*

| ID | Requerimiento | Prioridad | Criterios de Aceptación |
| :--- | :--- | :--- | :--- |
| **RF-001** | **Registro de Aspirantes** | Alta | Formulario público para capturar datos generales, CURP y secundaria de procedencia. |
| **RF-002** | **Generación de Ficha de Admisión** | Alta | Generar PDF con folio único, fecha de examen y requisitos de pago tras el registro. |
| **RF-003** | **Conversión Aspirante a Estudiante** | Alta | Migrar datos de aspirantes aceptados (Examen >= 8.0) al módulo de estudiantes, generando matrícula automática. |

### Módulo B: Control Escolar e Inscripción
*Integra reglas de Portabilidad, Traslados y Candados.*

| ID | Requerimiento | Prioridad | Criterios de Aceptación |
| :--- | :--- | :--- | :--- |
| **RF-010** | **Gestión de Expediente Digital** | Alta | Carga y validación de documentos (Acta, Certificado Secundaria, CURP). |
| **RF-011** | **Inscripción (Nuevo Ingreso)** | Alta | Asignación automática de matrícula formato: `[AÑO][PLANTEL][CONSECUTIVO]`. |
| **RF-012** | **Registro por Portabilidad** | Media | Inscripción manual para alumnos externos (semestres avanzados). Permite asignar matrícula manualmente y cargar "Certificado Parcial". |
| **RF-013** | **Traslado de Plantel** | Media | Mover expediente digital de un plantel A a un plantel B conservando matrícula e historial. |
| **RF-014** | **Reinscripción Semestral** | Alta | Bloquear reinscripción si el alumno tiene >2 asignaturas reprobadas o estatus de baja. |
| **RF-015** | **Gestión de Bajas** | Media | Registrar bajas Temporales (max 5 años) o Definitivas. Liberar cupo en grupo actual. |

### Módulo C: Gestión Académica y Evaluación
*Cubre materias, módulos y reglas de calificación.*

| ID | Requerimiento | Prioridad | Criterios de Aceptación |
| :--- | :--- | :--- | :--- |
| **RF-020** | **Gestión de Planes de Estudio** | Alta | Configurar Asignaturas (Básicas) y Módulos Profesionales (con Submódulos). |
| **RF-021** | **Captura de Calificaciones** | Alta | Docentes capturan 3 parciales + Ordinario. Validación de rango 5.0 a 10.0. |
| **RF-022** | **Cálculo de Promedios y Redondeo** | Crítica | Aplicar regla: `.0` a `.4` baja, `.5` a `.9` sube (Solo para calificaciones aprobatorias >6). El 5 no promedia ni redondea. |
| **RF-023** | **Regularización (Extraordinarios)** | Alta | Permitir captura de calificaciones de extraordinario solo si materias reprobadas <= 3. |
| **RF-024** | **Recursamientos** | Media | Asignar carga académica adicional a alumnos con 1 o 2 materias reprobadas del ciclo anterior. |

### Módulo D: Reportes y Titulación

| ID | Requerimiento | Prioridad | Criterios de Aceptación |
| :--- | :--- | :--- | :--- |
| **RF-030** | **Boleta de Calificaciones** | Alta | PDF con calificaciones parciales, inasistencias y promedio final. |
| **RF-031** | **Historial Académico (Kárdex)** | Alta | Reporte completo de materias cursadas, indicando tipo de aprobación (Ordinario, Extra, Recursamiento). |
| **RF-032** | **Validación de Titulación** | Baja | Determinar estatus: "Titulación Automática" (Módulos >8.0) o "Prototipo Didáctico" (Módulos 6.0-7.9). |
| **RF-033** | **Reporte de Índices de Reprobación** | Media | Estadísticas de reprobados por plantel, grupo y asignatura. |

---

## 4. Reglas de Negocio (Business Rules)
Restricciones lógicas estrictas extraídas de la normativa institucional.

### Inscripción y Permanencia
* **RN-01 (Unicidad):** Un estudiante solo puede pertenecer a un único plantel y grupo activo a la vez.
* **RN-02 (Candado de Reprobación):** El límite máximo de materias reprobadas para permitir reinscripción es **2 asignaturas**. Con 3 o más, el alumno causa baja temporal/académica.
* **RN-03 (Límite Módulos):** Para componentes profesionales, el máximo de submódulos reprobados permitidos es **2**.
* **RN-04 (Temporalidad):** El tiempo máximo para concluir el bachillerato es de **5 años**.
* **RN-05 (Asistencia):** Se requiere un **80% de asistencia** mínima para tener derecho a calificación ordinaria.

### Evaluación
* **RN-06 (Escala):** La calificación mínima aprobatoria es **6.0**. La calificación reprobatoria es **5.0** (El 5 no se redondea ni promedia).
* **RN-07 (Redondeo):** Las calificaciones finales aprobatorias con decimales `.5` suben al entero superior; `.4` bajan al inferior.
* **RN-08 (Titulación):**
    * Promedio Modular >= 8.0: Titulación Automática.
    * Promedio Modular 6.0 - 7.9: Requiere Prototipo Didáctico.
    * Promedio Modular < 6.0: No se titula.

### Administrativas
* **RN-09 (Matrícula):** La matrícula de Nuevo Ingreso es automática. La matrícula de Portabilidad se asigna manualmente pero debe validarse contra duplicados.
* **RN-10 (Turnos):** El sistema solo contemplará configuración para **Turno Matutino** (según operación actual).

---

## 5. Requerimientos No Funcionales (RNF)

| ID | Categoría | Descripción |
| :--- | :--- | :--- |
| **RNF-01** | **Disponibilidad** | Soporte para concurrencia de mín. 400 usuarios simultáneos (periodos de inscripción). |
| **RNF-02** | **Integridad** | Evitar redundancia de datos personales (validación por CURP única en todo el sistema). |
| **RNF-03** | **Seguridad** | Roles y permisos estrictos. Contraseñas hash (bcrypt). Bitácora de cambios en calificaciones. |
| **RNF-04** | **Compatibilidad** | Accesible desde navegadores modernos y equipos antiguos (Windows legacy) con bajo consumo de recursos. |
| **RNF-05** | **Escalabilidad** | Arquitectura preparada para agregar nuevos planteles sin modificar el código fuente. |

---