-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `veterinaria` DEFAULT CHARACTER SET utf8 ;
USE `veterinaria` ;

-- -----------------------------------------------------
-- Table `mydb`.`Usuario`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `veterinaria`.`Usuario` (
  `id_Usuario` INT NOT NULL AUTO_INCREMENT,
  `Nombre` VARCHAR(45) NOT NULL,
  `Apellido1` VARCHAR(45) NOT NULL,
  `Apellido2` VARCHAR(45) NULL,
  `Correo` VARCHAR(45) NOT NULL,
  `Password` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id_Usuario`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Propietario`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `veterinaria`.`Propietario` (
  `id_Propietario` INT UNSIGNED NOT NULL,
  `Nombre` VARCHAR(45) NULL,
  `Apellido1` VARCHAR(45) NULL,
  `Apellido2` VARCHAR(45) NULL,
  `Telefono` VARCHAR(45) NULL,
  `Email` VARCHAR(45) NULL,
  `Calle` VARCHAR(45) NULL,
  `Colonia` VARCHAR(45) NULL,
  `CP` VARCHAR(45) NULL,
  `Municipio` VARCHAR(45) NULL,
  PRIMARY KEY (`id_Propietario`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Mascota`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `veterinaria`.`Mascota` (
  `id_Mascota` INT NOT NULL AUTO_INCREMENT,
  `id_Propietario` INT UNSIGNED NOT NULL,
  `Nombre` VARCHAR(45) NOT NULL,
  `Especie` VARCHAR(45) NOT NULL,
  `Raza` VARCHAR(45) NULL,
  `F_Nacimiento` DATE NULL,
  `Genero` VARCHAR(45) NULL,
  `Peso` VARCHAR(45) NULL,
  PRIMARY KEY (`id_Mascota`, `id_Propietario`),
  INDEX `fk_Mascota_Propietario1_idx` (`id_Propietario` ASC) VISIBLE,
  CONSTRAINT `fk_Mascota_Propietario1`
    FOREIGN KEY (`id_Propietario`)
    REFERENCES `veterinaria`.`Propietario` (`id_Propietario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Cita`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `veterinaria`.`Cita` (
  `id_Cita` INT NOT NULL AUTO_INCREMENT,
  `id_Mascota` INT NOT NULL,
  `fecha` DATE NULL,
  `Hora` TIME NOT NULL,
  `Observaciones` VARCHAR(100) NULL,
  PRIMARY KEY (`id_Cita`, `id_Mascota`),
  INDEX `fk_Cita_Mascota_idx` (`id_Mascota` ASC) VISIBLE,
  CONSTRAINT `fk_Cita_Mascota`
    FOREIGN KEY (`id_Mascota`)
    REFERENCES `veterinaria`.`Mascota` (`id_Mascota`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `mydb`.`Especialidad`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `veterinaria`.`Especialidad` (
  `id_Especialidad` INT NOT NULL,
  `Descripcion` VARCHAR(70) NOT NULL,
  PRIMARY KEY (`id_Especialidad`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Veterinario`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `veterinaria`.`Veterinario` (
  `id_Veterinario` INT NOT NULL,
  `id_Especialidad` INT NOT NULL,
  `Nombre` VARCHAR(45) NULL,
  `Apellido` VARCHAR(45) NULL,
  `Telefono` VARCHAR(15) NULL,
  `Calle` VARCHAR(45) NULL,
  `Colonia` VARCHAR(45) NULL,
  `CP` VARCHAR(45) NULL,
  `Municipio` VARCHAR(45) NULL,
  PRIMARY KEY (`id_Veterinario`, `id_Especialidad`),
  INDEX `fk_Veterinario_Especialidad1_idx` (`id_Especialidad` ASC) VISIBLE,
  CONSTRAINT `fk_Veterinario_Especialidad1`
    FOREIGN KEY (`id_Especialidad`)
    REFERENCES `veterinaria`.`Especialidad` (`id_Especialidad`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Detalle_Cita`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `veterinaria`.`Detalle_Cita` (
  `id_Veterinario` INT NOT NULL,
  `id_Especialidad` INT NOT NULL,
  `id_Cita` INT NOT NULL,
  `Cita_id_Mascota` INT NOT NULL,
  PRIMARY KEY (`id_Veterinario`, `id_Especialidad`, `id_Cita`, `Cita_id_Mascota`),
  INDEX `fk_Veterinario_has_Cita_Cita1_idx` (`id_Cita` ASC, `Cita_id_Mascota` ASC) VISIBLE,
  INDEX `fk_Veterinario_has_Cita_Veterinario1_idx` (`id_Veterinario` ASC, `id_Especialidad` ASC) VISIBLE,
  CONSTRAINT `fk_Veterinario_has_Cita_Veterinario1`
    FOREIGN KEY (`id_Veterinario` , `id_Especialidad`)
    REFERENCES `veterinaria`.`Veterinario` (`id_Veterinario` , `id_Especialidad`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Veterinario_has_Cita_Cita1`
    FOREIGN KEY (`id_Cita` , `Cita_id_Mascota`)
    REFERENCES `veterinaria`.`Cita` (`id_Cita` , `id_Mascota`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
