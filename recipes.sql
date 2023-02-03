-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema recipes
-- -----------------------------------------------------
-- Final Project CIT225
DROP SCHEMA IF EXISTS `recipes` ;

-- -----------------------------------------------------
-- Schema recipes
--
-- Final Project CIT225
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `recipes` DEFAULT CHARACTER SET utf8 COLLATE utf8_bin ;
USE `recipes` ;

-- -----------------------------------------------------
-- Table `recipes`.`rating`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `recipes`.`rating` ;

CREATE TABLE IF NOT EXISTS `recipes`.`rating` (
  `rating_id` INT NOT NULL AUTO_INCREMENT,
  `rating` ENUM('5', '4', '3', '2', '1') NOT NULL,
  PRIMARY KEY (`rating_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `recipes`.`ingredients`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `recipes`.`ingredients` ;

CREATE TABLE IF NOT EXISTS `recipes`.`ingredients` (
  `ingredients_id` INT NOT NULL AUTO_INCREMENT,
  `ingredients` TEXT(1500) NOT NULL,
  PRIMARY KEY (`ingredients_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `recipes`.`how_to`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `recipes`.`how_to` ;

CREATE TABLE IF NOT EXISTS `recipes`.`how_to` (
  `how_to_id` INT NOT NULL AUTO_INCREMENT,
  `how_to_make` VARCHAR(1500) NOT NULL,
  PRIMARY KEY (`how_to_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `recipes`.`difficulty`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `recipes`.`difficulty` ;

CREATE TABLE IF NOT EXISTS `recipes`.`difficulty` (
  `difficulty_id` INT NOT NULL AUTO_INCREMENT,
  `difficulty` ENUM('Expert', 'Comfortable', 'Beginner', 'Children') NOT NULL,
  PRIMARY KEY (`difficulty_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `recipes`.`time_to_make`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `recipes`.`time_to_make` ;

CREATE TABLE IF NOT EXISTS `recipes`.`time_to_make` (
  `time_to_make_id` INT NOT NULL AUTO_INCREMENT,
  `time_amount` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`time_to_make_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `recipes`.`meal_time`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `recipes`.`meal_time` ;

CREATE TABLE IF NOT EXISTS `recipes`.`meal_time` (
  `meal_time_id` INT NOT NULL AUTO_INCREMENT,
  `meal_time_col` ENUM('Breakfast', 'Lunch', 'Dinner', 'Any') NOT NULL,
  PRIMARY KEY (`meal_time_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `recipes`.`recipes`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `recipes`.`recipes` ;

CREATE TABLE IF NOT EXISTS `recipes`.`recipes` (
  `recipes_id` INT NOT NULL AUTO_INCREMENT,
  `recipes_name` VARCHAR(45) NOT NULL,
  `recipes_description` VARCHAR(45) NULL,
  `rating_id` INT NOT NULL,
  `ingredients_id` INT NOT NULL,
  `how_to_id` INT NOT NULL,
  `difficulty_id` INT NOT NULL,
  `time_to_make_id` INT NOT NULL,
  `meal_time_id` INT NOT NULL,
  PRIMARY KEY (`recipes_id`, `rating_id`, `ingredients_id`, `how_to_id`, `difficulty_id`, `time_to_make_id`, `meal_time_id`),
  INDEX `fk_recipes_rating1_idx` (`rating_id` ASC) VISIBLE,
  INDEX `fk_recipes_ingredients1_idx` (`ingredients_id` ASC) VISIBLE,
  INDEX `fk_recipes_how_to1_idx` (`how_to_id` ASC) VISIBLE,
  INDEX `fk_recipes_difficulty1_idx` (`difficulty_id` ASC) VISIBLE,
  INDEX `fk_recipes_time_to_make1_idx` (`time_to_make_id` ASC) VISIBLE,
  INDEX `fk_recipes_meal_time1_idx` (`meal_time_id` ASC) VISIBLE,
  CONSTRAINT `fk_recipes_rating1`
    FOREIGN KEY (`rating_id`)
    REFERENCES `recipes`.`rating` (`rating_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_recipes_ingredients1`
    FOREIGN KEY (`ingredients_id`)
    REFERENCES `recipes`.`ingredients` (`ingredients_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_recipes_how_to1`
    FOREIGN KEY (`how_to_id`)
    REFERENCES `recipes`.`how_to` (`how_to_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_recipes_difficulty1`
    FOREIGN KEY (`difficulty_id`)
    REFERENCES `recipes`.`difficulty` (`difficulty_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_recipes_time_to_make1`
    FOREIGN KEY (`time_to_make_id`)
    REFERENCES `recipes`.`time_to_make` (`time_to_make_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_recipes_meal_time1`
    FOREIGN KEY (`meal_time_id`)
    REFERENCES `recipes`.`meal_time` (`meal_time_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `recipes`.`contributor`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `recipes`.`contributor` ;

CREATE TABLE IF NOT EXISTS `recipes`.`contributor` (
  `contributor_id` INT NOT NULL AUTO_INCREMENT,
  `contributor_name` VARCHAR(45) NOT NULL,
  `contributor_email` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`contributor_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `recipes`.`food_category`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `recipes`.`food_category` ;

CREATE TABLE IF NOT EXISTS `recipes`.`food_category` (
  `food_category_id` INT NOT NULL AUTO_INCREMENT,
  `food_category_name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`food_category_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `recipes`.`image`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `recipes`.`image` ;

CREATE TABLE IF NOT EXISTS `recipes`.`image` (
  `image_id` INT NOT NULL AUTO_INCREMENT,
  `image_name` VARCHAR(45) NOT NULL,
  `image_file` BLOB NOT NULL,
  PRIMARY KEY (`image_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `recipes`.`key_ingredient`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `recipes`.`key_ingredient` ;

CREATE TABLE IF NOT EXISTS `recipes`.`key_ingredient` (
  `key_ingredient_id` INT NOT NULL AUTO_INCREMENT,
  `key_ingredient_name` VARCHAR(30) NOT NULL,
  PRIMARY KEY (`key_ingredient_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `recipes`.`recipes_has_contributors`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `recipes`.`recipes_has_contributors` ;

CREATE TABLE IF NOT EXISTS `recipes`.`recipes_has_contributors` (
  `recipes_id` INT NOT NULL,
  `contributor_id` INT NOT NULL,
  PRIMARY KEY (`recipes_id`, `contributor_id`),
  INDEX `fk_recipes_has_contributor_contributor1_idx` (`contributor_id` ASC) VISIBLE,
  INDEX `fk_recipes_has_contributor_recipes_idx` (`recipes_id` ASC) VISIBLE,
  CONSTRAINT `fk_recipes_has_contributor_recipes`
    FOREIGN KEY (`recipes_id`)
    REFERENCES `recipes`.`recipes` (`recipes_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_recipes_has_contributor_contributor1`
    FOREIGN KEY (`contributor_id`)
    REFERENCES `recipes`.`contributor` (`contributor_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `recipes`.`recipes_has_food_category`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `recipes`.`recipes_has_food_category` ;

CREATE TABLE IF NOT EXISTS `recipes`.`recipes_has_food_category` (
  `recipes_id` INT NOT NULL,
  `food_category_id` INT NOT NULL,
  PRIMARY KEY (`recipes_id`, `food_category_id`),
  INDEX `fk_recipes_has_food_category_food_category1_idx` (`food_category_id` ASC) VISIBLE,
  INDEX `fk_recipes_has_food_category_recipes1_idx` (`recipes_id` ASC) VISIBLE,
  CONSTRAINT `fk_recipes_has_food_category_recipes1`
    FOREIGN KEY (`recipes_id`)
    REFERENCES `recipes`.`recipes` (`recipes_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_recipes_has_food_category_food_category1`
    FOREIGN KEY (`food_category_id`)
    REFERENCES `recipes`.`food_category` (`food_category_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `recipes`.`recipes_has_image`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `recipes`.`recipes_has_image` ;

CREATE TABLE IF NOT EXISTS `recipes`.`recipes_has_image` (
  `recipes_id` INT NOT NULL,
  `image_id` INT NOT NULL,
  PRIMARY KEY (`recipes_id`, `image_id`),
  INDEX `fk_recipes_has_image_image1_idx` (`image_id` ASC) VISIBLE,
  INDEX `fk_recipes_has_image_recipes1_idx` (`recipes_id` ASC) VISIBLE,
  CONSTRAINT `fk_recipes_has_image_recipes1`
    FOREIGN KEY (`recipes_id`)
    REFERENCES `recipes`.`recipes` (`recipes_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_recipes_has_image_image1`
    FOREIGN KEY (`image_id`)
    REFERENCES `recipes`.`image` (`image_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `recipes`.`recipes_has_key_ingredients`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `recipes`.`recipes_has_key_ingredients` ;

CREATE TABLE IF NOT EXISTS `recipes`.`recipes_has_key_ingredients` (
  `recipes_id` INT NOT NULL,
  `key_ingredient_id` INT NOT NULL,
  PRIMARY KEY (`recipes_id`, `key_ingredient_id`),
  INDEX `fk_recipes_has_key_ingredient_key_ingredient1_idx` (`key_ingredient_id` ASC) VISIBLE,
  INDEX `fk_recipes_has_key_ingredient_recipes1_idx` (`recipes_id` ASC) VISIBLE,
  CONSTRAINT `fk_recipes_has_key_ingredient_recipes1`
    FOREIGN KEY (`recipes_id`)
    REFERENCES `recipes`.`recipes` (`recipes_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_recipes_has_key_ingredient_key_ingredient1`
    FOREIGN KEY (`key_ingredient_id`)
    REFERENCES `recipes`.`key_ingredient` (`key_ingredient_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
