INSERT INTO `addon_account` (name, label, shared) VALUES
	('society_import', 'Import', 1)
;

INSERT INTO `datastore` (name, label, shared) VALUES
	('society_import', 'Import', 1)
;

INSERT INTO `addon_inventory` (name, label, shared) VALUES
	('society_import', 'Import', 1)
;

INSERT INTO `jobs` (name, label) VALUES
	('import', 'Import')
;

INSERT INTO `job_grades` (job_name, grade, name, label, salary, skin_male, skin_female) VALUES
	('import',0,'apprentice','Apprentice',20,'{}','{}'),
	('import',1,'gunsmith','Gunsmith',40,'{}','{}'),
	('import',2,'importchief','Armory Chief',60,'{}','{}'),
	('import',3,'deputydirector','Deputy Director',85,'{}','{}'),
	('import',4,'boss','Boss',100,'{}','{}')
;