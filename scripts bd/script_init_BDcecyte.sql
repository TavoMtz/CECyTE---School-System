-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `mydb` ;

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `mydb` DEFAULT CHARACTER SET utf8 ;
SHOW WARNINGS;
-- -----------------------------------------------------
-- Schema sakila
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `sakila` ;

-- -----------------------------------------------------
-- Schema sakila
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `sakila` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci ;
SHOW WARNINGS;
USE `mydb` ;

-- -----------------------------------------------------
-- Table `mydb`.`Pais`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`Pais` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `mydb`.`Pais` (
  `id_pais` INT NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(45) NOT NULL,
  `nacionalidad` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id_pais`),
  UNIQUE INDEX `nombre_UNIQUE` (`nombre` ASC) VISIBLE,
  UNIQUE INDEX `nacionalidad_UNIQUE` (`nacionalidad` ASC) VISIBLE)
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `mydb`.`Estado`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`Estado` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `mydb`.`Estado` (
  `id_estado` INT NOT NULL AUTO_INCREMENT,
  `Nombre` VARCHAR(45) NOT NULL,
  `id_pais` INT NOT NULL,
  PRIMARY KEY (`id_estado`),
  UNIQUE INDEX `Nombre_UNIQUE` (`Nombre` ASC) VISIBLE,
  INDEX `fk_Estado_Pais1_idx` (`id_pais` ASC) VISIBLE,
  CONSTRAINT `fk_Estado_Pais1`
    FOREIGN KEY (`id_pais`)
    REFERENCES `mydb`.`Pais` (`id_pais`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `mydb`.`Municipio`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`Municipio` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `mydb`.`Municipio` (
  `id_municipio` INT NOT NULL,
  `nombre` VARCHAR(45) NOT NULL,
  `id_estado` INT NOT NULL,
  PRIMARY KEY (`id_municipio`),
  UNIQUE INDEX `nombre_UNIQUE` (`nombre` ASC) VISIBLE,
  INDEX `fk_Municipio_Estado1_idx` (`id_estado` ASC) VISIBLE,
  UNIQUE INDEX `id_municipio_UNIQUE` (`id_municipio` ASC) VISIBLE,
  CONSTRAINT `fk_Municipio_Estado1`
    FOREIGN KEY (`id_estado`)
    REFERENCES `mydb`.`Estado` (`id_estado`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `mydb`.`Lada`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`Lada` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `mydb`.`Lada` (
  `id_lada` INT NOT NULL AUTO_INCREMENT,
  `lada` VARCHAR(3) NULL DEFAULT '+52',
  PRIMARY KEY (`id_lada`),
  UNIQUE INDEX `id_lada_UNIQUE` (`id_lada` ASC) VISIBLE)
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `mydb`.`Padre_Tutor`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`Padre_Tutor` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `mydb`.`Padre_Tutor` (
  `id_padreTutor` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(45) NOT NULL,
  `apellido_P` VARCHAR(30) NOT NULL,
  `apellido_M` VARCHAR(30) NOT NULL,
  `id_lada` INT NOT NULL,
  `telefono` VARCHAR(10) NOT NULL,
  `relacion` ENUM('Padre', 'Madre', 'Tutor Legal') NOT NULL COMMENT 'Parentesco con el aspirante/estudiante',
  `correo` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id_padreTutor`),
  INDEX `fk_Padre_Tutor_Lada1_idx` (`id_lada` ASC) VISIBLE,
  CONSTRAINT `fk_Padre_Tutor_Lada1`
    FOREIGN KEY (`id_lada`)
    REFERENCES `mydb`.`Lada` (`id_lada`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `mydb`.`Aspirante`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`Aspirante` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `mydb`.`Aspirante` (
  `id_aspirante` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `curp` CHAR(18) NOT NULL,
  `nombre` VARCHAR(45) NOT NULL,
  `apellido_P` VARCHAR(45) NOT NULL,
  `apellido_M` VARCHAR(45) NOT NULL,
  `sexo` ENUM('Masculino', 'Femenino') NOT NULL,
  `id_lada` INT NOT NULL,
  `telefono` VARCHAR(10) NOT NULL,
  `grupo_sanguineo` ENUM('O positivo', 'O negativo', 'A positivo', 'A negativo', 'B positivo', 'B negativo', 'AB positivo', 'AB negarivo') NOT NULL,
  `fecha_nacimiento` DATE NOT NULL,
  `correo` VARCHAR(45) NOT NULL,
  `seguro_social` CHAR(11) NOT NULL,
  `id_municipio` INT NOT NULL,
  `id_padreTutor` INT NOT NULL COMMENT 'ID de su padre o tutor, solo en caso de que cuando ingrese el alumno sea menor de edad.',
  `colonia` VARCHAR(45) NOT NULL,
  `calle` VARCHAR(45) NOT NULL,
  `numero` VARCHAR(45) NOT NULL,
  `codigo_postal` VARCHAR(45) NOT NULL,
  `estado` ENUM('Aceptado', 'Rechazado') NOT NULL COMMENT 'Estado en sistema. Si fue aceptado o rechazado como estudiante.',
  `folio_certificado_secu` VARCHAR(45) NOT NULL,
  `escuela_procedencia` VARCHAR(45) NOT NULL,
  `fecha_registro` DATE NOT NULL COMMENT 'Investigar para que la usamos ',
  `tipo_ingreso` ENUM('Portabilidad', 'Traslado', 'Nuevo') NOT NULL DEFAULT 'Nuevo' COMMENT 'Por portabilidad (otra prepa -> cecyte), por traslado (cecyte -> cecyte) y nuevo (nuevo ingreso)',
  `folio_portabilidad` VARCHAR(45) NULL,
  `promedio_portabilidad` FLOAT NULL,
  `calif_examenAdmi` ENUM('AC', 'NAC') NOT NULL COMMENT 'Calif examen de admision, si es traslado o portabilidad les pone AC (acreditado). Solo nuevo ingreso lo realiza. ',
  PRIMARY KEY (`id_aspirante`),
  UNIQUE INDEX `CURP_UNIQUE` (`curp` ASC) VISIBLE,
  INDEX `fk_Persona_Municipio1_idx` (`id_municipio` ASC) VISIBLE,
  UNIQUE INDEX `seguro_social_UNIQUE` (`seguro_social` ASC) VISIBLE,
  INDEX `fk_Aspirante_Lada1_idx` (`id_lada` ASC) VISIBLE,
  UNIQUE INDEX `id_aspirante_UNIQUE` (`id_aspirante` ASC) VISIBLE,
  INDEX `fk_Aspirante_Padre_Tutor1_idx` (`id_padreTutor` ASC) VISIBLE,
  CONSTRAINT `fk_Persona_Municipio1`
    FOREIGN KEY (`id_municipio`)
    REFERENCES `mydb`.`Municipio` (`id_municipio`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Aspirante_Lada1`
    FOREIGN KEY (`id_lada`)
    REFERENCES `mydb`.`Lada` (`id_lada`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Aspirante_Padre_Tutor1`
    FOREIGN KEY (`id_padreTutor`)
    REFERENCES `mydb`.`Padre_Tutor` (`id_padreTutor`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `mydb`.`Plantel`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`Plantel` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `mydb`.`Plantel` (
  `id_plantel` TINYINT NOT NULL,
  `nombre` VARCHAR(45) NOT NULL,
  `clave` VARCHAR(30) NOT NULL,
  `id_municipio` INT NOT NULL,
  `colonia` VARCHAR(45) NOT NULL,
  `calle` VARCHAR(45) NOT NULL,
  `id_lada` INT NOT NULL,
  `numero` VARCHAR(45) NOT NULL,
  `codigo_postal` VARCHAR(5) NOT NULL,
  `telefono` VARCHAR(10) NOT NULL,
  `correo` VARCHAR(45) NOT NULL,
  `horario_apertura` TIME NULL,
  `horario_cierre` TIME NULL,
  PRIMARY KEY (`id_plantel`),
  INDEX `fk_Plantel_Municipio1_idx` (`id_municipio` ASC) VISIBLE,
  INDEX `fk_Plantel_Lada1_idx` (`id_lada` ASC) VISIBLE,
  CONSTRAINT `fk_Plantel_Municipio1`
    FOREIGN KEY (`id_municipio`)
    REFERENCES `mydb`.`Municipio` (`id_municipio`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Plantel_Lada1`
    FOREIGN KEY (`id_lada`)
    REFERENCES `mydb`.`Lada` (`id_lada`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `mydb`.`Carrera`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`Carrera` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `mydb`.`Carrera` (
  `id_carrera` INT NOT NULL,
  `nombre` VARCHAR(45) NOT NULL,
  `nomenclatura` VARCHAR(45) NOT NULL COMMENT 'El Alias de la carrera',
  `clave` VARCHAR(10) NOT NULL COMMENT 'Clave de la carrera ante COSFAC',
  `estado` ENUM('Activa', 'Inactiva') NOT NULL DEFAULT 'Activa',
  `fechaAlta` DATE NOT NULL COMMENT 'Fecha de actualizacion',
  PRIMARY KEY (`id_carrera`),
  UNIQUE INDEX `alias_UNIQUE` (`nomenclatura` ASC) VISIBLE)
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `mydb`.`Plan_Estudios`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`Plan_Estudios` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `mydb`.`Plan_Estudios` (
  `id_plan_Estudios` INT NOT NULL AUTO_INCREMENT,
  `id_carrera` INT NOT NULL,
  `clave` VARCHAR(10) NOT NULL COMMENT 'Los planes de estudio vienen marcados con una clave de 10 caracteres',
  `fecha_inicio` DATE NOT NULL,
  `fecha_fin` DATE NULL,
  `estado` ENUM('Activo', 'Vencido') NOT NULL DEFAULT 'Activo' COMMENT 'El estado del plan de estudios, se marca activo por defecto y si llega otro para futuros anos, se marca como inactivo (pasado) y se inserta uno nuevo.',
  PRIMARY KEY (`id_plan_Estudios`),
  UNIQUE INDEX `clave_UNIQUE` (`clave` ASC) VISIBLE,
  INDEX `fk_Plan_Estudios_Carrera1_idx` (`id_carrera` ASC) VISIBLE,
  CONSTRAINT `fk_Plan_Estudios_Carrera1`
    FOREIGN KEY (`id_carrera`)
    REFERENCES `mydb`.`Carrera` (`id_carrera`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `mydb`.`Grupo`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`Grupo` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `mydb`.`Grupo` (
  `id_grupo` INT NOT NULL,
  `nombre` VARCHAR(45) NOT NULL,
  `cupo` VARCHAR(45) NOT NULL COMMENT 'Limite de estudiante',
  `id_plantel` TINYINT NOT NULL,
  PRIMARY KEY (`id_grupo`),
  INDEX `fk_Grupo_Plantel1_idx` (`id_plantel` ASC) VISIBLE,
  CONSTRAINT `fk_Grupo_Plantel1`
    FOREIGN KEY (`id_plantel`)
    REFERENCES `mydb`.`Plantel` (`id_plantel`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `mydb`.`Estudiante`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`Estudiante` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `mydb`.`Estudiante` (
  `id_estudianteAspirante` INT UNSIGNED NOT NULL,
  `matricula` VARCHAR(20) NOT NULL,
  `id_plantel` TINYINT NOT NULL,
  `id_planEstudios` INT NOT NULL,
  `id_grupo` INT NOT NULL,
  INDEX `fk_Estudiante_Plantel1_idx` (`id_plantel` ASC) VISIBLE,
  UNIQUE INDEX `matricula_UNIQUE` (`matricula` ASC) VISIBLE,
  INDEX `fk_Estudiante_Plan_Estudios1_idx` (`id_planEstudios` ASC) VISIBLE,
  PRIMARY KEY (`id_estudianteAspirante`),
  INDEX `fk_Estudiante_Grupo1_idx` (`id_grupo` ASC) VISIBLE,
  CONSTRAINT `fk_Estudiante_Plantel1`
    FOREIGN KEY (`id_plantel`)
    REFERENCES `mydb`.`Plantel` (`id_plantel`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Estudiante_Plan_Estudios1`
    FOREIGN KEY (`id_planEstudios`)
    REFERENCES `mydb`.`Plan_Estudios` (`id_plan_Estudios`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Estudiante_Aspirante1`
    FOREIGN KEY (`id_estudianteAspirante`)
    REFERENCES `mydb`.`Aspirante` (`id_aspirante`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Estudiante_Grupo1`
    FOREIGN KEY (`id_grupo`)
    REFERENCES `mydb`.`Grupo` (`id_grupo`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `mydb`.`Baja`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`Baja` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `mydb`.`Baja` (
  `id_baja` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `tipo` ENUM('Temporal', 'Definitiva') NOT NULL,
  `fecha_inicio` TIMESTAMP NOT NULL,
  `fecha_fin` TIMESTAMP NULL,
  `solicito_certificadoParcial` TINYINT NOT NULL DEFAULT 0,
  `id_estudianteAspirante` INT UNSIGNED NOT NULL COMMENT 'id_EstudianteAspirante es la clave primaria del estudiante que viene desde Aspirante->Estudiante',
  PRIMARY KEY (`id_baja`),
  INDEX `fk_Baja_Estudiante1_idx` (`id_estudianteAspirante` ASC) VISIBLE,
  CONSTRAINT `fk_Baja_Estudiante1`
    FOREIGN KEY (`id_estudianteAspirante`)
    REFERENCES `mydb`.`Estudiante` (`id_estudianteAspirante`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `mydb`.`Periodo`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`Periodo` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `mydb`.`Periodo` (
  `id_periodo` INT NOT NULL,
  `año` DATE NOT NULL,
  `nombre` VARCHAR(10) NOT NULL,
  `estaActivo` TINYINT(2) NOT NULL DEFAULT 1 COMMENT 'El periodo esta activo 1, inactivo 0. Por defecto se marca activo.',
  `fecha_inicio` TIMESTAMP NOT NULL,
  `fecha_fin` TIMESTAMP NOT NULL,
  PRIMARY KEY (`id_periodo`))
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `mydb`.`Perido_Estudiante`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`Perido_Estudiante` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `mydb`.`Perido_Estudiante` (
  `id_periodoEstudiante` INT NOT NULL AUTO_INCREMENT,
  `concluido` TINYINT(2) NOT NULL DEFAULT 0 COMMENT 'El periodo ya fue cursado por el estudiante (1) o lo esta cursando (0)',
  `id_periodo` INT NOT NULL,
  `id_estudianteAspirante` INT UNSIGNED NOT NULL COMMENT 'id_EstudianteAspirante es la clave primaria del estudiante que viene desde Aspirante->Estudiante\n',
  PRIMARY KEY (`id_periodoEstudiante`),
  INDEX `fk_Perido_Estudiante_Periodo1_idx` (`id_periodo` ASC) VISIBLE,
  INDEX `fk_Perido_Estudiante_Estudiante1_idx` (`id_estudianteAspirante` ASC) VISIBLE,
  CONSTRAINT `fk_Perido_Estudiante_Periodo1`
    FOREIGN KEY (`id_periodo`)
    REFERENCES `mydb`.`Periodo` (`id_periodo`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Perido_Estudiante_Estudiante1`
    FOREIGN KEY (`id_estudianteAspirante`)
    REFERENCES `mydb`.`Estudiante` (`id_estudianteAspirante`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `mydb`.`Materia`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`Materia` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `mydb`.`Materia` (
  `id_materia` INT NOT NULL,
  `nombre` VARCHAR(45) NOT NULL,
  `tipo` ENUM('Ordinaria', 'Modulo', 'Submodulo') NOT NULL COMMENT 'El tipo de materia, para saber si es una Ordinaria, un Modulo o un Submodulo.',
  `tipo_curriculum` ENUM('Fundamental', 'Fundamental extendido obligatorio', 'Fundamental extendido optativo', 'Laboral', 'Ampliado') NOT NULL,
  `credito` INT NOT NULL,
  `no_semestre` ENUM('1', '2', '3', '4', '5', '6') NOT NULL COMMENT 'semestre en el que se imparte (1 al 6)',
  `estado` ENUM('Activo', 'Inactivo') NOT NULL COMMENT 'Estado como lo manejamos \"Activo\" e \"Inactivo\" o se repite lo de matera estudante en cuyo caso se deberia de borrar en esta tabla para evitar redundancia. ',
  `id_materiaPadre` INT NOT NULL COMMENT 'En caso de los submodulos, donde uno o mas submodulos pertenecen a un modulo.',
  PRIMARY KEY (`id_materia`),
  UNIQUE INDEX `nombre_UNIQUE` (`nombre` ASC) VISIBLE,
  INDEX `fk_Materia_Materia1_idx` (`id_materiaPadre` ASC) VISIBLE,
  CONSTRAINT `fk_Materia_Materia1`
    FOREIGN KEY (`id_materiaPadre`)
    REFERENCES `mydb`.`Materia` (`id_materia`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `mydb`.`Materia_Estudiante`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`Materia_Estudiante` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `mydb`.`Materia_Estudiante` (
  `id_materiaEstudiante` INT NOT NULL AUTO_INCREMENT,
  `id_materia` INT NOT NULL,
  `estado` ENUM('Cursando', 'Aprobada', 'Reprobada', 'Recursando', 'Renunciada') NOT NULL COMMENT 'Edo: Cursando, Aprobada, Reprobada, Renunciada',
  `id_estudianteAspirante` INT UNSIGNED NOT NULL COMMENT 'id_estudianteAspirante es la clave primaria del estudiante que viene desde Aspirante->Estudiante\n',
  PRIMARY KEY (`id_materiaEstudiante`),
  INDEX `fk_Materia_Estudiante_Materia1_idx` (`id_materia` ASC) VISIBLE,
  INDEX `fk_Materia_Estudiante_Estudiante1_idx` (`id_estudianteAspirante` ASC) VISIBLE,
  CONSTRAINT `fk_Materia_Estudiante_Materia1`
    FOREIGN KEY (`id_materia`)
    REFERENCES `mydb`.`Materia` (`id_materia`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Materia_Estudiante_Estudiante1`
    FOREIGN KEY (`id_estudianteAspirante`)
    REFERENCES `mydb`.`Estudiante` (`id_estudianteAspirante`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `mydb`.`Carrera_Plantel`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`Carrera_Plantel` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `mydb`.`Carrera_Plantel` (
  `id_carreraPlantel` INT NOT NULL AUTO_INCREMENT,
  `id_plantel` TINYINT NOT NULL,
  `id_carrera` INT NOT NULL,
  PRIMARY KEY (`id_carreraPlantel`),
  INDEX `fk_Carrera_Plantel_Plantel1_idx` (`id_plantel` ASC) VISIBLE,
  INDEX `fk_Carrera_Plantel_Carrera1_idx` (`id_carrera` ASC) VISIBLE,
  CONSTRAINT `fk_Carrera_Plantel_Plantel1`
    FOREIGN KEY (`id_plantel`)
    REFERENCES `mydb`.`Plantel` (`id_plantel`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Carrera_Plantel_Carrera1`
    FOREIGN KEY (`id_carrera`)
    REFERENCES `mydb`.`Carrera` (`id_carrera`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `mydb`.`Personal`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`Personal` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `mydb`.`Personal` (
  `id_personal` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `curp` CHAR(18) NOT NULL,
  `nombre` VARCHAR(45) NOT NULL,
  `apellido_P` VARCHAR(45) NOT NULL,
  `apellido_M` VARCHAR(45) NOT NULL,
  `sexo` ENUM('Masculino', 'Femenino') NOT NULL,
  `id_lada` INT NOT NULL,
  `telefono` VARCHAR(10) NOT NULL,
  `grupo_sanguineo` ENUM('O positivo', 'O negativo', 'A positivo', 'A negativo', 'B positivo', 'B negativo', 'AB positivo', 'AB negarivo') NOT NULL,
  `fecha_nacimiento` DATE NOT NULL,
  `seguro_social` CHAR(11) NOT NULL,
  `rfc` CHAR(13) NOT NULL,
  `correo` VARCHAR(45) NOT NULL,
  `id_municipio` INT NOT NULL,
  `colonia` VARCHAR(45) NOT NULL,
  `calle` VARCHAR(45) NOT NULL,
  `numero` VARCHAR(45) NOT NULL,
  `codigo_postal` VARCHAR(45) NOT NULL,
  `id_plantel` TINYINT NOT NULL,
  `puesto` ENUM('Director de plantel', 'Enlace de control escolar', 'Coordinador académico', 'Docente', 'Control escolar', 'Seguridad', 'Mantenimiento', 'General') NOT NULL DEFAULT 'General' COMMENT 'ENUM(\'Director de plantel\', \'Enlace de control escolar\', \'Coordinador académico\', \'Docente\', \'Control escolar\'\', \'General\')',
  PRIMARY KEY (`id_personal`),
  UNIQUE INDEX `CURP_UNIQUE` (`curp` ASC) VISIBLE,
  INDEX `fk_Persona_Municipio1_idx` (`id_municipio` ASC) VISIBLE,
  UNIQUE INDEX `seguro_social_UNIQUE` (`seguro_social` ASC) VISIBLE,
  INDEX `fk_Aspirante_Lada1_idx` (`id_lada` ASC) VISIBLE,
  UNIQUE INDEX `id_aspirante_UNIQUE` (`id_personal` ASC) VISIBLE,
  INDEX `fk_Personal_Plantel1_idx` (`id_plantel` ASC) VISIBLE,
  CONSTRAINT `fk_Persona_Municipio10`
    FOREIGN KEY (`id_municipio`)
    REFERENCES `mydb`.`Municipio` (`id_municipio`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Aspirante_Lada10`
    FOREIGN KEY (`id_lada`)
    REFERENCES `mydb`.`Lada` (`id_lada`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Personal_Plantel1`
    FOREIGN KEY (`id_plantel`)
    REFERENCES `mydb`.`Plantel` (`id_plantel`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `mydb`.`Docente`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`Docente` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `mydb`.`Docente` (
  `id_docente` INT NOT NULL,
  `especialidad` VARCHAR(45) NULL COMMENT 'Refiere a los estudios del profesor, su area de especializacion.',
  `id_personal` INT UNSIGNED NOT NULL COMMENT 'id_personal es su número de empleado',
  `id_plantel` TINYINT NOT NULL,
  PRIMARY KEY (`id_docente`),
  INDEX `fk_Docente_Plantel1_idx` (`id_plantel` ASC) VISIBLE,
  INDEX `fk_Docente_Personal1_idx` (`id_personal` ASC) VISIBLE,
  CONSTRAINT `fk_Docente_Plantel1`
    FOREIGN KEY (`id_plantel`)
    REFERENCES `mydb`.`Plantel` (`id_plantel`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Docente_Personal1`
    FOREIGN KEY (`id_personal`)
    REFERENCES `mydb`.`Personal` (`id_personal`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `mydb`.`Cuestionario_Docente`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`Cuestionario_Docente` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `mydb`.`Cuestionario_Docente` (
  `id_cuestionario_Docente` INT NOT NULL AUTO_INCREMENT,
  `titulo` VARCHAR(45) NOT NULL,
  `fecha` DATE NOT NULL COMMENT 'Ultima fecha de uso del cuestionario',
  PRIMARY KEY (`id_cuestionario_Docente`))
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `mydb`.`Evaluacion_Docente`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`Evaluacion_Docente` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `mydb`.`Evaluacion_Docente` (
  `id_evaluacionDocente` INT NOT NULL,
  `fecha` DATE NOT NULL COMMENT 'Fecha de aplicacion de la evaluacion',
  `comentario` TEXT(300) NOT NULL,
  `estado` ENUM('Activa', 'Inactiva') NOT NULL DEFAULT 'Activa' COMMENT 'Para saber si la evaluacion fue cerrada o sigue abierta para contestar',
  `id_docente` INT NOT NULL,
  `id_materia` INT NOT NULL,
  `id_estudianteAspirante` INT UNSIGNED NOT NULL COMMENT 'id_EstudianteAspirante es la clave primaria del estudiante que viene desde Aspirante->Estudiante\n',
  `id_cuestionario_Docente` INT NOT NULL,
  PRIMARY KEY (`id_evaluacionDocente`),
  INDEX `fk_Evaluacion_Docente_Docente1_idx` (`id_docente` ASC) VISIBLE,
  INDEX `fk_Evaluacion_Docente_Materia1_idx` (`id_materia` ASC) VISIBLE,
  INDEX `fk_Evaluacion_Docente_Estudiante1_idx` (`id_estudianteAspirante` ASC) VISIBLE,
  INDEX `fk_Evaluacion_Docente_Cuestionario_Docente1_idx` (`id_cuestionario_Docente` ASC) VISIBLE,
  CONSTRAINT `fk_Evaluacion_Docente_Docente1`
    FOREIGN KEY (`id_docente`)
    REFERENCES `mydb`.`Docente` (`id_docente`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Evaluacion_Docente_Materia1`
    FOREIGN KEY (`id_materia`)
    REFERENCES `mydb`.`Materia` (`id_materia`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Evaluacion_Docente_Estudiante1`
    FOREIGN KEY (`id_estudianteAspirante`)
    REFERENCES `mydb`.`Estudiante` (`id_estudianteAspirante`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Evaluacion_Docente_Cuestionario_Docente1`
    FOREIGN KEY (`id_cuestionario_Docente`)
    REFERENCES `mydb`.`Cuestionario_Docente` (`id_cuestionario_Docente`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `mydb`.`Aula`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`Aula` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `mydb`.`Aula` (
  `id_aula` INT NOT NULL,
  `nombre` VARCHAR(45) NOT NULL,
  `capacidad` TINYINT NOT NULL,
  `id_plantel` TINYINT NOT NULL,
  PRIMARY KEY (`id_aula`),
  INDEX `fk_Aula_Plantel1_idx` (`id_plantel` ASC) VISIBLE,
  CONSTRAINT `fk_Aula_Plantel1`
    FOREIGN KEY (`id_plantel`)
    REFERENCES `mydb`.`Plantel` (`id_plantel`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `mydb`.`Materia_Periodo`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`Materia_Periodo` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `mydb`.`Materia_Periodo` (
  `id_materia_periodo` INT NOT NULL AUTO_INCREMENT,
  `id_materia` INT NOT NULL,
  `id_periodo` INT NOT NULL,
  `id_carrera` INT NOT NULL,
  PRIMARY KEY (`id_materia_periodo`),
  INDEX `fk_Materia_Periodo_Materia1_idx` (`id_materia` ASC) VISIBLE,
  INDEX `fk_Materia_Periodo_Periodo1_idx` (`id_periodo` ASC) VISIBLE,
  INDEX `fk_Materia_Periodo_Carrera1_idx` (`id_carrera` ASC) VISIBLE,
  CONSTRAINT `fk_Materia_Periodo_Materia1`
    FOREIGN KEY (`id_materia`)
    REFERENCES `mydb`.`Materia` (`id_materia`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Materia_Periodo_Periodo1`
    FOREIGN KEY (`id_periodo`)
    REFERENCES `mydb`.`Periodo` (`id_periodo`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Materia_Periodo_Carrera1`
    FOREIGN KEY (`id_carrera`)
    REFERENCES `mydb`.`Carrera` (`id_carrera`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `mydb`.`Carga_Academica`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`Carga_Academica` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `mydb`.`Carga_Academica` (
  `id_cargaAcademica` INT NOT NULL AUTO_INCREMENT,
  `id_docente` INT NOT NULL,
  `id_grupo` INT NOT NULL,
  `id_materia_periodo` INT NOT NULL COMMENT 'Es la relacion con la materia que se da en un periodo, en esta tabla permitiendo saber quien la dio, a que grupo y cuando la impartio.',
  PRIMARY KEY (`id_cargaAcademica`),
  INDEX `fk_Carga_Academica_Docente1_idx` (`id_docente` ASC) VISIBLE,
  INDEX `fk_Carga_Academica_Grupo1_idx` (`id_grupo` ASC) VISIBLE,
  INDEX `fk_Carga_Academica_Materia_Periodo1_idx` (`id_materia_periodo` ASC) VISIBLE,
  CONSTRAINT `fk_Carga_Academica_Docente1`
    FOREIGN KEY (`id_docente`)
    REFERENCES `mydb`.`Docente` (`id_docente`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Carga_Academica_Grupo1`
    FOREIGN KEY (`id_grupo`)
    REFERENCES `mydb`.`Grupo` (`id_grupo`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Carga_Academica_Materia_Periodo1`
    FOREIGN KEY (`id_materia_periodo`)
    REFERENCES `mydb`.`Materia_Periodo` (`id_materia_periodo`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `mydb`.`Horario`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`Horario` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `mydb`.`Horario` (
  `id_horario` INT NOT NULL AUTO_INCREMENT,
  `dia_semana` DATE NOT NULL,
  `hora_inicio` TIME NOT NULL,
  `hora_fin` TIME NOT NULL,
  `id_aula` INT NOT NULL,
  `id_cargaAcademica` INT NOT NULL,
  PRIMARY KEY (`id_horario`),
  INDEX `fk_Horario_Aula1_idx` (`id_aula` ASC) VISIBLE,
  INDEX `fk_Horario_Carga_Academica1_idx` (`id_cargaAcademica` ASC) VISIBLE,
  CONSTRAINT `fk_Horario_Aula1`
    FOREIGN KEY (`id_aula`)
    REFERENCES `mydb`.`Aula` (`id_aula`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Horario_Carga_Academica1`
    FOREIGN KEY (`id_cargaAcademica`)
    REFERENCES `mydb`.`Carga_Academica` (`id_cargaAcademica`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `mydb`.`Calificacion`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`Calificacion` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `mydb`.`Calificacion` (
  `id_calificacion` INT NOT NULL,
  `acreditado` ENUM('AC', 'NAC') NULL COMMENT 'Si aplica, se marca como Acreditado o No Acreditado. Solo para las asignaturas de evaluacion cualitativa (no numero)',
  `parcial1` DECIMAL(3,1) NULL,
  `recuperacion1` DECIMAL(3,1) NULL,
  `parcial2` DECIMAL(3,1) NULL,
  `recuperacion2` DECIMAL(3,1) NULL,
  `parcial3` DECIMAL(3,1) NULL,
  `recuperacion3` DECIMAL(3,1) NULL,
  `calif_final` DECIMAL(3,1) NULL COMMENT 'Calificacion final de la materia en el semestre',
  `extraordinario` DECIMAL(3,1) NULL,
  `id_materiaEstudiante` INT NOT NULL,
  PRIMARY KEY (`id_calificacion`),
  INDEX `fk_Calificacion_Materia_Estudiante1_idx` (`id_materiaEstudiante` ASC) VISIBLE,
  CONSTRAINT `fk_Calificacion_Materia_Estudiante1`
    FOREIGN KEY (`id_materiaEstudiante`)
    REFERENCES `mydb`.`Materia_Estudiante` (`id_materiaEstudiante`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `mydb`.`Revalidacion`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`Revalidacion` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `mydb`.`Revalidacion` (
  `id_revalidacion` INT NOT NULL AUTO_INCREMENT,
  `nombre_materiaOrigen` VARCHAR(45) NOT NULL,
  `calificacion_obtenida` DECIMAL(3,1) NOT NULL,
  `creditos_otorgados` INT NOT NULL,
  `fecha_revalidacion` DATE NOT NULL,
  `id_materia` INT NOT NULL,
  `id_estudianteAspirante` INT UNSIGNED NOT NULL COMMENT 'id_estudianteAspirante es la clave primaria del estudiante que viene desde Aspirante->Estudiante\n',
  PRIMARY KEY (`id_revalidacion`),
  INDEX `fk_Revalidacion_Materia1_idx` (`id_materia` ASC) VISIBLE,
  INDEX `fk_Revalidacion_Estudiante1_idx` (`id_estudianteAspirante` ASC) VISIBLE,
  CONSTRAINT `fk_Revalidacion_Materia1`
    FOREIGN KEY (`id_materia`)
    REFERENCES `mydb`.`Materia` (`id_materia`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Revalidacion_Estudiante1`
    FOREIGN KEY (`id_estudianteAspirante`)
    REFERENCES `mydb`.`Estudiante` (`id_estudianteAspirante`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `mydb`.`Materia_Plan_Estudios`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`Materia_Plan_Estudios` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `mydb`.`Materia_Plan_Estudios` (
  `id_materia_plan` INT NOT NULL AUTO_INCREMENT,
  `id_planEstudios` INT NOT NULL,
  `id_materia` INT NOT NULL,
  PRIMARY KEY (`id_materia_plan`),
  INDEX `fk_Materia_Plan_Estudios_Plan_Estudios1_idx` (`id_planEstudios` ASC) VISIBLE,
  INDEX `fk_Materia_Plan_Estudios_Materia1_idx` (`id_materia` ASC) VISIBLE,
  CONSTRAINT `fk_Materia_Plan_Estudios_Plan_Estudios1`
    FOREIGN KEY (`id_planEstudios`)
    REFERENCES `mydb`.`Plan_Estudios` (`id_plan_Estudios`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Materia_Plan_Estudios_Materia1`
    FOREIGN KEY (`id_materia`)
    REFERENCES `mydb`.`Materia` (`id_materia`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `mydb`.`Pregunta`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`Pregunta` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `mydb`.`Pregunta` (
  `id_pregunta` INT NOT NULL AUTO_INCREMENT,
  `texto_pregunta` TEXT(150) NOT NULL,
  `orden` TINYINT NOT NULL,
  `id_cuestionario_Docente` INT NOT NULL,
  PRIMARY KEY (`id_pregunta`),
  INDEX `fk_Pregunta_Cuestionario_Docente1_idx` (`id_cuestionario_Docente` ASC) VISIBLE,
  CONSTRAINT `fk_Pregunta_Cuestionario_Docente1`
    FOREIGN KEY (`id_cuestionario_Docente`)
    REFERENCES `mydb`.`Cuestionario_Docente` (`id_cuestionario_Docente`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `mydb`.`Respuesta`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`Respuesta` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `mydb`.`Respuesta` (
  `id_respuesta` INT NOT NULL AUTO_INCREMENT,
  `calificacion_escala` TINYINT(5) UNSIGNED NOT NULL COMMENT 'Calificacion de cumplimiento del 1 (Deficiente) al 5 (Sobresaliente)',
  `id_pregunta` INT NOT NULL,
  PRIMARY KEY (`id_respuesta`),
  INDEX `fk_Respuesta_Pregunta1_idx` (`id_pregunta` ASC) VISIBLE,
  CONSTRAINT `fk_Respuesta_Pregunta1`
    FOREIGN KEY (`id_pregunta`)
    REFERENCES `mydb`.`Pregunta` (`id_pregunta`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `mydb`.`Usuario`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`Usuario` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `mydb`.`Usuario` (
  `id_usuario` INT NOT NULL AUTO_INCREMENT,
  `username` VARCHAR(45) NOT NULL,
  `contrasenia` VARCHAR(45) NOT NULL,
  `correo` VARCHAR(45) NOT NULL,
  `estado` ENUM('Activo', 'Inactivo') NOT NULL DEFAULT 'Activo',
  `rol` ENUM('Admin', 'Profesor', 'ControlEscolar', 'CoordinadorAcademico') NOT NULL COMMENT 'Administrador de TI, profesor, control escolar, coordinador academico(la cuenta del plantel)',
  `id_personal` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`id_usuario`),
  UNIQUE INDEX `id_usuario_UNIQUE` (`id_usuario` ASC) VISIBLE,
  CONSTRAINT `fk_Usuario_Personal1`
    FOREIGN KEY (`id_personal`)
    REFERENCES `mydb`.`Personal` (`id_personal`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

SHOW WARNINGS;
USE `sakila` ;

-- -----------------------------------------------------
-- Table `sakila`.`actor`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `sakila`.`actor` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `sakila`.`actor` (
  `actor_id` SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `first_name` VARCHAR(45) NOT NULL,
  `last_name` VARCHAR(45) NOT NULL,
  `last_update` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`actor_id`),
  INDEX `idx_actor_last_name` (`last_name` ASC) VISIBLE)
ENGINE = InnoDB
AUTO_INCREMENT = 201
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `sakila`.`country`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `sakila`.`country` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `sakila`.`country` (
  `country_id` SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `country` VARCHAR(50) NOT NULL,
  `last_update` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`country_id`))
ENGINE = InnoDB
AUTO_INCREMENT = 110
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `sakila`.`city`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `sakila`.`city` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `sakila`.`city` (
  `city_id` SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `city` VARCHAR(50) NOT NULL,
  `country_id` SMALLINT UNSIGNED NOT NULL,
  `last_update` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`city_id`),
  INDEX `idx_fk_country_id` (`country_id` ASC) VISIBLE,
  CONSTRAINT `fk_city_country`
    FOREIGN KEY (`country_id`)
    REFERENCES `sakila`.`country` (`country_id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB
AUTO_INCREMENT = 601
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `sakila`.`address`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `sakila`.`address` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `sakila`.`address` (
  `address_id` SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `address` VARCHAR(50) NOT NULL,
  `address2` VARCHAR(50) NULL DEFAULT NULL,
  `district` VARCHAR(20) NOT NULL,
  `city_id` SMALLINT UNSIGNED NOT NULL,
  `postal_code` VARCHAR(10) NULL DEFAULT NULL,
  `phone` VARCHAR(20) NOT NULL,
  `location` GEOMETRY NOT NULL,
  `last_update` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`address_id`),
  INDEX `idx_fk_city_id` (`city_id` ASC) VISIBLE,
  SPATIAL INDEX `idx_location` (`location`) VISIBLE,
  CONSTRAINT `fk_address_city`
    FOREIGN KEY (`city_id`)
    REFERENCES `sakila`.`city` (`city_id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB
AUTO_INCREMENT = 606
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `sakila`.`category`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `sakila`.`category` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `sakila`.`category` (
  `category_id` TINYINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(25) NOT NULL,
  `last_update` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`category_id`))
ENGINE = InnoDB
AUTO_INCREMENT = 17
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `sakila`.`staff`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `sakila`.`staff` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `sakila`.`staff` (
  `staff_id` TINYINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `first_name` VARCHAR(45) NOT NULL,
  `last_name` VARCHAR(45) NOT NULL,
  `address_id` SMALLINT UNSIGNED NOT NULL,
  `picture` BLOB NULL DEFAULT NULL,
  `email` VARCHAR(50) NULL DEFAULT NULL,
  `store_id` TINYINT UNSIGNED NOT NULL,
  `active` TINYINT(1) NOT NULL DEFAULT '1',
  `username` VARCHAR(16) NOT NULL,
  `password` VARCHAR(40) CHARACTER SET 'utf8mb4' COLLATE 'utf8mb4_bin' NULL DEFAULT NULL,
  `last_update` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`staff_id`),
  INDEX `idx_fk_store_id` (`store_id` ASC) VISIBLE,
  INDEX `idx_fk_address_id` (`address_id` ASC) VISIBLE,
  CONSTRAINT `fk_staff_address`
    FOREIGN KEY (`address_id`)
    REFERENCES `sakila`.`address` (`address_id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_staff_store`
    FOREIGN KEY (`store_id`)
    REFERENCES `sakila`.`store` (`store_id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB
AUTO_INCREMENT = 3
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `sakila`.`store`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `sakila`.`store` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `sakila`.`store` (
  `store_id` TINYINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `manager_staff_id` TINYINT UNSIGNED NOT NULL,
  `address_id` SMALLINT UNSIGNED NOT NULL,
  `last_update` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`store_id`),
  UNIQUE INDEX `idx_unique_manager` (`manager_staff_id` ASC) VISIBLE,
  INDEX `idx_fk_address_id` (`address_id` ASC) VISIBLE,
  CONSTRAINT `fk_store_address`
    FOREIGN KEY (`address_id`)
    REFERENCES `sakila`.`address` (`address_id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_store_staff`
    FOREIGN KEY (`manager_staff_id`)
    REFERENCES `sakila`.`staff` (`staff_id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB
AUTO_INCREMENT = 3
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `sakila`.`customer`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `sakila`.`customer` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `sakila`.`customer` (
  `customer_id` SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `store_id` TINYINT UNSIGNED NOT NULL,
  `first_name` VARCHAR(45) NOT NULL,
  `last_name` VARCHAR(45) NOT NULL,
  `email` VARCHAR(50) NULL DEFAULT NULL,
  `address_id` SMALLINT UNSIGNED NOT NULL,
  `active` TINYINT(1) NOT NULL DEFAULT '1',
  `create_date` DATETIME NOT NULL,
  `last_update` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`customer_id`),
  INDEX `idx_fk_store_id` (`store_id` ASC) VISIBLE,
  INDEX `idx_fk_address_id` (`address_id` ASC) VISIBLE,
  INDEX `idx_last_name` (`last_name` ASC) VISIBLE,
  CONSTRAINT `fk_customer_address`
    FOREIGN KEY (`address_id`)
    REFERENCES `sakila`.`address` (`address_id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_customer_store`
    FOREIGN KEY (`store_id`)
    REFERENCES `sakila`.`store` (`store_id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB
AUTO_INCREMENT = 600
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `sakila`.`language`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `sakila`.`language` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `sakila`.`language` (
  `language_id` TINYINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` CHAR(20) NOT NULL,
  `last_update` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`language_id`))
ENGINE = InnoDB
AUTO_INCREMENT = 7
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `sakila`.`film`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `sakila`.`film` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `sakila`.`film` (
  `film_id` SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `title` VARCHAR(128) NOT NULL,
  `description` TEXT NULL DEFAULT NULL,
  `release_year` YEAR NULL DEFAULT NULL,
  `language_id` TINYINT UNSIGNED NOT NULL,
  `original_language_id` TINYINT UNSIGNED NULL DEFAULT NULL,
  `rental_duration` TINYINT UNSIGNED NOT NULL DEFAULT '3',
  `rental_rate` DECIMAL(4,2) NOT NULL DEFAULT '4.99',
  `length` SMALLINT UNSIGNED NULL DEFAULT NULL,
  `replacement_cost` DECIMAL(5,2) NOT NULL DEFAULT '19.99',
  `rating` ENUM('G', 'PG', 'PG-13', 'R', 'NC-17') NULL DEFAULT 'G',
  `special_features` SET('Trailers', 'Commentaries', 'Deleted Scenes', 'Behind the Scenes') NULL DEFAULT NULL,
  `last_update` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`film_id`),
  INDEX `idx_title` (`title` ASC) VISIBLE,
  INDEX `idx_fk_language_id` (`language_id` ASC) VISIBLE,
  INDEX `idx_fk_original_language_id` (`original_language_id` ASC) VISIBLE,
  CONSTRAINT `fk_film_language`
    FOREIGN KEY (`language_id`)
    REFERENCES `sakila`.`language` (`language_id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_film_language_original`
    FOREIGN KEY (`original_language_id`)
    REFERENCES `sakila`.`language` (`language_id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB
AUTO_INCREMENT = 1001
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `sakila`.`film_actor`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `sakila`.`film_actor` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `sakila`.`film_actor` (
  `actor_id` SMALLINT UNSIGNED NOT NULL,
  `film_id` SMALLINT UNSIGNED NOT NULL,
  `last_update` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`actor_id`, `film_id`),
  INDEX `idx_fk_film_id` (`film_id` ASC) VISIBLE,
  CONSTRAINT `fk_film_actor_actor`
    FOREIGN KEY (`actor_id`)
    REFERENCES `sakila`.`actor` (`actor_id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_film_actor_film`
    FOREIGN KEY (`film_id`)
    REFERENCES `sakila`.`film` (`film_id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `sakila`.`film_category`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `sakila`.`film_category` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `sakila`.`film_category` (
  `film_id` SMALLINT UNSIGNED NOT NULL,
  `category_id` TINYINT UNSIGNED NOT NULL,
  `last_update` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`film_id`, `category_id`),
  INDEX `fk_film_category_category` (`category_id` ASC) VISIBLE,
  CONSTRAINT `fk_film_category_category`
    FOREIGN KEY (`category_id`)
    REFERENCES `sakila`.`category` (`category_id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_film_category_film`
    FOREIGN KEY (`film_id`)
    REFERENCES `sakila`.`film` (`film_id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `sakila`.`film_text`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `sakila`.`film_text` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `sakila`.`film_text` (
  `film_id` SMALLINT NOT NULL,
  `title` VARCHAR(255) NOT NULL,
  `description` TEXT NULL DEFAULT NULL,
  PRIMARY KEY (`film_id`),
  FULLTEXT INDEX `idx_title_description` (`title`, `description`) VISIBLE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `sakila`.`inventory`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `sakila`.`inventory` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `sakila`.`inventory` (
  `inventory_id` MEDIUMINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `film_id` SMALLINT UNSIGNED NOT NULL,
  `store_id` TINYINT UNSIGNED NOT NULL,
  `last_update` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`inventory_id`),
  INDEX `idx_fk_film_id` (`film_id` ASC) VISIBLE,
  INDEX `idx_store_id_film_id` (`store_id` ASC, `film_id` ASC) VISIBLE,
  CONSTRAINT `fk_inventory_film`
    FOREIGN KEY (`film_id`)
    REFERENCES `sakila`.`film` (`film_id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_inventory_store`
    FOREIGN KEY (`store_id`)
    REFERENCES `sakila`.`store` (`store_id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB
AUTO_INCREMENT = 4582
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `sakila`.`rental`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `sakila`.`rental` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `sakila`.`rental` (
  `rental_id` INT NOT NULL AUTO_INCREMENT,
  `rental_date` DATETIME NOT NULL,
  `inventory_id` MEDIUMINT UNSIGNED NOT NULL,
  `customer_id` SMALLINT UNSIGNED NOT NULL,
  `return_date` DATETIME NULL DEFAULT NULL,
  `staff_id` TINYINT UNSIGNED NOT NULL,
  `last_update` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`rental_id`),
  UNIQUE INDEX `rental_date` (`rental_date` ASC, `inventory_id` ASC, `customer_id` ASC) VISIBLE,
  INDEX `idx_fk_inventory_id` (`inventory_id` ASC) VISIBLE,
  INDEX `idx_fk_customer_id` (`customer_id` ASC) VISIBLE,
  INDEX `idx_fk_staff_id` (`staff_id` ASC) VISIBLE,
  CONSTRAINT `fk_rental_customer`
    FOREIGN KEY (`customer_id`)
    REFERENCES `sakila`.`customer` (`customer_id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_rental_inventory`
    FOREIGN KEY (`inventory_id`)
    REFERENCES `sakila`.`inventory` (`inventory_id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_rental_staff`
    FOREIGN KEY (`staff_id`)
    REFERENCES `sakila`.`staff` (`staff_id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB
AUTO_INCREMENT = 16050
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `sakila`.`payment`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `sakila`.`payment` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `sakila`.`payment` (
  `payment_id` SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `customer_id` SMALLINT UNSIGNED NOT NULL,
  `staff_id` TINYINT UNSIGNED NOT NULL,
  `rental_id` INT NULL DEFAULT NULL,
  `amount` DECIMAL(5,2) NOT NULL,
  `payment_date` DATETIME NOT NULL,
  `last_update` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`payment_id`),
  INDEX `idx_fk_staff_id` (`staff_id` ASC) VISIBLE,
  INDEX `idx_fk_customer_id` (`customer_id` ASC) VISIBLE,
  INDEX `fk_payment_rental` (`rental_id` ASC) VISIBLE,
  CONSTRAINT `fk_payment_customer`
    FOREIGN KEY (`customer_id`)
    REFERENCES `sakila`.`customer` (`customer_id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_payment_rental`
    FOREIGN KEY (`rental_id`)
    REFERENCES `sakila`.`rental` (`rental_id`)
    ON DELETE SET NULL
    ON UPDATE CASCADE,
  CONSTRAINT `fk_payment_staff`
    FOREIGN KEY (`staff_id`)
    REFERENCES `sakila`.`staff` (`staff_id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB
AUTO_INCREMENT = 16050
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

SHOW WARNINGS;
USE `sakila` ;

-- -----------------------------------------------------
-- Placeholder table for view `sakila`.`actor_info`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `sakila`.`actor_info` (`actor_id` INT, `first_name` INT, `last_name` INT, `film_info` INT);
SHOW WARNINGS;

-- -----------------------------------------------------
-- Placeholder table for view `sakila`.`customer_list`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `sakila`.`customer_list` (`id` INT);
SHOW WARNINGS;

-- -----------------------------------------------------
-- Placeholder table for view `sakila`.`film_list`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `sakila`.`film_list` (`FID` INT, `title` INT, `description` INT, `category` INT, `price` INT, `length` INT, `rating` INT, `actors` INT);
SHOW WARNINGS;

-- -----------------------------------------------------
-- Placeholder table for view `sakila`.`nicer_but_slower_film_list`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `sakila`.`nicer_but_slower_film_list` (`FID` INT, `title` INT, `description` INT, `category` INT, `price` INT, `length` INT, `rating` INT, `actors` INT);
SHOW WARNINGS;

-- -----------------------------------------------------
-- Placeholder table for view `sakila`.`sales_by_film_category`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `sakila`.`sales_by_film_category` (`category` INT, `total_sales` INT);
SHOW WARNINGS;

-- -----------------------------------------------------
-- Placeholder table for view `sakila`.`sales_by_store`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `sakila`.`sales_by_store` (`store` INT, `manager` INT, `total_sales` INT);
SHOW WARNINGS;

-- -----------------------------------------------------
-- Placeholder table for view `sakila`.`staff_list`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `sakila`.`staff_list` (`ID` INT, `name` INT, `address` INT, `zip code` INT, `phone` INT, `city` INT, `country` INT, `SID` INT);
SHOW WARNINGS;

-- -----------------------------------------------------
-- procedure film_in_stock
-- -----------------------------------------------------

USE `sakila`;
DROP procedure IF EXISTS `sakila`.`film_in_stock`;
SHOW WARNINGS;

DELIMITER $$
USE `sakila`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `film_in_stock`(IN p_film_id INT, IN p_store_id INT, OUT p_film_count INT)
    READS SQL DATA
BEGIN
     SELECT inventory_id
     FROM inventory
     WHERE film_id = p_film_id
     AND store_id = p_store_id
     AND inventory_in_stock(inventory_id);

     SELECT COUNT(*)
     FROM inventory
     WHERE film_id = p_film_id
     AND store_id = p_store_id
     AND inventory_in_stock(inventory_id)
     INTO p_film_count;
END$$

DELIMITER ;
SHOW WARNINGS;

-- -----------------------------------------------------
-- procedure film_not_in_stock
-- -----------------------------------------------------

USE `sakila`;
DROP procedure IF EXISTS `sakila`.`film_not_in_stock`;
SHOW WARNINGS;

DELIMITER $$
USE `sakila`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `film_not_in_stock`(IN p_film_id INT, IN p_store_id INT, OUT p_film_count INT)
    READS SQL DATA
BEGIN
     SELECT inventory_id
     FROM inventory
     WHERE film_id = p_film_id
     AND store_id = p_store_id
     AND NOT inventory_in_stock(inventory_id);

     SELECT COUNT(*)
     FROM inventory
     WHERE film_id = p_film_id
     AND store_id = p_store_id
     AND NOT inventory_in_stock(inventory_id)
     INTO p_film_count;
END$$

DELIMITER ;
SHOW WARNINGS;

-- -----------------------------------------------------
-- function get_customer_balance
-- -----------------------------------------------------

USE `sakila`;
DROP function IF EXISTS `sakila`.`get_customer_balance`;
SHOW WARNINGS;

DELIMITER $$
USE `sakila`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `get_customer_balance`(p_customer_id INT, p_effective_date DATETIME) RETURNS decimal(5,2)
    READS SQL DATA
    DETERMINISTIC
BEGIN

       #OK, WE NEED TO CALCULATE THE CURRENT BALANCE GIVEN A CUSTOMER_ID AND A DATE
       #THAT WE WANT THE BALANCE TO BE EFFECTIVE FOR. THE BALANCE IS:
       #   1) RENTAL FEES FOR ALL PREVIOUS RENTALS
       #   2) ONE DOLLAR FOR EVERY DAY THE PREVIOUS RENTALS ARE OVERDUE
       #   3) IF A FILM IS MORE THAN RENTAL_DURATION * 2 OVERDUE, CHARGE THE REPLACEMENT_COST
       #   4) SUBTRACT ALL PAYMENTS MADE BEFORE THE DATE SPECIFIED

  DECLARE v_rentfees DECIMAL(5,2); #FEES PAID TO RENT THE VIDEOS INITIALLY
  DECLARE v_overfees INTEGER;      #LATE FEES FOR PRIOR RENTALS
  DECLARE v_payments DECIMAL(5,2); #SUM OF PAYMENTS MADE PREVIOUSLY

  SELECT IFNULL(SUM(film.rental_rate),0) INTO v_rentfees
    FROM film, inventory, rental
    WHERE film.film_id = inventory.film_id
      AND inventory.inventory_id = rental.inventory_id
      AND rental.rental_date <= p_effective_date
      AND rental.customer_id = p_customer_id;

  SELECT IFNULL(SUM(IF((TO_DAYS(rental.return_date) - TO_DAYS(rental.rental_date)) > film.rental_duration,
        ((TO_DAYS(rental.return_date) - TO_DAYS(rental.rental_date)) - film.rental_duration),0)),0) INTO v_overfees
    FROM rental, inventory, film
    WHERE film.film_id = inventory.film_id
      AND inventory.inventory_id = rental.inventory_id
      AND rental.rental_date <= p_effective_date
      AND rental.customer_id = p_customer_id;


  SELECT IFNULL(SUM(payment.amount),0) INTO v_payments
    FROM payment

    WHERE payment.payment_date <= p_effective_date
    AND payment.customer_id = p_customer_id;

  RETURN v_rentfees + v_overfees - v_payments;
END$$

DELIMITER ;
SHOW WARNINGS;

-- -----------------------------------------------------
-- function inventory_held_by_customer
-- -----------------------------------------------------

USE `sakila`;
DROP function IF EXISTS `sakila`.`inventory_held_by_customer`;
SHOW WARNINGS;

DELIMITER $$
USE `sakila`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `inventory_held_by_customer`(p_inventory_id INT) RETURNS int
    READS SQL DATA
BEGIN
  DECLARE v_customer_id INT;
  DECLARE EXIT HANDLER FOR NOT FOUND RETURN NULL;

  SELECT customer_id INTO v_customer_id
  FROM rental
  WHERE return_date IS NULL
  AND inventory_id = p_inventory_id;

  RETURN v_customer_id;
END$$

DELIMITER ;
SHOW WARNINGS;

-- -----------------------------------------------------
-- function inventory_in_stock
-- -----------------------------------------------------

USE `sakila`;
DROP function IF EXISTS `sakila`.`inventory_in_stock`;
SHOW WARNINGS;

DELIMITER $$
USE `sakila`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `inventory_in_stock`(p_inventory_id INT) RETURNS tinyint(1)
    READS SQL DATA
BEGIN
    DECLARE v_rentals INT;
    DECLARE v_out     INT;

    #AN ITEM IS IN-STOCK IF THERE ARE EITHER NO ROWS IN THE rental TABLE
    #FOR THE ITEM OR ALL ROWS HAVE return_date POPULATED

    SELECT COUNT(*) INTO v_rentals
    FROM rental
    WHERE inventory_id = p_inventory_id;

    IF v_rentals = 0 THEN
      RETURN TRUE;
    END IF;

    SELECT COUNT(rental_id) INTO v_out
    FROM inventory LEFT JOIN rental USING(inventory_id)
    WHERE inventory.inventory_id = p_inventory_id
    AND rental.return_date IS NULL;

    IF v_out > 0 THEN
      RETURN FALSE;
    ELSE
      RETURN TRUE;
    END IF;
END$$

DELIMITER ;
SHOW WARNINGS;

-- -----------------------------------------------------
-- procedure rewards_report
-- -----------------------------------------------------

USE `sakila`;
DROP procedure IF EXISTS `sakila`.`rewards_report`;
SHOW WARNINGS;

DELIMITER $$
USE `sakila`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `rewards_report`(
    IN min_monthly_purchases TINYINT UNSIGNED
    , IN min_dollar_amount_purchased DECIMAL(10,2)
    , OUT count_rewardees INT
)
    READS SQL DATA
    COMMENT 'Provides a customizable report on best customers'
proc: BEGIN

    DECLARE last_month_start DATE;
    DECLARE last_month_end DATE;

    /* Some sanity checks... */
    IF min_monthly_purchases = 0 THEN
        SELECT 'Minimum monthly purchases parameter must be > 0';
        LEAVE proc;
    END IF;
    IF min_dollar_amount_purchased = 0.00 THEN
        SELECT 'Minimum monthly dollar amount purchased parameter must be > $0.00';
        LEAVE proc;
    END IF;

    /* Determine start and end time periods */
    SET last_month_start = DATE_SUB(CURRENT_DATE(), INTERVAL 1 MONTH);
    SET last_month_start = STR_TO_DATE(CONCAT(YEAR(last_month_start),'-',MONTH(last_month_start),'-01'),'%Y-%m-%d');
    SET last_month_end = LAST_DAY(last_month_start);

    /*
        Create a temporary storage area for
        Customer IDs.
    */
    CREATE TEMPORARY TABLE tmpCustomer (customer_id SMALLINT UNSIGNED NOT NULL PRIMARY KEY);

    /*
        Find all customers meeting the
        monthly purchase requirements
    */
    INSERT INTO tmpCustomer (customer_id)
    SELECT p.customer_id
    FROM payment AS p
    WHERE DATE(p.payment_date) BETWEEN last_month_start AND last_month_end
    GROUP BY customer_id
    HAVING SUM(p.amount) > min_dollar_amount_purchased
    AND COUNT(customer_id) > min_monthly_purchases;

    /* Populate OUT parameter with count of found customers */
    SELECT COUNT(*) FROM tmpCustomer INTO count_rewardees;

    /*
        Output ALL customer information of matching rewardees.
        Customize output as needed.
    */
    SELECT c.*
    FROM tmpCustomer AS t
    INNER JOIN customer AS c ON t.customer_id = c.customer_id;

    /* Clean up */
    DROP TABLE tmpCustomer;
END$$

DELIMITER ;
SHOW WARNINGS;

-- -----------------------------------------------------
-- View `sakila`.`actor_info`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `sakila`.`actor_info`;
SHOW WARNINGS;
DROP VIEW IF EXISTS `sakila`.`actor_info` ;
SHOW WARNINGS;
USE `sakila`;
CREATE  OR REPLACE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY INVOKER VIEW `sakila`.`actor_info` AS select `a`.`actor_id` AS `actor_id`,`a`.`first_name` AS `first_name`,`a`.`last_name` AS `last_name`,group_concat(distinct concat(`c`.`name`,': ',(select group_concat(`f`.`title` order by `f`.`title` ASC separator ', ') from ((`sakila`.`film` `f` join `sakila`.`film_category` `fc` on((`f`.`film_id` = `fc`.`film_id`))) join `sakila`.`film_actor` `fa` on((`f`.`film_id` = `fa`.`film_id`))) where ((`fc`.`category_id` = `c`.`category_id`) and (`fa`.`actor_id` = `a`.`actor_id`)))) order by `c`.`name` ASC separator '; ') AS `film_info` from (((`sakila`.`actor` `a` left join `sakila`.`film_actor` `fa` on((`a`.`actor_id` = `fa`.`actor_id`))) left join `sakila`.`film_category` `fc` on((`fa`.`film_id` = `fc`.`film_id`))) left join `sakila`.`category` `c` on((`fc`.`category_id` = `c`.`category_id`))) group by `a`.`actor_id`,`a`.`first_name`,`a`.`last_name`;
SHOW WARNINGS;

-- -----------------------------------------------------
-- View `sakila`.`customer_list`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `sakila`.`customer_list`;
SHOW WARNINGS;
DROP VIEW IF EXISTS `sakila`.`customer_list` ;
SHOW WARNINGS;
USE `sakila`;
CREATE  OR REPLACE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `sakila`.`customer_list` AS select `cu`.`customer_id` AS `ID`,concat(`cu`.`first_name`,_utf8mb4' ',`cu`.`last_name`) AS `name`,`a`.`address` AS `address`,`a`.`postal_code` AS `zip code`,`a`.`phone` AS `phone`,`sakila`.`city`.`city` AS `city`,`sakila`.`country`.`country` AS `country`,if(`cu`.`active`,_utf8mb4'active',_utf8mb4'') AS `notes`,`cu`.`store_id` AS `SID` from (((`sakila`.`customer` `cu` join `sakila`.`address` `a` on((`cu`.`address_id` = `a`.`address_id`))) join `sakila`.`city` on((`a`.`city_id` = `sakila`.`city`.`city_id`))) join `sakila`.`country` on((`sakila`.`city`.`country_id` = `sakila`.`country`.`country_id`)));
SHOW WARNINGS;

-- -----------------------------------------------------
-- View `sakila`.`film_list`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `sakila`.`film_list`;
SHOW WARNINGS;
DROP VIEW IF EXISTS `sakila`.`film_list` ;
SHOW WARNINGS;
USE `sakila`;
CREATE  OR REPLACE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `sakila`.`film_list` AS select `sakila`.`film`.`film_id` AS `FID`,`sakila`.`film`.`title` AS `title`,`sakila`.`film`.`description` AS `description`,`sakila`.`category`.`name` AS `category`,`sakila`.`film`.`rental_rate` AS `price`,`sakila`.`film`.`length` AS `length`,`sakila`.`film`.`rating` AS `rating`,group_concat(concat(`sakila`.`actor`.`first_name`,_utf8mb4' ',`sakila`.`actor`.`last_name`) separator ', ') AS `actors` from ((((`sakila`.`category` left join `sakila`.`film_category` on((`sakila`.`category`.`category_id` = `sakila`.`film_category`.`category_id`))) left join `sakila`.`film` on((`sakila`.`film_category`.`film_id` = `sakila`.`film`.`film_id`))) join `sakila`.`film_actor` on((`sakila`.`film`.`film_id` = `sakila`.`film_actor`.`film_id`))) join `sakila`.`actor` on((`sakila`.`film_actor`.`actor_id` = `sakila`.`actor`.`actor_id`))) group by `sakila`.`film`.`film_id`,`sakila`.`category`.`name`;
SHOW WARNINGS;

-- -----------------------------------------------------
-- View `sakila`.`nicer_but_slower_film_list`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `sakila`.`nicer_but_slower_film_list`;
SHOW WARNINGS;
DROP VIEW IF EXISTS `sakila`.`nicer_but_slower_film_list` ;
SHOW WARNINGS;
USE `sakila`;
CREATE  OR REPLACE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `sakila`.`nicer_but_slower_film_list` AS select `sakila`.`film`.`film_id` AS `FID`,`sakila`.`film`.`title` AS `title`,`sakila`.`film`.`description` AS `description`,`sakila`.`category`.`name` AS `category`,`sakila`.`film`.`rental_rate` AS `price`,`sakila`.`film`.`length` AS `length`,`sakila`.`film`.`rating` AS `rating`,group_concat(concat(concat(upper(substr(`sakila`.`actor`.`first_name`,1,1)),lower(substr(`sakila`.`actor`.`first_name`,2,length(`sakila`.`actor`.`first_name`))),_utf8mb4' ',concat(upper(substr(`sakila`.`actor`.`last_name`,1,1)),lower(substr(`sakila`.`actor`.`last_name`,2,length(`sakila`.`actor`.`last_name`)))))) separator ', ') AS `actors` from ((((`sakila`.`category` left join `sakila`.`film_category` on((`sakila`.`category`.`category_id` = `sakila`.`film_category`.`category_id`))) left join `sakila`.`film` on((`sakila`.`film_category`.`film_id` = `sakila`.`film`.`film_id`))) join `sakila`.`film_actor` on((`sakila`.`film`.`film_id` = `sakila`.`film_actor`.`film_id`))) join `sakila`.`actor` on((`sakila`.`film_actor`.`actor_id` = `sakila`.`actor`.`actor_id`))) group by `sakila`.`film`.`film_id`,`sakila`.`category`.`name`;
SHOW WARNINGS;

-- -----------------------------------------------------
-- View `sakila`.`sales_by_film_category`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `sakila`.`sales_by_film_category`;
SHOW WARNINGS;
DROP VIEW IF EXISTS `sakila`.`sales_by_film_category` ;
SHOW WARNINGS;
USE `sakila`;
CREATE  OR REPLACE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `sakila`.`sales_by_film_category` AS select `c`.`name` AS `category`,sum(`p`.`amount`) AS `total_sales` from (((((`sakila`.`payment` `p` join `sakila`.`rental` `r` on((`p`.`rental_id` = `r`.`rental_id`))) join `sakila`.`inventory` `i` on((`r`.`inventory_id` = `i`.`inventory_id`))) join `sakila`.`film` `f` on((`i`.`film_id` = `f`.`film_id`))) join `sakila`.`film_category` `fc` on((`f`.`film_id` = `fc`.`film_id`))) join `sakila`.`category` `c` on((`fc`.`category_id` = `c`.`category_id`))) group by `c`.`name` order by `total_sales` desc;
SHOW WARNINGS;

-- -----------------------------------------------------
-- View `sakila`.`sales_by_store`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `sakila`.`sales_by_store`;
SHOW WARNINGS;
DROP VIEW IF EXISTS `sakila`.`sales_by_store` ;
SHOW WARNINGS;
USE `sakila`;
CREATE  OR REPLACE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `sakila`.`sales_by_store` AS select concat(`c`.`city`,_utf8mb4',',`cy`.`country`) AS `store`,concat(`m`.`first_name`,_utf8mb4' ',`m`.`last_name`) AS `manager`,sum(`p`.`amount`) AS `total_sales` from (((((((`sakila`.`payment` `p` join `sakila`.`rental` `r` on((`p`.`rental_id` = `r`.`rental_id`))) join `sakila`.`inventory` `i` on((`r`.`inventory_id` = `i`.`inventory_id`))) join `sakila`.`store` `s` on((`i`.`store_id` = `s`.`store_id`))) join `sakila`.`address` `a` on((`s`.`address_id` = `a`.`address_id`))) join `sakila`.`city` `c` on((`a`.`city_id` = `c`.`city_id`))) join `sakila`.`country` `cy` on((`c`.`country_id` = `cy`.`country_id`))) join `sakila`.`staff` `m` on((`s`.`manager_staff_id` = `m`.`staff_id`))) group by `s`.`store_id` order by `cy`.`country`,`c`.`city`;
SHOW WARNINGS;

-- -----------------------------------------------------
-- View `sakila`.`staff_list`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `sakila`.`staff_list`;
SHOW WARNINGS;
DROP VIEW IF EXISTS `sakila`.`staff_list` ;
SHOW WARNINGS;
USE `sakila`;
CREATE  OR REPLACE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `sakila`.`staff_list` AS select `s`.`staff_id` AS `ID`,concat(`s`.`first_name`,_utf8mb4' ',`s`.`last_name`) AS `name`,`a`.`address` AS `address`,`a`.`postal_code` AS `zip code`,`a`.`phone` AS `phone`,`sakila`.`city`.`city` AS `city`,`sakila`.`country`.`country` AS `country`,`s`.`store_id` AS `SID` from (((`sakila`.`staff` `s` join `sakila`.`address` `a` on((`s`.`address_id` = `a`.`address_id`))) join `sakila`.`city` on((`a`.`city_id` = `sakila`.`city`.`city_id`))) join `sakila`.`country` on((`sakila`.`city`.`country_id` = `sakila`.`country`.`country_id`)));
SHOW WARNINGS;
USE `sakila`;

DELIMITER $$

USE `sakila`$$
DROP TRIGGER IF EXISTS `sakila`.`customer_create_date` $$
SHOW WARNINGS$$
USE `sakila`$$
CREATE
DEFINER=`root`@`localhost`
TRIGGER `sakila`.`customer_create_date`
BEFORE INSERT ON `sakila`.`customer`
FOR EACH ROW
SET NEW.create_date = NOW()$$

SHOW WARNINGS$$

USE `sakila`$$
DROP TRIGGER IF EXISTS `sakila`.`del_film` $$
SHOW WARNINGS$$
USE `sakila`$$
CREATE
DEFINER=`root`@`localhost`
TRIGGER `sakila`.`del_film`
AFTER DELETE ON `sakila`.`film`
FOR EACH ROW
BEGIN
    DELETE FROM film_text WHERE film_id = old.film_id;
  END$$

SHOW WARNINGS$$

USE `sakila`$$
DROP TRIGGER IF EXISTS `sakila`.`ins_film` $$
SHOW WARNINGS$$
USE `sakila`$$
CREATE
DEFINER=`root`@`localhost`
TRIGGER `sakila`.`ins_film`
AFTER INSERT ON `sakila`.`film`
FOR EACH ROW
BEGIN
    INSERT INTO film_text (film_id, title, description)
        VALUES (new.film_id, new.title, new.description);
  END$$

SHOW WARNINGS$$

USE `sakila`$$
DROP TRIGGER IF EXISTS `sakila`.`upd_film` $$
SHOW WARNINGS$$
USE `sakila`$$
CREATE
DEFINER=`root`@`localhost`
TRIGGER `sakila`.`upd_film`
AFTER UPDATE ON `sakila`.`film`
FOR EACH ROW
BEGIN
    IF (old.title != new.title) OR (old.description != new.description) OR (old.film_id != new.film_id)
    THEN
        UPDATE film_text
            SET title=new.title,
                description=new.description,
                film_id=new.film_id
        WHERE film_id=old.film_id;
    END IF;
  END$$

SHOW WARNINGS$$

USE `sakila`$$
DROP TRIGGER IF EXISTS `sakila`.`rental_date` $$
SHOW WARNINGS$$
USE `sakila`$$
CREATE
DEFINER=`root`@`localhost`
TRIGGER `sakila`.`rental_date`
BEFORE INSERT ON `sakila`.`rental`
FOR EACH ROW
SET NEW.rental_date = NOW()$$

SHOW WARNINGS$$

USE `sakila`$$
DROP TRIGGER IF EXISTS `sakila`.`payment_date` $$
SHOW WARNINGS$$
USE `sakila`$$
CREATE
DEFINER=`root`@`localhost`
TRIGGER `sakila`.`payment_date`
BEFORE INSERT ON `sakila`.`payment`
FOR EACH ROW
SET NEW.payment_date = NOW()$$

SHOW WARNINGS$$

DELIMITER ;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
