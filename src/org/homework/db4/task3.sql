-- Найти всех сотрудников, которые занимают роль менеджера и имеют подчиненных (то есть число подчиненных больше 0).
-- Для каждого такого сотрудника вывести следующую информацию:
--
-- 1. EmployeeID: идентификатор сотрудника.
-- 2. Имя сотрудника.
-- 3. Идентификатор менеджера.
-- 4. Название отдела, к которому он принадлежит.
-- 5. Название роли, которую он занимает.
-- 6. Название проектов, к которым он относится (если есть, конкатенированные в одном столбце).
-- 7. Название задач, назначенных этому сотруднику (если есть, конкатенированные в одном столбце).
-- 8. Общее количество подчиненных у каждого сотрудника (включая их подчиненных).
-- 9. Если у сотрудника нет назначенных проектов или задач, отобразить NULL.

WITH manager_details AS (
    SELECT e.employeeid,
           e.name AS employeename,
           e.managerid,
           d.departmentname,
           r.rolename,
           STRING_AGG(DISTINCT p.projectname, ', ' ORDER BY p.projectname) AS projectnames,
           STRING_AGG(DISTINCT t.taskname, ', ' ORDER BY t.taskname) AS tasknames,
           (SELECT COUNT(*)
            FROM employees sub
            WHERE sub.managerid = e.managerid) AS total_subs
    FROM employees e
    JOIN roles r on e.roleid = r.roleid
    LEFT JOIN departments d on e.departmentid = d.departmentid
    LEFT JOIN tasks t on e.employeeid = t.assignedto
    LEFT JOIN projects p on d.departmentid = p.departmentid
    WHERE r.rolename = 'Менеджер'
    GROUP BY e.employeeid, e.name, e.managerid, d.departmentname, r.rolename
    HAVING (SELECT COUNT(*)
            FROM employees sub
            WHERE sub.managerid = e.employeeid) > 0
)
SELECT md.employeeid,
       md.employeename,
       md.managerid,
       md.departmentname,
       md.rolename,
       md.projectnames,
       md.tasknames,
       md.total_subs
FROM manager_details md
ORDER BY md.employeename ASC;
