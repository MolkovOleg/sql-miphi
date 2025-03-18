-- Вам необходимо провести анализ данных о бронированиях в отелях и определить предпочтения клиентов по типу отелей.
-- Для этого выполните следующие шаги:

--- 1. Категоризация отелей. Определите категорию каждого отеля на основе средней стоимости номера:

--- «Дешевый»: средняя стоимость менее 175 долларов.
--- «Средний»: средняя стоимость от 175 до 300 долларов.
--- «Дорогой»: средняя стоимость более 300 долларов.
--------------------------------------------------------------------------------------------------------------------
--- 2. Анализ предпочтений клиентов. Для каждого клиента определите предпочитаемый тип отеля на основании условия ниже:

--- Если у клиента есть хотя бы один «дорогой» отель, присвойте ему категорию «дорогой».
--- Если у клиента нет «дорогих» отелей, но есть хотя бы один «средний», присвойте ему категорию «средний».
--- Если у клиента нет «дорогих» и «средних» отелей, но есть «дешевые», присвойте ему категорию предпочитаемых отелей «дешевый».
--------------------------------------------------------------------------------------------------------------------
--- 3. Вывод информации. Выведите для каждого клиента следующую информацию:

--- ID_customer: уникальный идентификатор клиента.
--- name: имя клиента.
--- preferred_hotel_type: предпочитаемый тип отеля.
--- visited_hotels: список уникальных отелей, которые посетил клиент.
--------------------------------------------------------------------------------------------------------------------
--- 4. Сортировка результатов. Отсортируйте клиентов так, чтобы сначала шли клиенты с «дешевыми» отелями,
--- затем со «средними» и в конце — с «дорогими».

WITH hotel_avg_prices AS (
    SELECT h.id_hotel, h.name AS hotel_name,
           AVG(r.price) AS avg_room_price
    FROM hotel h
    JOIN room r on r.id_hotel = h.id_hotel
    GROUP BY h.id_hotel, h.name
),
    hotel_categories AS (
        SELECT hap.id_hotel, hap.hotel_name,
            CASE
                WHEN hap.avg_room_price < 175 THEN 'Дешевый'
                WHEN hap.avg_room_price BETWEEN 175 AND 300 THEN 'Средний'
                ELSE 'Дорогой'
            END AS category
        FROM hotel_avg_prices hap
    ),

    customer_visited_hotels AS (
        SELECT c.id_customer, c.name, h.id_hotel, hc.hotel_name, hc.category
        FROM customer c
        JOIN booking b on c.id_customer = b.id_customer
        JOIN room r on b.id_room = r.id_room
        JOIN hotel h on r.id_hotel = h.id_hotel
        JOIN hotel_categories hc on h.id_hotel = hc.id_hotel
    ),

    customer_prefered AS (
        SELECT cvh.id_customer, cvh.name,
            CASE
                WHEN MAX(CASE WHEN cvh.category = 'Дорогой' THEN 1 ELSE 0 END) = 1 THEN 'Дорогой'
                WHEN MAX(CASE WHEN cvh.category = 'Средний' THEN 1 ELSE 0 END) = 1 THEN 'Средний'
                ELSE 'Дешевый'
            END AS prefered_hotel_type,
            STRING_AGG(DISTINCT cvh.hotel_name, ', ') AS visited_hotels,
            CASE
                WHEN MAX(CASE WHEN cvh.category = 'Дорогой' THEN 1 ELSE 0 END) = 1 THEN 3
                WHEN MAX(CASE WHEN cvh.category = 'Средний' THEN 1 ELSE 0 END) = 1 THEN 2
                ELSE 1
            END AS sort_order
        FROM customer_visited_hotels cvh
        GROUP BY cvh.id_customer, cvh.name
    )
SELECT cp.id_customer, cp.name, cp.prefered_hotel_type, cp.visited_hotels
FROM customer_prefered cp
ORDER BY cp.sort_order ASC, cp.name ASC;
