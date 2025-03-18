-- Определить, какие классы автомобилей имеют наибольшее количество автомобилей с низкой средней позицией (больше 3.0)
-- и вывести информацию о каждом автомобиле из этих классов, включая его имя, класс, среднюю позицию, количество гонок,
-- в которых он участвовал, страну производства класса автомобиля, а также общее количество гонок для каждого класса.
-- Отсортировать результаты по количеству автомобилей с низкой средней позицией.

WITH CarStats AS (
    SELECT
        c.name AS car_name,
        c.class AS car_class,
        AVG(r.position) AS average_position,
        COUNT(r.race) AS race_count,
        cl.country AS car_country
    FROM Results r
             JOIN Cars c ON r.car = c.name
             JOIN Classes cl ON c.class = cl.class
    GROUP BY c.name, c.class, cl.country
    HAVING AVG(r.position) > 3.0
),

     ClassLowCounts AS (
         SELECT
             car_class,
             COUNT(car_name) AS low_position_count,
             SUM(race_count) AS total_races
         FROM CarStats
         GROUP BY car_class
     ),

     MaxLowCount AS (
         SELECT MAX(low_position_count) AS max_count
         FROM ClassLowCounts
     ),

     TopClasses AS (
         SELECT
             clc.car_class,
             clc.low_position_count,
             clc.total_races
         FROM ClassLowCounts clc
                  CROSS JOIN MaxLowCount mlc
         WHERE clc.low_position_count = mlc.max_count
     )

SELECT
    cs.car_name,
    cs.car_class,
    cs.average_position,
    cs.race_count,
    cs.car_country,
    tc.total_races,
    tc.low_position_count
FROM CarStats cs
         JOIN TopClasses tc ON cs.car_class = tc.car_class
ORDER BY tc.low_position_count DESC, cs.car_class, cs.car_name;