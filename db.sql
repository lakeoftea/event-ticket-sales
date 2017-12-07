-- MySQL Script generated by MySQL Workbench
-- Wed 06 Dec 2017 08:40:48 PM CST
-- Model: New Model    Version: 1.0
-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- Schema event_ticket_sales
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema event_ticket_sales
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `event_ticket_sales` DEFAULT CHARACTER SET utf8 ;
USE `event_ticket_sales` ;

-- -----------------------------------------------------
-- Table `event_ticket_sales`.`Role`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `event_ticket_sales`.`Role` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NULL,
  `description` VARCHAR(45) NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `event_ticket_sales`.`media`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `event_ticket_sales`.`media` (
  `id` INT NOT NULL AUTO_INCREMENT COMMENT 'https://stackoverflow.com/questions/5160591/how-to-design-a-media-table-with-references-to-multiple-at-least-4-tables',
  `name` VARCHAR(120) NULL,
  `description` VARCHAR(120) NULL,
  `url` VARCHAR(120) NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB
COMMENT = 'media holds a url that points to an s3 bucket.  holds xslt, background images, photos for events/venues';


-- -----------------------------------------------------
-- Table `event_ticket_sales`.`Account`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `event_ticket_sales`.`Account` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `username` VARCHAR(45) NULL,
  `password` VARCHAR(45) NULL,
  `fullname` VARCHAR(70) NULL,
  `email` VARCHAR(45) NULL,
  `phoneNumber` VARCHAR(45) NULL,
  `lastLoggedIn` DATETIME NULL,
  `passwordResetToken` VARCHAR(45) NULL,
  `city` VARCHAR(45) NULL,
  `streetAddress` VARCHAR(45) NULL,
  `state` VARCHAR(45) NULL,
  `zip` VARCHAR(45) NULL,
  `confirmationToken` VARCHAR(120) NULL,
  `avatar` INT NULL,
  `roleId` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_role_id_idx` (`roleId` ASC),
  INDEX `fk_media_id_idx` (`avatar` ASC),
  CONSTRAINT `fk_account_role_id`
    FOREIGN KEY (`roleId`)
    REFERENCES `event_ticket_sales`.`Role` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_account_media_id`
    FOREIGN KEY (`avatar`)
    REFERENCES `event_ticket_sales`.`media` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `event_ticket_sales`.`venue`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `event_ticket_sales`.`venue` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NULL,
  `description` VARCHAR(120) NULL,
  `cover_photo_media_id` INT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_cover_photo_media_id_idx` (`cover_photo_media_id` ASC),
  CONSTRAINT `fk_venue_cover_photo_media_id`
    FOREIGN KEY (`cover_photo_media_id`)
    REFERENCES `event_ticket_sales`.`media` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = 'Stores name, description and fk to partical ';


-- -----------------------------------------------------
-- Table `event_ticket_sales`.`event`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `event_ticket_sales`.`event` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NULL,
  `fight_starts` DATETIME NULL,
  `doors_open` DATETIME NULL,
  `enabled` TINYINT NULL,
  `venue_id` INT NULL,
  `cover_photo_media_id` INT NULL,
  `description` VARCHAR(120) NULL,
  `event_expired` DATETIME NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_cover_photo_media_id_idx` (`cover_photo_media_id` ASC),
  CONSTRAINT `fk_event_venue_id`
    FOREIGN KEY (`id`)
    REFERENCES `event_ticket_sales`.`venue` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_event_cover_photo_media_id`
    FOREIGN KEY (`cover_photo_media_id`)
    REFERENCES `event_ticket_sales`.`media` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `event_ticket_sales`.`event_media_xref`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `event_ticket_sales`.`event_media_xref` (
  `media_id` INT NOT NULL,
  `event_id` INT NOT NULL,
  PRIMARY KEY (`media_id`, `event_id`),
  INDEX `fk_event_id_idx` (`event_id` ASC),
  CONSTRAINT `fk_event_media_xref_event_id`
    FOREIGN KEY (`event_id`)
    REFERENCES `event_ticket_sales`.`event` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_event_media_xref_media_id`
    FOREIGN KEY (`media_id`)
    REFERENCES `event_ticket_sales`.`media` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `event_ticket_sales`.`venue_media_xref`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `event_ticket_sales`.`venue_media_xref` (
  `venue_id` INT NOT NULL,
  `media_id` INT NOT NULL,
  PRIMARY KEY (`venue_id`, `media_id`),
  INDEX `media_id_idx` (`media_id` ASC),
  CONSTRAINT `fk_venue_media_xref_venue_id`
    FOREIGN KEY (`venue_id`)
    REFERENCES `event_ticket_sales`.`venue` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_venue_media_xref_media_id`
    FOREIGN KEY (`media_id`)
    REFERENCES `event_ticket_sales`.`media` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `event_ticket_sales`.`ticket`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `event_ticket_sales`.`ticket` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NULL,
  `price` DECIMAL NULL,
  `description` VARCHAR(120) NULL,
  `xslt_media_id` INT NULL,
  `xslt_background_media_id` INT NULL,
  `cover_photo_media_id` INT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_ticket_xslt_background_media_id_idx` (`xslt_background_media_id` ASC),
  INDEX `fk_ticket_xslt_media_id_idx` (`xslt_media_id` ASC),
  INDEX `fk_ticket_cover_photo_media_id_idx` (`cover_photo_media_id` ASC),
  CONSTRAINT `fk_ticket_cover_photo_media_id`
    FOREIGN KEY (`cover_photo_media_id`)
    REFERENCES `event_ticket_sales`.`media` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_ticket_xslt_media_id`
    FOREIGN KEY (`xslt_media_id`)
    REFERENCES `event_ticket_sales`.`media` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_ticket_xslt_background_media_id`
    FOREIGN KEY (`xslt_background_media_id`)
    REFERENCES `event_ticket_sales`.`media` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = 'stores information about individual tickets (i.e. battle at bluenote cage seat, general admission, table seat, children).  Can be associated with a discount.';


-- -----------------------------------------------------
-- Table `event_ticket_sales`.`ticket_media_xref`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `event_ticket_sales`.`ticket_media_xref` (
  `ticket_id` INT NOT NULL,
  `media_id` INT NOT NULL,
  PRIMARY KEY (`ticket_id`, `media_id`),
  INDEX `media_id_idx` (`media_id` ASC),
  CONSTRAINT `fk_ticket_media_xref_ticket_id`
    FOREIGN KEY (`ticket_id`)
    REFERENCES `event_ticket_sales`.`ticket` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_ticket_media_xref_media_id`
    FOREIGN KEY (`media_id`)
    REFERENCES `event_ticket_sales`.`media` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `event_ticket_sales`.`receipt`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `event_ticket_sales`.`receipt` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `date` DATETIME NULL,
  `account_id` INT NOT NULL,
  `xslt_media_id` INT NULL,
  `xslt_background_media_id` INT NULL,
  `name` VARCHAR(120) NULL,
  `phone_number` VARCHAR(20) NULL,
  `email` VARCHAR(70) NULL,
  `total_after_discounts_and_taxes` VARCHAR(45) NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_account_id_idx` (`account_id` ASC),
  INDEX `fk_xslt_media_id_idx` (`xslt_media_id` ASC),
  INDEX `fk_xslt_background_media_id_idx` (`xslt_background_media_id` ASC),
  CONSTRAINT `fk_receipt_account_id`
    FOREIGN KEY (`account_id`)
    REFERENCES `event_ticket_sales`.`Account` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_receipt_xslt_media_id`
    FOREIGN KEY (`xslt_media_id`)
    REFERENCES `event_ticket_sales`.`media` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_receipt_xslt_background_media_id`
    FOREIGN KEY (`xslt_background_media_id`)
    REFERENCES `event_ticket_sales`.`media` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = 'A receipt is a purchase by a customer.  That customer can either be registered or anonymous.  It has a xref table receipt_ticket_xref that contains each record sold.';


-- -----------------------------------------------------
-- Table `event_ticket_sales`.`ticket_event_xref`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `event_ticket_sales`.`ticket_event_xref` (
  `ticket_id` INT NOT NULL,
  `event_id` INT NOT NULL,
  PRIMARY KEY (`ticket_id`, `event_id`),
  INDEX `fk_event_id_idx` (`event_id` ASC),
  CONSTRAINT `fk_ticket_event_xref_ticket_id`
    FOREIGN KEY (`ticket_id`)
    REFERENCES `event_ticket_sales`.`ticket` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_ticket_event_xref_event_id`
    FOREIGN KEY (`event_id`)
    REFERENCES `event_ticket_sales`.`event` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `event_ticket_sales`.`receipt_ticket_xref`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `event_ticket_sales`.`receipt_ticket_xref` (
  `receipt_id` INT NOT NULL,
  `ticket_id` INT NOT NULL,
  `consumed` SMALLINT NOT NULL DEFAULT 0,
  `date_consumed` DATETIME NULL,
  `price_after_discounts` DECIMAL NULL,
  PRIMARY KEY (`receipt_id`, `ticket_id`),
  INDEX `fk_ticket_id_idx` (`ticket_id` ASC),
  CONSTRAINT `fk_receipt_ticket_xref_receipt_id`
    FOREIGN KEY (`receipt_id`)
    REFERENCES `event_ticket_sales`.`receipt` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_receipt_ticket_xref_ticket_id`
    FOREIGN KEY (`ticket_id`)
    REFERENCES `event_ticket_sales`.`ticket` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = 'cross reference table ticket and receipt.  every ticket sold is represented in this database.  discount applied is recorded here too since discounts can be ';


-- -----------------------------------------------------
-- Table `event_ticket_sales`.`Config`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `event_ticket_sales`.`Config` (
  `id` INT NOT NULL,
  `fightLeagueName` VARCHAR(120) NOT NULL,
  `googleCaptchaV2Key` VARCHAR(45) NULL,
  `braintreeKey` VARCHAR(45) NULL,
  PRIMARY KEY (`fightLeagueName`, `id`))
ENGINE = InnoDB
COMMENT = 'TODO: discount behavior, sum off all or highest applied discount';


-- -----------------------------------------------------
-- Table `event_ticket_sales`.`discount`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `event_ticket_sales`.`discount` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(120) NULL,
  `description` VARCHAR(200) NULL,
  `percentage_discount` DECIMAL NULL,
  `datetime_expire` DATETIME NULL,
  `discount_requires_registration` SMALLINT NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`))
ENGINE = InnoDB
COMMENT = 'Discounts can be applied to events, venues, or tickets.';


-- -----------------------------------------------------
-- Table `event_ticket_sales`.`discount_venue_xref`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `event_ticket_sales`.`discount_venue_xref` (
  `discount_id` INT NOT NULL,
  `venue_id` INT NOT NULL,
  PRIMARY KEY (`discount_id`, `venue_id`),
  INDEX `fk_venue_id_idx` (`venue_id` ASC),
  CONSTRAINT `fk_discount_venue_xref_discount_id`
    FOREIGN KEY (`discount_id`)
    REFERENCES `event_ticket_sales`.`discount` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_discount_venue_xref_venue_id`
    FOREIGN KEY (`venue_id`)
    REFERENCES `event_ticket_sales`.`venue` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `event_ticket_sales`.`discount_event_xref`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `event_ticket_sales`.`discount_event_xref` (
  `discount_id` INT NOT NULL,
  `event_id` INT NOT NULL,
  PRIMARY KEY (`discount_id`, `event_id`),
  INDEX `fk_event_id_idx` (`event_id` ASC),
  CONSTRAINT `fk_discount_event_xref_discount_id`
    FOREIGN KEY (`discount_id`)
    REFERENCES `event_ticket_sales`.`discount` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_discount_event_xref_event_id`
    FOREIGN KEY (`event_id`)
    REFERENCES `event_ticket_sales`.`event` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `event_ticket_sales`.`discount_ticket_xref`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `event_ticket_sales`.`discount_ticket_xref` (
  `discount_id` INT NOT NULL,
  `ticket_id` INT NOT NULL,
  PRIMARY KEY (`discount_id`, `ticket_id`),
  INDEX `fk_ticket_id_idx` (`ticket_id` ASC),
  CONSTRAINT `fk_discount_id`
    FOREIGN KEY (`discount_id`)
    REFERENCES `event_ticket_sales`.`discount` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_ticket_id`
    FOREIGN KEY (`ticket_id`)
    REFERENCES `event_ticket_sales`.`ticket` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `event_ticket_sales`.`merchandise`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `event_ticket_sales`.`merchandise` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(70) NULL,
  `description` VARCHAR(120) NULL,
  `cover_photo_media_id` INT NULL,
  `price` DECIMAL NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_cover_photo_id_idx` (`cover_photo_media_id` ASC),
  CONSTRAINT `fk_merchandise_cover_photo_media_id`
    FOREIGN KEY (`cover_photo_media_id`)
    REFERENCES `event_ticket_sales`.`media` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = 'merchandise can exists on its own or be associated to events.';


-- -----------------------------------------------------
-- Table `event_ticket_sales`.`merchandise_media_xref`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `event_ticket_sales`.`merchandise_media_xref` (
  `media_id` INT NOT NULL,
  `merchandise_id` INT NOT NULL,
  PRIMARY KEY (`media_id`, `merchandise_id`),
  INDEX `fk_merchandise_id_idx` (`merchandise_id` ASC),
  CONSTRAINT `fk_merchandise_media_xref_media_id`
    FOREIGN KEY (`media_id`)
    REFERENCES `event_ticket_sales`.`media` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_merchandise_media_xref_merchandise_id`
    FOREIGN KEY (`merchandise_id`)
    REFERENCES `event_ticket_sales`.`merchandise` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `event_ticket_sales`.`merchandise_discount_xref`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `event_ticket_sales`.`merchandise_discount_xref` (
  `discount_id` INT NOT NULL,
  `merchandise_id` INT NOT NULL,
  PRIMARY KEY (`discount_id`, `merchandise_id`),
  INDEX `fk_merchandise_id_idx` (`merchandise_id` ASC),
  CONSTRAINT `fk_merchandise_discount_xref_discount_id`
    FOREIGN KEY (`discount_id`)
    REFERENCES `event_ticket_sales`.`discount` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_merchandise_discount_xref_merchandise_id`
    FOREIGN KEY (`merchandise_id`)
    REFERENCES `event_ticket_sales`.`merchandise` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `event_ticket_sales`.`merchandise_receipt_xref`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `event_ticket_sales`.`merchandise_receipt_xref` (
  `merchandise_id` INT NOT NULL,
  `receipt_id` INT NOT NULL,
  `price_after_discounts` DECIMAL NULL,
  PRIMARY KEY (`merchandise_id`, `receipt_id`),
  INDEX `fk_receipt_id_idx` (`receipt_id` ASC),
  CONSTRAINT `fk_merchandise_receipt_xref_merchandise_id`
    FOREIGN KEY (`merchandise_id`)
    REFERENCES `event_ticket_sales`.`merchandise` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_merchandise_receipt_xref_receipt_id`
    FOREIGN KEY (`receipt_id`)
    REFERENCES `event_ticket_sales`.`receipt` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `event_ticket_sales`.`merchandise_event_xref`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `event_ticket_sales`.`merchandise_event_xref` (
  `merchandise_id` INT NOT NULL,
  `event_id` INT NOT NULL,
  PRIMARY KEY (`merchandise_id`, `event_id`),
  INDEX `fk_event_id_idx` (`event_id` ASC),
  INDEX `fk_merchandise_idx` USING BTREE (`merchandise_id` ASC),
  CONSTRAINT `fk_merchandise_event_xref_merchandise_id`
    FOREIGN KEY (`merchandise_id`)
    REFERENCES `event_ticket_sales`.`merchandise` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_merchandise_event_xref_event_id`
    FOREIGN KEY (`event_id`)
    REFERENCES `event_ticket_sales`.`event` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = 'merchandise can be associated with events for promotional purposes';


-- -----------------------------------------------------
-- Table `event_ticket_sales`.`category`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `event_ticket_sales`.`category` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(120) NULL,
  `description` VARCHAR(120) NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `event_ticket_sales`.`merchandise_category_xref`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `event_ticket_sales`.`merchandise_category_xref` (
  `merchandise_id` INT NOT NULL,
  `category_id` INT NOT NULL,
  PRIMARY KEY (`merchandise_id`, `category_id`),
  INDEX `fk_category_id_idx` (`category_id` ASC),
  CONSTRAINT `fk_merchandise_category_xref_category_id`
    FOREIGN KEY (`category_id`)
    REFERENCES `event_ticket_sales`.`category` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_merchandise_category_xref_merchandise_id`
    FOREIGN KEY (`merchandise_id`)
    REFERENCES `event_ticket_sales`.`merchandise` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
