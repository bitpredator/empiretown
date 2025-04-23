INSERT INTO `addon_account` (name, label, shared) VALUES
	('society_governament', 'Governo', 1)
;

INSERT INTO `datastore` (name, label, shared) VALUES
	('society_governament', 'Governo', 1)
;

INSERT INTO `addon_inventory` (name, label, shared) VALUES
	('society_governament', 'Governo', 1)
;

INSERT INTO `jobs` (name, label) VALUES
	('governament', 'Governo')
;

INSERT INTO `job_grades` (job_name, grade, name, label, salary, skin_male, skin_female) VALUES
	('governament',0,'apprentice','Agente EPU',20,'{}','{}'),
	('governament',1,'gunsmith','Giudice',40,'{}','{}'),
	('governament',2,'governamentchief','Giudice Capo',60,'{}','{}'),
	('governament',3,'deputydirector','Sindaco',85,'{}','{}'),
	('governament',4,'boss','Governatore',100,'{}','{}')
;