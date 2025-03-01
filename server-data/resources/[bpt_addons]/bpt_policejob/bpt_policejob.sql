INSERT INTO `addon_account` (name, label, shared) VALUES
	('society_police', 'Police', 1)
;

INSERT INTO `datastore` (name, label, shared) VALUES
	('society_police', 'Police', 1)
;

INSERT INTO `addon_inventory` (name, label, shared) VALUES
	('society_police', 'Police', 1)
;

INSERT INTO `jobs` (name, label) VALUES
	('police', 'Police')
;

INSERT INTO `job_grades` (job_name, grade, name, label, salary, skin_male, skin_female) VALUES
	('police',0,'recruit','Recruit',20,'{}','{}'),
	('police',1,'officer','Officer',40,'{}','{}'),
	('police',2,'sergeant','Sergeant',60,'{}','{}'),
	('police',3,'lieutenant','Lieutenant',85,'{}','{}'),
	('police',4,'boss','Chief',100,'{}','{}')
;