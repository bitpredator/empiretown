INSERT INTO `addon_account` (name, label, shared) VALUES
	('society_police', 'Polizia', 1)
;

INSERT INTO `datastore` (name, label, shared) VALUES
	('society_police', 'Polizia', 1)
;

INSERT INTO `addon_inventory` (name, label, shared) VALUES
	('society_police', 'Polizia', 1)
;

INSERT INTO `jobs` (name, label) VALUES
	('police', 'Polizia')
;

INSERT INTO `job_grades` (job_name, grade, name, label, salary, skin_male, skin_female) VALUES
	('police',0,'recruit','Recluta',20,'{}','{}'),
	('police',1,'officer','Agente',40,'{}','{}'),
	('police',2,'sergeant','Sergente',60,'{}','{}'),
	('police',3,'lieutenant','Tenente',85,'{}','{}'),
	('police',4,'boss','Capo',100,'{}','{}')
;