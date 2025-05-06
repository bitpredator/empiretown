INSERT INTO `addon_account` (name, label, shared) VALUES
	('society_tridente', 'Tridente', 1)
;

INSERT INTO `datastore` (name, label, shared) VALUES
	('society_tridente', 'Tridente', 1)
;

INSERT INTO `addon_inventory` (name, label, shared) VALUES
	('society_tridente', 'Tridente', 1)
;

INSERT INTO `jobs` (name, label) VALUES
	('tridente', 'Tridente')
;

INSERT INTO `job_grades` (job_name, grade, name, label, salary, skin_male, skin_female) VALUES
	('tridente',0,'apprentice','Picciotto',0,'{}','{}'),
	('tridente',1,'gunsmith','Soldato',0,'{}','{}'),
	('tridente',2,'tridentechief','Sottocapo',0,'{}','{}'),
	('tridente',3,'deputydirector','Consigliere',0,'{}','{}'),
	('tridente',4,'boss','Vertice',0,'{}','{}')
;