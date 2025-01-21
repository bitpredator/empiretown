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
	('bandage', 'benda'),
	('cottonforbandages', 'cotone per bende'),
	('cotton', 'cotone'),
	('ironsheet', 'lamiera di ferro'),
	('steelsheet', 'lamiera di acciaio'),
	('garbage', 'rifiuti'),
	('WEAPON_APPISTOL', 'pistola AP'),
	('iron', 'Ferro'),
	('hammer', 'martello'),
	('wood', 'legna'),
	('fixkit', 'kit di riparazione'),
	('almondmilk', 'latte di mandorla'),
	('ice', 'ghiaccio'),
	('water', 'acqua'),
	('almonds', 'mandorle'),
	('fries', 'patatine fritte'),
	('potato', 'patate'),
	('trash_can', 'lattina usata'),
	('recycled_paper', 'carta riciclata'),
	('paper', 'carta'),
	('newspaper', 'giornale rovinato'),
	('trash_burgershot', 'scatola di burgershot usata'),
	('cigarette_paper', 'cartina'),
	('cigarrette_opium', 'sigaretta con oppio'),
	('opium', 'oppio'),
	('copper', 'Rame'),
	('gold', 'oro'),
	('gunpowder', 'polvere da sparo'),
	('ammo-sniper', '7.62 NATO'),
	('grain', 'grano'),
	('flour', 'farina'),
	('bread', 'panino vuoto'),
	('ammo-9', '9mm'),
	('WEAPON_KNIFE', 'coltello'),
	('WEAPON_KNUCKLE', 'tira pugni'),
	('steel', 'acciaio'),
	('plastic_bag', 'Sacchetto di plastica'),
	('recycled_plastic', 'Plastica riciclata'),
	('WEAPON_NIGHTSTICK', 'Manganello'),
	('WEAPON_PISTOL', 'Pistola 9mm'),
	('marijuana', 'marijuana'),
	('cannabis', 'Cannabis'),
	('diamond_tip', 'Punta di diamante'),
	('diamond', 'Diamante'),
	('marijuana_extract', 'Estratto di marijuana'),
	('medikit', 'Medikit'),
	('salmon_fillet', 'Filetto di salmone'),
	('armour', 'giubbotto antiproiettile'),
	('WEAPON_FLASHLIGHT', 'Torcia'),
	('contract', 'Contratto per auto'),
	('at_suppressor_light', 'Silenziatore'),
	('WEAPON_COMBATSHOTGUN', 'Fucile a pompa da combattimento'),
	('ammo-shotgun', 'Munizioni fucile a pompa'),
	('salmon', 'Salmone'),
	('fry_oil', 'olio per fritti'),
	('grilled_salmon', 'salmone grigliato'),
	('WEAPON_PISTOL_MK2', 'Pistola MK2'),
	('at_skin_luxe', 'Skin oro')
;