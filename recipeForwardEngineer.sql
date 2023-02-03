-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema recipe
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `recipe` ;

-- -----------------------------------------------------
-- Schema recipe
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `recipe` DEFAULT CHARACTER SET utf8 ;
USE `recipe` ;

-- -----------------------------------------------------
-- Table `recipe`.`rating`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `recipe`.`rating` ;

CREATE TABLE IF NOT EXISTS `recipe`.`rating` (
  `rating_id` INT NOT NULL AUTO_INCREMENT,
  `rating` ENUM('5', '4', '3', '2', '1') NOT NULL,
  PRIMARY KEY (`rating_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `recipe`.`key_ingredient`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `recipe`.`key_ingredient` ;

CREATE TABLE IF NOT EXISTS `recipe`.`key_ingredient` (
  `key_ingredient_id` INT NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`key_ingredient_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `recipe`.`difficulty`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `recipe`.`difficulty` ;

CREATE TABLE IF NOT EXISTS `recipe`.`difficulty` (
  `difficulty_id` INT NOT NULL AUTO_INCREMENT,
  `difficulty_level` ENUM('hard', 'medium', 'easy') NOT NULL,
  PRIMARY KEY (`difficulty_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `recipe`.`time_to_make`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `recipe`.`time_to_make` ;

CREATE TABLE IF NOT EXISTS `recipe`.`time_to_make` (
  `time_to_make_id` INT NOT NULL AUTO_INCREMENT,
  `time_to_make` INT(4) NOT NULL,
  `time_measurement` ENUM('Minutes', 'Hours') NOT NULL,
  PRIMARY KEY (`time_to_make_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `recipe`.`ingredients`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `recipe`.`ingredients` ;

CREATE TABLE IF NOT EXISTS `recipe`.`ingredients` (
  `ingredients_id` INT NOT NULL AUTO_INCREMENT,
  `ingredient_list` BLOB NOT NULL,
  PRIMARY KEY (`ingredients_id`))
ENGINE = InnoDB
COMMENT = '	';


-- -----------------------------------------------------
-- Table `recipe`.`recipe_image`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `recipe`.`recipe_image` ;

CREATE TABLE IF NOT EXISTS `recipe`.`recipe_image` (
  `recipe_image_id` INT NOT NULL AUTO_INCREMENT,
  `recipe_image` BLOB NULL,
  PRIMARY KEY (`recipe_image_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `recipe`.`recipe`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `recipe`.`recipe` ;

CREATE TABLE IF NOT EXISTS `recipe`.`recipe` (
  `recipe_id` INT NOT NULL AUTO_INCREMENT,
  `rating_id` INT NOT NULL,
  `key_ingredient_id` INT NOT NULL,
  `difficulty_id` INT NOT NULL,
  `time_to_make_id` INT NOT NULL,
  `recipe_name` VARCHAR(45) NOT NULL,
  `ingredients_id` INT NOT NULL,
  `recipe_image_id` INT NOT NULL,
  PRIMARY KEY (`recipe_id`, `rating_id`, `key_ingredient_id`, `difficulty_id`, `time_to_make_id`, `ingredients_id`, `recipe_image_id`),
  INDEX `fk_recipe_rating1_idx` (`rating_id` ASC) VISIBLE,
  INDEX `fk_recipe_key_ingredient1_idx` (`key_ingredient_id` ASC) VISIBLE,
  INDEX `fk_recipe_difficulty1_idx` (`difficulty_id` ASC) VISIBLE,
  INDEX `fk_recipe_time_to_make1_idx` (`time_to_make_id` ASC) VISIBLE,
  INDEX `fk_recipe_ingredients1_idx` (`ingredients_id` ASC) VISIBLE,
  INDEX `fk_recipe_recipe_image1_idx` (`recipe_image_id` ASC) VISIBLE,
  CONSTRAINT `fk_recipe_rating1`
    FOREIGN KEY (`rating_id`)
    REFERENCES `recipe`.`rating` (`rating_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_recipe_key_ingredient1`
    FOREIGN KEY (`key_ingredient_id`)
    REFERENCES `recipe`.`key_ingredient` (`key_ingredient_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_recipe_difficulty1`
    FOREIGN KEY (`difficulty_id`)
    REFERENCES `recipe`.`difficulty` (`difficulty_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_recipe_time_to_make1`
    FOREIGN KEY (`time_to_make_id`)
    REFERENCES `recipe`.`time_to_make` (`time_to_make_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_recipe_ingredients1`
    FOREIGN KEY (`ingredients_id`)
    REFERENCES `recipe`.`ingredients` (`ingredients_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_recipe_recipe_image1`
    FOREIGN KEY (`recipe_image_id`)
    REFERENCES `recipe`.`recipe_image` (`recipe_image_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `recipe`.`contributor`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `recipe`.`contributor` ;

CREATE TABLE IF NOT EXISTS `recipe`.`contributor` (
  `contributor_id` INT NOT NULL AUTO_INCREMENT,
  `contributor_name` VARCHAR(25) NOT NULL,
  `contributor_email` VARCHAR(35) NOT NULL,
  PRIMARY KEY (`contributor_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `recipe`.`food_category`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `recipe`.`food_category` ;

CREATE TABLE IF NOT EXISTS `recipe`.`food_category` (
  `food_category_id` INT NOT NULL AUTO_INCREMENT,
  `recipe_id` INT NOT NULL,
  `category_name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`food_category_id`, `recipe_id`),
  INDEX `fk_food_category_recipe1_idx` (`recipe_id` ASC) VISIBLE,
  CONSTRAINT `fk_food_category_recipe1`
    FOREIGN KEY (`recipe_id`)
    REFERENCES `recipe`.`recipe` (`recipe_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `recipe`.`recipe_has_contributor`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `recipe`.`recipe_has_contributor` ;

CREATE TABLE IF NOT EXISTS `recipe`.`recipe_has_contributor` (
  `recipe_id` INT NOT NULL,
  `contributor_id` INT NOT NULL,
  PRIMARY KEY (`recipe_id`, `contributor_id`),
  INDEX `fk_recipe_has_contributor_contributor1_idx` (`contributor_id` ASC) VISIBLE,
  INDEX `fk_recipe_has_contributor_recipe_idx` (`recipe_id` ASC) VISIBLE,
  CONSTRAINT `fk_recipe_has_contributor_recipe`
    FOREIGN KEY (`recipe_id`)
    REFERENCES `recipe`.`recipe` (`recipe_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_recipe_has_contributor_contributor1`
    FOREIGN KEY (`contributor_id`)
    REFERENCES `recipe`.`contributor` (`contributor_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
