-- Определить, какие клиенты сделали более двух бронирований в разных отелях,
-- и вывести информацию о каждом таком клиенте, включая его имя, электронную почту, телефон,
-- общее количество бронирований, а также список отелей, в которых они бронировали номера
-- (объединенные в одно поле через запятую с помощью CONCAT). Также подсчитать среднюю длительность их пребывания
-- (в днях) по всем бронированиям. Отсортировать результаты по количеству бронирований в порядке убывания.

SELECT c.name, c.email, c.phone,
       COUNT(b.id_booking) AS booking_count,
       STRING_AGG(DISTINCT h.name, ', ' ORDER BY h.name) AS hotels,
       AVG(b.check_out_date - b.check_in_date) AS avg_stay_duration
FROM customer c
JOIN booking b on b.id_customer = c.id_customer
JOIN room r on r.id_room = b.id_room
JOIN hotel h on r.id_hotel = h.id_hotel
GROUP BY c.id_customer
HAVING COUNT(DISTINCT h.id_hotel) > 1
AND COUNT(b.id_booking) > 2
ORDER BY booking_count DESC;
