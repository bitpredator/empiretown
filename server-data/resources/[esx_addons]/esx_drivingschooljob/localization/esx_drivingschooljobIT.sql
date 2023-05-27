INSERT INTO `addon_account` (name, label, shared) VALUES
  ('society_driving','Driving',1)
;

INSERT INTO `addon_inventory` (name, label, shared) VALUES
  ('society_driving','Driving',1)
;

INSERT INTO `jobs` (name, label) VALUES
  ('driving','Автошкола')
;

INSERT INTO `job_grades` (job_name, grade, name, label, salary, skin_male, skin_female) VALUES
  ('driving',0,'motorinstr','Istruttore moto',50,'{}','{}'),
  ('driving',1,'carinstr','Istruttore Auto',70,'{}','{}'),
  ('driving',2,'truckinstr','Istruttore Camion',120,'{}','{}'),
  ('driving',3,'examiner','Esaminatore',200,'{}','{}'),
  ('driving',4,'boss','Direttore',350,'{}','{}')
;