-- Определить классы автомобилей, которые имеют наименьшую среднюю позицию в гонках,
-- и вывести информацию о каждом автомобиле из этих классов, включая его имя, среднюю позицию,
-- количество гонок, в которых он участвовал, страну производства класса автомобиля,
-- а также общее количество гонок, в которых участвовали автомобили этих классов.
-- Если несколько классов имеют одинаковую среднюю позицию, выбрать все из них.

WITH CarAvgPositions AS (
    SELECT c.name AS car_name, c.class AS car_class, cl.country,
           AVG(r.position) AS average_position,
           COUNT(r.race) AS race_count
    FROM Cars c
             JOIN Classes cl ON c.class = cl.class
             JOIN Results r ON c.name = r.car
    GROUP BY c.name, c.class, cl.country
),
ClassAvgPositions AS (
    SELECT car_class, AVG(average_position) AS class_avg_position,
            SUM(race_count) AS total_races
    FROM CarAvgPositions
    GROUP BY car_class
),
MinClassAvgPosition AS (
    SELECT MIN(class_avg_position) AS min_class_avg_position
    FROM ClassAvgPositions
)
SELECT cap.car_name, cap.car_class, cap.average_position, cap.race_count, cap.country, clap.total_races
FROM CarAvgPositions cap
         JOIN ClassAvgPositions clap ON cap.car_class = clap.car_class
         JOIN MinClassAvgPosition mcap ON clap.class_avg_position = mcap.min_class_avg_position
ORDER BY cap.car_class, cap.car_name;