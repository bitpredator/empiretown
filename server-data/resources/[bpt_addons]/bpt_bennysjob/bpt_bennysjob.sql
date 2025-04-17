INSERT INTO `addon_account` (name, label, shared) VALUES
	('society_bennys', 'Bennys', 1)
;

INSERT INTO `datastore` (name, label, shared) VALUES
	('society_bennys', 'Bennys', 1)
;

INSERT INTO `addon_inventory` (name, label, shared) VALUES
	('society_bennys', 'Bennys', 1)
;

INSERT INTO `jobs` (name, label) VALUES
	('bennys', 'Bennys')
;

INSERT INTO `job_grades` (job_name, grade, name, label, salary, skin_male, skin_female) VALUES
	('bennys',0,'apprentice','Apprentice',20,'{}','{}'),
	('bennys',1,'gunsmith','Gunsmith',40,'{}','{}'),
	('bennys',2,'bennyschief','Bennys Chief',60,'{}','{}'),
	('bennys',3,'deputydirector','Deputy Director',85,'{}','{}'),
	('bennys',4,'boss','Boss',100,'{}','{}')
;