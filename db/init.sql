set send_logs_level = 'trace';

CREATE database if not exists main;

USE main;

CREATE TABLE IF not EXISTS crime_data
(
  dr_no String,
  date_reported DateTime,
  date_occured DateTime,
  time_occured time,
  area UInt16,
  area_name String,
  reported_dist_no UInt16,
  part_1_2 UInt16,
  crime_code UInt16,
  crime_description String,
  mocodes Nullable(String),
  victim_age Float,
  victim_sex Nullable(String),
  victim_descent Nullable(String),
  premis_code Nullable(Float),
  premis_description Nullable(String),
  weapon_used_code Nullable(Float),
  weapon_used_description Nullable(String),
  status_code Nullable(String),
  status_description String,
  crime_code_1 Nullable(Float),
  crime_code_2 Nullable(Float),
  crime_code_3 Nullable(Float),
  crime_code_4 Nullable(Float),
  location String,
  cross_street Nullable(String),
  latitude Decimal(8),
  longitude Decimal(8)
)
ENGINE = MergeTree()
ORDER BY (dr_no)
TTL toStartOfDay(date_reported) + toIntervalDay(1750) SETTINGS index_granularity = 8192;


INSERT INTO crime_data from INFILE '/dataset/crime_data_reformated.csv' FORMAT CSV;


-- CREATE TABLE IF NOT EXISTS crime_vic_descent
-- (
-- 	  id serial,
--     code String,
--     description VARCHAR(35)
-- );

-- copy crime_vic_descent(code,description)
-- from '/dataset/crime_data.csv' FORMAT CSV;