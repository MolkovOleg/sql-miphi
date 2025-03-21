# SQL Homework

## Описание проекта

Проект "SQL Homework" представляет собой набор SQL-скриптов для создания, заполнения и анализа данных в четырех независимых базах данных (`db1`, `db2`, `db3`, `db4`). Каждая база данных содержит таблицы, их данные и запросы для решения конкретных задач, разработанных в рамках домашних заданий. Все запросы написаны и протестированы в СУБД PostgreSQL. Результаты выполнения запросов сохранены в формате `.csv` для удобства проверки и анализа.

### Цели и задачи
- **Цель**: Организовать решения SQL-заданий в структурированном виде с использованием PostgreSQL.
- **Задачи**:
  - Создать структуру базы данных для каждой из четырех тем (транспорт, гонки, резервирование отелей, организация).
  - Разработать SQL-запросы для анализа данных.
  - Сохранить результаты выполнения запросов в формате `.csv`.

---

## Структура проекта

Проект разделен на четыре пакета, каждый из которых соответствует отдельной базе данных. В каждом пакете находятся SQL-файлы для создания таблиц, их заполнения, выполнения заданий и результаты запросов в формате `.csv`.

### Описание пакетов
1. **db1**: База данных транспортных средств (автомобили, мотоциклы, велосипеды).
   - Количество заданий: 2.
   - Таблицы: `Vehicle`, `Car`, `Motorcycle`, `Bicycle`.

2. **db2**: База данных гонок и автомобилей.
   - Количество заданий: 5.
   - Таблицы: `Classes`, `Cars`, `Races`, `Results`.

3. **db3**: База данных отелей и бронирований.
   - Количество заданий: 3.
   - Таблицы: `Hotel`, `Room`, `Customer`, `Booking`.

4. **db4**: База данных сотрудников и проектов.
   - Количество заданий: 2.
   - Таблицы: `Departments`, `Roles`, `Employees`, `Projects`, `Tasks`.

---

### Структура файлов
- **`create.sql`**: SQL-скрипт для создания таблиц с учетом всех связей (первичные и внешние ключи).
- **`data.sql`**: SQL-скрипт для заполнения таблиц тестовыми данными.
- **`taskN.sql`**: SQL-запрос для решения конкретной задачи (N — номер задачи).
- **`result_taskN.csv`**: Результат выполнения запроса `taskN.sql` в формате CSV.
- ---

## Реализованные функции

Все запросы разработаны и протестированы в PostgreSQL. Они включают:
- **Фильтрацию данных**: Условия `WHERE`, `CHECK`, `HAVING`.
- **Объединение таблиц**: `JOIN`, `UNION ALL`.
- **Агрегацию**: `COUNT`, `AVG`, `SUM`, `STRING_AGG`.
- **Рекурсию**: Использование `WITH RECURSIVE` для анализа иерархий (например, подчиненные сотрудников).
- **Сортировку**: `ORDER BY` с учетом различных критериев.

Подробное описание задач см. в каждом пакете в соответствующих файлах `taskN.sql`.

---

## Требования

- **СУБД**: PostgreSQL (версия 9.5 или выше) для поддержки функций `STRING_AGG`, `RECURSIVE` и других возможностей.
- Установленный клиент PostgreSQL (например, `psql` или pgAdmin).
