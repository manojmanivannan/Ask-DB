-- set send_logs_level = 'trace';


CREATE TABLE IF not EXISTS crime_data
(
  dr_no varchar(20),
  date_reported timestamp,
  date_occured timestamp,
  time_occured time,
  area int,
  area_name varchar(30),
  reported_dist_no int,
  part_1_2 int,
  crime_code int,
  mocodes varchar(60),
  victim_age int,
  victim_sex varchar(1),
  victim_descent varchar(1),
  premis_code int,
  premis_description varchar(80),
  weapon_used_code int,
  weapon_used_description varchar(50),
  status_code varchar(2),
  status_description varchar(20),
  crime_code_1 int,
  crime_code_2 int,
  crime_code_3 int,
  crime_code_4 int,
  location varchar(60),
  cross_street varchar(50),
  latitude numeric(11,8),
  longitude numeric(11,8)
);


CREATE TABLE IF not EXISTS crime_code_description
(
  crime_code int PRIMARY KEY,
  crime_description varchar(70)
);




copy crime_data
from '/dataset/crime_data_reformated.csv'
DELIMITER ','
CSV HEADER;

copy crime_code_description
from '/dataset/crime_code_description_reformated.csv'
DELIMITER ','
CSV HEADER;

ALTER TABLE crime_data
ADD CONSTRAINT fk_crime_code
FOREIGN KEY (crime_code)
REFERENCES crime_code_description(crime_code);


-- CREATE TABLE IF NOT EXISTS crime_vic_descent
-- (
-- 	  id serial,
--     code String,
--     description VARCHAR(35)
-- );

-- copy crime_vic_descent(code,description)
-- from '/dataset/crime_data.csv' FORMAT CSV;