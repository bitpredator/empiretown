CREATE TABLE IF NOT EXISTS `money_laundry` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `identifier` VARCHAR(60) NOT NULL,
  `amount` INT NOT NULL,
  `ready_time` INT NOT NULL,
  PRIMARY KEY (`id`)
);
