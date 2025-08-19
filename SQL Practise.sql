CREATE SCHEMA SQL_Practise;
set search_path to SQL_Practise;

CREATE TABLE planets (
id INTEGER PRIMARY KEY,
name TEXT,
color TEXT,
num_of_moons INTEGER,
mass REAL,
rings BOOLEAN
);

select * from planets

INSERT INTO planets(id, name, color, num_of_moons, mass,rings)
VALUES
('1', 'Mercury', 'gray', '0', '0.55', 'FALSE'),
('2', 'Venus', 'yellow', '0', '0.82', 'FALSE'),
('3', 'Earth', 'blue', '1', '1.00', 'FALSE'),
('4', 'Mars', 'red', '2', '0.11', 'FALSE'),
('5', 'Jupiter', 'orange', '67', '317.90', 'FALSE'),
('6', 'Saturn', 'hazel', '62', '95.19', 'TRUE'),
('7', 'Uranus', 'light blue', '27', '14.54', 'TRUE'),
('8', 'Neptune', 'dark blue', '14', '17.15', 'TRUE' );

-- 1. Select just the name and color of each planet
select name, color from planets;
-- 2. Select all columns for each planet whose num_of_moons is 0
select * from planets where num_of_moons ='0';
-- 3. Select the name and mass of each planet whose name has exactly 7 letters
select name, mass from planets where LENGTH(name) = 7;
-- 4. Select all columns for each planet whose mass is greater than 1.00
select * from planets where mass > 1.00;
-- 5. Select the name and mass of each planet whose mass is less than or equal to 1.00
select name, mass from planets where mass <= 1.00;
-- 6. Select the name and mass of each planet whose mass is between 0 and 50
select name, mass from planets where mass between 0 and 50;
-- 7. Select all columns for planets that have at least one moon and a mass less than 1.00
select * from planets where num_of_moons >= 1 and mass < 1.00;
-- 8. Select the name and color of planets that have a color containing the string "blue"
select name, color from planets where color like '%blue%';
--9. Select the count of planets that don't have rings as planets_without_rings
select count(*) as planets_without_rings from planets where rings = 'false';
-- 10. Select the name of all planets, along with a value has_rings that returns "Yes" if the planet does have rings, and "No" if it does not
select name, case when rings = TRUE THEN 'Yes' ELSE 'No' END AS has_rings from planets;