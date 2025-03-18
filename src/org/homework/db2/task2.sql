-- Определить автомобиль, который имеет наименьшую среднюю позицию в гонках среди всех автомобилей,
-- и вывести информацию об этом автомобиле, включая его класс, среднюю позицию, количество гонок,
-- в которых он участвовал, и страну производства класса автомобиля.
-- Если несколько автомобилей имеют одинаковую наименьшую среднюю позицию, выбрать один из них по алфавиту (по имени автомобиля).

WITH car_avg_position AS (
    SELECT c.name AS car_name, c.class AS car_class,
           AVG(res.position) AS average_position,
           COUNT(res.race) AS race_count,
           cl.country AS car_country
    FROM cars c
    JOIN classes cl on c.class = cl.class
    JOIN results res on c.name = res.car
    GROUP BY c.name, c.class, cl.country
),
min_avg_position AS (
    SELECT MIN(average_position) AS min_avg_position
    FROM car_avg_position
)
SELECT cap.car_name, cap.car_class, cap.average_position, cap.race_count, cap.car_country
FROM car_avg_position cap
JOIN min_avg_position map ON cap.average_position = map.min_avg_position
ORDER BY cap.car_name ASC
LIMIT 1;
