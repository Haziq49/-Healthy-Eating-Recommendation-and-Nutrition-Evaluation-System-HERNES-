-- MyFCD import schema and load script
-- Run in MySQL Workbench / CLI

CREATE DATABASE IF NOT EXISTS myfcd_db;
USE myfcd_db;

DROP TABLE IF EXISTS food_nutrients;
DROP TABLE IF EXISTS nutrients;
DROP TABLE IF EXISTS food_items;
DROP TABLE IF EXISTS temp_food_data;

CREATE TABLE food_items (
    food_id INT AUTO_INCREMENT PRIMARY KEY,
    food_name VARCHAR(255) NOT NULL,
    normalized_name VARCHAR(255) NOT NULL UNIQUE
);

CREATE TABLE nutrients (
    nutrient_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE food_nutrients (
    food_id INT,
    nutrient_id INT,
    value_per_100g DECIMAL(10,2),
    PRIMARY KEY (food_id, nutrient_id),
    FOREIGN KEY (food_id) REFERENCES food_items(food_id) ON DELETE CASCADE,
    FOREIGN KEY (nutrient_id) REFERENCES nutrients(nutrient_id) ON DELETE CASCADE
);

INSERT INTO nutrients (name) VALUES
('Energy'),
('Protein'),
('Fat'),
('Carbohydrate');

CREATE TABLE temp_food_data (
    food_name VARCHAR(255),
    energy DECIMAL(10,2),
    protein DECIMAL(10,2),
    fat DECIMAL(10,2),
    carbs DECIMAL(10,2)
);

-- Example:
-- LOAD DATA INFILE 'C:/mysql-files/myfcd.csv'
-- INTO TABLE temp_food_data
-- FIELDS TERMINATED BY ','
-- ENCLOSED BY '"'
-- LINES TERMINATED BY '\n'
-- IGNORE 1 ROWS;

INSERT INTO food_items (food_name, normalized_name)
SELECT DISTINCT food_name, LOWER(TRIM(food_name))
FROM temp_food_data;

INSERT INTO food_nutrients (food_id, nutrient_id, value_per_100g)
SELECT fi.food_id, n.nutrient_id, t.energy
FROM temp_food_data t
JOIN food_items fi ON fi.normalized_name = LOWER(TRIM(t.food_name))
JOIN nutrients n ON n.name = 'Energy';

INSERT INTO food_nutrients (food_id, nutrient_id, value_per_100g)
SELECT fi.food_id, n.nutrient_id, t.protein
FROM temp_food_data t
JOIN food_items fi ON fi.normalized_name = LOWER(TRIM(t.food_name))
JOIN nutrients n ON n.name = 'Protein';

INSERT INTO food_nutrients (food_id, nutrient_id, value_per_100g)
SELECT fi.food_id, n.nutrient_id, t.fat
FROM temp_food_data t
JOIN food_items fi ON fi.normalized_name = LOWER(TRIM(t.food_name))
JOIN nutrients n ON n.name = 'Fat';

INSERT INTO food_nutrients (food_id, nutrient_id, value_per_100g)
SELECT fi.food_id, n.nutrient_id, t.carbs
FROM temp_food_data t
JOIN food_items fi ON fi.normalized_name = LOWER(TRIM(t.food_name))
JOIN nutrients n ON n.name = 'Carbohydrate';

CREATE INDEX idx_food_name ON food_items(normalized_name);
CREATE INDEX idx_food_nutrient ON food_nutrients(food_id, nutrient_id);

-- Optional:
-- DROP TABLE temp_food_data;
