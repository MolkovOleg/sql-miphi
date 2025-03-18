-- Найти всех сотрудников, подчиняющихся Ивану Иванову с EmployeeID = 1, включая их подчиненных и подчиненных подчиненных.
-- Для каждого сотрудника вывести следующую информацию:

-- 1. EmployeeID: идентификатор сотрудника.
-- 2. Имя сотрудника.
-- 3. Идентификатор менеджера.
-- 4. Название отдела, к которому он принадлежит.
-- 5. Название роли, которую он занимает.
-- 6. Название проектов, к которым он относится (если есть, конкатенированные в одном столбце).
-- 7. Название задач, назначенных этому сотруднику (если есть, конкатенированные в одном столбце).
-- 8. Общее количество задач, назначенных этому сотруднику.
-- 9. Общее количество подчиненных у каждого сотрудника (не включая подчиненных их подчиненных).
-- 10. Если у сотрудника нет назначенных проектов или задач, отобразить NULL.

WITH RECURSIVE employee_hierarchy AS (
    SELECT e.employeeid, e.name, e.managerid, e.departmentid, e.roleid
    FROM employees e
    WHERE e.managerid = 1

    UNION ALL

    SELECT e.employeeid, e.name, e.managerid, e.departmentid, e.roleid
    FROM employees e
             INNER JOIN employee_hierarchy eh ON e.managerid = eh.employeeid
),
               employee_details AS (
                   SELECT eh.employeeid, eh.name, eh.managerid, d.departmentname, r.rolename,
                          STRING_AGG(DISTINCT p.projectname, ', ') AS projects,
                          STRING_AGG(DISTINCT t.taskname, ', ') AS tasks,
                          COUNT(t.taskid) AS total_tasks,
                          COUNT(sub.employeeid) AS total_subordinates
                   FROM employee_hierarchy eh
                            LEFT JOIN departments d ON eh.departmentid = d.departmentid
                            LEFT JOIN roles r ON eh.roleid = r.roleid
                            LEFT JOIN tasks t ON eh.employeeid = t.assignedto
                            LEFT JOIN projects p ON t.projectid = p.projectid
                            LEFT JOIN employees sub ON sub.managerid = eh.managerid
                   GROUP BY eh.employeeid, eh.name, eh.managerid, d.departmentname, r.rolename
               )
SELECT ed.employeeid, ed.name, ed.managerid, ed.departmentname, ed.rolename,
       COALESCE(ed.projects, NULL) AS project_names,
       COALESCE(ed.tasks, NULL) AS task_names,
       ed.total_tasks,
       ed.total_subordinates
FROM employee_details ed
ORDER BY ed.name ASC;