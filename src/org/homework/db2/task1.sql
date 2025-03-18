-- Определить, какие автомобили из каждого класса имеют наименьшую среднюю позицию в гонках,
-- и вывести информацию о каждом таком автомобиле для данного класса, включая его класс,
-- среднюю позицию и количество гонок, в которых он участвовал. Также отсортировать результаты по средней позиции.

WITH car_avg_positions AS (
    SELECT c.name AS car_name, c.class AS car_class,
           AVG(res.position) AS average_position,
           COUNT(res.race) AS race_count
    FROM cars c
    JOIN results res ON c.name = res.car
    GROUP BY c.name, c.class
)
SELECT cap.car_name, cap.car_class, cap.average_position, cap.race_count
FROM car_avg_positions cap
JOIN (
    SELECT car_class, MIN(average_position) AS min_avg_position
    FROM car_avg_positions
    GROUP BY car_class
) min_positions
ON cap.car_class = min_positions.car_class
AND cap.average_position = min_positions.min_avg_position
ORDER BY cap.average_position ASC;