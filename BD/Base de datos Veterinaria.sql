CREATE DATABASE Veterinaria;
USE veterinaria;

CREATE TABLE IF NOT EXISTS `veterinaria`.`Usuario` (
  `id_Usuario` INT NOT NULL AUTO_INCREMENT,
  `Nombre` VARCHAR(45) NOT NULL,
  `Apellido1` VARCHAR(45) NOT NULL,
  `Apellido2` VARCHAR(45) NULL,
  `Correo` VARCHAR(45) NOT NULL,
  `Password` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id_Usuario`))
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `veterinaria`.`Propietario` (
  `id_Propietario` INT UNSIGNED NOT NULL AUTO_INCREMENT,
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


CREATE TABLE IF NOT EXISTS  `veterinaria`.`Especialidad` (
  `id_Especialidad` INT NOT NULL AUTO_INCREMENT,
  `Descripcion` VARCHAR(70) NOT NULL,
  PRIMARY KEY (`id_Especialidad`))
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `veterinaria`.`Veterinario` (
  `id_Veterinario` INT NOT NULL AUTO_INCREMENT,
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



-- =====================================  INSERCCION DE REGISTROS DE LAS TABLAS =============================
INSERT INTO PROPIETARIO (Nombre, Apellido1, Apellido2, Telefono, Email, Calle, Colonia, CP, Municipio) VALUES
('Julio M.','Gomez','Hernandez','961 243 3985','gom_julio12@outlook.com','Diamante #7B','Maestros de mx','29270','San Cristobal');

INSERT INTO mascota (id_Propietario, Nombre, Especie, Raza, F_Nacimiento, Genero, Peso) VALUES
(1,'Cheems','Canina','Shiva','2002-04-12','Macho','25 Kg');



-- ======================== CREACION DE VISTAS ===============================================================
use veterinaria;

CREATE VIEW VW_Consulta_Paciente AS
SELECT mascota.id_Mascota, propietario.Nombre as Dueño, mascota.Nombre, mascota.Especie, mascota.Raza, mascota.F_Nacimiento, mascota.Genero, mascota.Peso
FROM mascota
JOIN propietario ON mascota.id_Propietario = propietario.id_Propietario;








/*
CREATE VIEW vista_clientes_pedidos AS
SELECT clientes.nombre, pedidos.fecha
FROM clientes
JOIN pedidos ON clientes.id_cliente = pedidos.id_cliente;
id_Propietario, Nombre, Especie, Raza, F_Nacimiento, Genero, Peso
P = Propietario,
M = Mascota

CREATE VIEW vista_mascotas_propietarios AS
SELECT mascotas.nombre, propietarios.nombre AS nombre_propietario
FROM mascotas
JOIN propietarios ON mascotas.id_propietario = propietarios.id_propietario;
*/