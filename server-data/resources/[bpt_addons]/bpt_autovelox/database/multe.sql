ALTER TABLE `owned_vehicles` ADD COLUMN `blocked_for_fine` TINYINT(1) NOT NULL DEFAULT 0 AFTER `vehicle`;
