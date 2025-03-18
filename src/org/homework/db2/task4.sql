-- Определить, какие автомобили имеют среднюю позицию лучше (меньше) средней позиции всех автомобилей в своем классе
-- (то есть автомобилей в классе должно быть минимум два, чтобы выбрать один из них).
-- Вывести информацию об этих автомобилях, включая их имя, класс, среднюю позицию, количество гонок,
-- в которых они участвовали, и страну производства класса автомобиля.
-- Также отсортировать результаты по классу и затем по средней позиции в порядке возрастания.

WITH car_stats AS (
    SELECT c.name AS car_name,  c.class AS car_class,
           AVG(res.position) AS avg_pos,
           COUNT(res.race) AS races_count
    FROM results res
    JOIN cars c on res.car = c.name
    GROUP BY c.name, c.class
),
class_stats AS (
    SELECT car_class, AVG(avg_pos) AS class_avg_pos,
           COUNT(car_name) AS car_count
    FROM car_stats
    GROUP BY car_class
    HAVING COUNT(car_name) >= 2
)
SELECT cs.car_name,
       cs.car_class,
       cs.avg_pos,
       cs.races_count,
       cl.country
FROM car_stats cs
JOIN class_stats cls ON cs.car_class = cls.car_class
JOIN classes cl ON cs.car_class = cl.class
WHERE cs.avg_pos < cls.class_avg_pos
ORDER BY cs.car_class ASC, cs.avg_pos ASC;