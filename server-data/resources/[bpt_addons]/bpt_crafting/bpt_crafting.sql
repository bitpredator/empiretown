USE `es_extended`;

ALTER TABLE `users` ADD `crafting_level` INT NOT NULL AFTER `loadout`;

CREATE TABLE `bpt_items` (
	`name` TEXT NULL DEFAULT NULL COLLATE 'utf8mb4_general_ci',
	`label` TEXT NULL DEFAULT NULL COLLATE 'utf8mb4_general_ci'
)
COLLATE='utf8mb4_general_ci'
ENGINE=InnoDB
;

INSERT INTO `bpt_items` (`name`, `label`) VALUES
	('bandage', 'bandage'),
	('cottonforbandages', 'cottonforbandages'),
	('cotton', 'cotton'),
	('ironsheet', 'ironsheet'),
	('steelsheet', 'steelsheet'),
	('garbage', 'garbage'),
	('WEAPON_APPISTOL', 'WEAPON APPISTOL'),
	('iron', 'iron'),
	('hammer', 'hammer'),
	('wood', 'Legna'),
	('fixkit', 'fixkit'),
	('almondmilk', 'almondmilk'),
	('ice', 'ice'),
	('water', 'water'),
	('almonds', 'almonds'),
	('chips', 'chips'),
	('fries', 'fries'),
	('potato', 'patato'),
	('trash_can', 'trash can'),
	('recycled_paper', 'recycled paper'),
	('paper', 'paper'),
	('newspaper', 'newspaper'),
	('trash_burgershot', 'trash burgershot'),
	('cigarette_paper', 'cigarette paper'),
	('cigarrette_opium', 'cigarrette opium'),
	('opium', 'opium'),
	('copper', 'copper'),
	('gold', 'gold'),
	('gunpowder', 'gunpowder'),
	('ammo-sniper', '7.62 NATO'),
	('grain', 'grain'),
	('flour', 'flour'),
	('bread', 'empty sandwich'),
	('ammo-9', '9mm'),
	('WEAPON_KNIFE', 'Knife'),
	('WEAPON_KNUCKLE', 'KNUCKLE'),
	('steel', 'steel'),
	('plastic_bag', 'Plastic bag'),
	('recycled_plastic', 'Recycled plastic'),
	('WEAPON_NIGHTSTICK', 'NIGHTSTICK'),
	('WEAPON_PISTOL', 'Pistol'),
	('marijuana', 'marijuana'),
	('cannabis', 'Cannabis'),
	('diamond_tip', 'Diamond tip'),
	('diamond', 'Diamond'),
	('marijuana_extract', 'Marijuana extract'),
	('medikit', 'Medikit'),
	('salmon_fillet', 'Salmon Fillet'),
	('armour', 'armour'),
	('WEAPON_FLASHLIGHT', 'WEAPON FLASHLIGHT'),
	('contract', 'Contract'),
	('at_suppressor_light', 'Suppressor'),
	('WEAPON_COMBATSHOTGUN', 'WEAPON COMBATSHOTGUN'),
	('ammo-shotgun', 'ammo shotgun'),
	('salmon', 'Salmon'),
	('fry_oil', 'Fry oil'),
	('grilled_salmon', 'grilled salmon'),
	('WEAPON_PISTOL_MK2', 'WEAPON PISTOL MK2'),
	('at_skin_luxe', 'Tint Gold')
;