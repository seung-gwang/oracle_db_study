--sum exclude null //scott
select sum(comm)
from emp; 

select count(*), count(salary), count(department_id), count(commission_pct) 
--107 107 106 35 .... * includes null, colName -> excludes
from employees;

select avg(salary) as AVG_USING_FUNC, sum(salary) / count(*) as MYCALC_AVG
from employees;

select count(distinct department_id) --excludes null
from employees;

select distinct department_id -- 12 department ids icluding (null)
from employees;

--�μ��� ���� �޿���Ȳ
select department_id, HIRE_DATE, sum(salary), count(*)
from employees
group by department_id, HIRE_DATE
order by 1;
--select���� ���� �� Į�� (�����Լ��� X) -> group by ���� �ݵ�� �־�� �Ѵ�.


select department_id, job_id, max(first_name), sum(salary), count(*)
from employees
group by department_id, job_id
order by 1;


--XX�� ���� -> roll up
select job_id, department_id,  max(first_name), sum(salary), count(*)
from employees
group by rollup(job_id, department_id)
order by 1;

--��� ���պ� ���� -> cube
select department_id, job_id, max(first_name), sum(salary), count(*)
from employees
group by cube(department_id, job_id);
--order by 1;



select *
from departments
where department_id in (50,80);

select job_id, count(*)
from employees
group by job_id;

select department_id, job_id, count(*)
from employees
group by cube(job_id, department_id)
order by 1
;

select department_id, job_id, count(*)
from employees
group by rollup(job_id, department_id)
order by 1
;



--groupby ���� -> having, groupby having �ۼ� ���� �ٲ� OK
select department_id, sum(salary)
from employees
where salary >= 100 --where �������� �����Լ� X
group by department_id
having sum(salary) >= 60000
;
--���� ���� from->where->group by->having->select->order by




--7. �μ��� �ο��� ��ȸ�ϵ� �ο��� 5�� �̻��� �μ� ���
select department_id, count(*)
from employees
group by department_id
having count(*) >= 5;

--8. �μ��� �ִ� �ּ� �޿� ��ȸ, �� �ִ� �޿��� �ּ� �޿��� ���� �μ��� ���� 
select department_id, max(salary), min(salary)
from employees
group by department_id
having max(salary) <> min(salary);

--9
select department_id, avg(salary) as salAvg
from employees
where department_id in(50,80,110) and salary between 5000 and 24000
group by department_id
having avg(salary)>=8000
order by salAvg desc;



-----------------------------------------------------------------------------------------------------------------
--ch.7 join
-----------------------------------------------------------------------------------------------------------------
desc employees;
desc departments;

--JOIN : �ߺ��� �����ϱ� ���� table�� �������� �ִµ�, �ٽ� ���� �����ϱ� ���� ������.
select first_name, employees.department_id
from employees, departments
where employees.department_id = departments.department_id; --ǥ���� �ƴ����� ���� ��� ������ �����ϴ� ������.

--���� column�̸����� join : ǥ�� ����
select first_name, department_id, departments.department_name --employees.department_id .... X
from employees join departments using(department_id);

--���� �ٸ� column�̸����� join -> ON ���
select first_name, employees.department_id, departments.department_name 
from employees join departments on(employees.department_id = departments.department_id);

select * from employees;

select * from jobs;

select emp.first_name, j.job_title, emp.job_id
from employees emp, jobs j
where emp.job_id = j.job_id;

select emp.first_name, j.job_title, emp.job_id
from employees emp join jobs j on (emp.job_id = j.job_id);

select emp.first_name, j.job_title, job_id
from employees emp join jobs j using (job_id);


select emp.first_name, j.job_title, emp.job_id, department_id
from employees emp, jobs j
where emp.job_id = j.job_id
and department_id > 80;

select emp.first_name, j.job_title, job_id
from employees emp join jobs j using (job_id)
where department_id >80;

-- �μ� -> ����(�μ���)
select departments.*, employees.first_name, employees.salary
from departments, employees
where departments.manager_id = employees.employee_id;

select departments.*, employees.first_name, employees.salary
from departments, employees
where departments.manager_id = employees.employee_id(+); 
--where departments.manager_id(+) = employees.employee_id(+);  ....X
--oracle ... managerId�� ���°ͱ��� ���, (+) ... '���� �ʿ�' ���Ĵ�
--������ ������ �ٸ����� ��ġ�� ���� ���� ��쿡 �ִ� �κи� ���


--equi join
select d.*, e.first_name, e.salary, e.employee_id
from departments d join employees e on (d.manager_id = e.employee_id);

--outter join
select d.*, e.first_name, e.salary, e.employee_id
from departments d left outer join employees e on (d.manager_id = e.employee_id);

select d.*, e.first_name, e.salary, e.employee_id
from departments d full outer join employees e on (d.manager_id = e.employee_id);
--(+) (+)


--���� �������� ������ �μ� ���� ��ȸ
select first_name, salary, department_name
from departments, employees
where departments.department_id(+) = employees.department_id; --not recommended


select first_name, salary, department_name
from departments right outer join employees using(department_id);

--SCOTT
--���忡�� �ٹ��ϴ� ��� �̸� ��ȸ
select ename 
from emp, dept
where emp.deptno = dept.deptno
and dept.loc = 'NEW YORK';

select *
from DEPT d join EMP e on (d.deptno = e.deptno)
where d.loc = 'NEW YORK';

--subquery
select *
from emp
where deptno = 
(select deptno
from dept
where loc = 'NEW YORK');

select ename, hiredate
from emp join dept on (emp.deptno = dept.deptno)
where dept.dname = 'ACCOUNTING';

--subquery
select ename, hiredate
from emp
where deptno = (
select deptno
from dept
where dname = 'ACCOUNTING'
);

--scott
select ename, dname
from emp join dept using(deptno)
where job = 'MANAGER';

select emp.*, salgrade.grade 
from emp join salgrade on (emp.sal between salgrade.losal and salgrade.hisal);


--SELF JOIN
select SELF.first_name as NAME, SUPER.first_name as MANAGER_NAME
from employees SELF join employees SUPER on(SELF.manager_id = SUPER.employee_id);


select * from emp;
select * from dept;

select *
from emp A join emp B on (A.MGR = B.EMPNO)
where B.ENAME = 'KING';


desc employees;






--1.�������� �̸��� ���޸�(job_title)�� ��ȸ�Ͻÿ�.

select first_name, job_title
from employees join jobs on (employees.job_id = jobs.job_id);




--2.�μ��̸��� �μ��� ���� ���ø�(city)�� ��ȸ�Ͻÿ�.
select department_name, city
from departments join locations on (departments.location_id = locations.location_id);



--3. ������ �̸��� �ٹ��������� ��ȸ�Ͻÿ�. (employees, departments, locations,countries)
select e.first_name, country_name
from employees e join departments d using(department_id)
join locations i using (location_id)
join countries c using (country_id);


 


--4. ��å(job_title)�� 'manager' �� ����� �̸�, ��å, �μ����� ��ȸ�Ͻÿ�.
 select first_name, job_title, department_name
 from employees e join departments d using(department_id)
 join jobs j using (job_id)
 where j.job_title like '%Manager';
 


--5. �������� �̸�, �Ի���, �μ����� ��ȸ�Ͻÿ�.
select first_name || ' ' || last_name as fullname, hire_date, department_name
from employees e join departments d using(department_id);


--6. �������� �̸�, �Ի���, �μ����� ��ȸ�Ͻÿ�.
--��, �μ��� ���� ������ �ִٸ� �� ���������� ��°���� ���Խ�Ų��.
select first_name || ' ' || last_name as fullname, hire_date, department_name
from employees e left outer join departments d using(department_id);


--7. ������ �̸��� ��å(job_title)�� ����Ͻÿ�.
--��, ������ �ʴ� ��å�� �ִٸ� �� ��å������ ��°���� ���Խ�Ű�ÿ�.
select first_name || ' ' || last_name as fullname, job_title
from employees e right outer join jobs j using(job_id);
--��å�� �ִµ� �� ��å�� ���� ������ ����
--(Name) JOB_TITLE
--NULL   ABCDEF


-- SELF JOIN
--1. ������ �̸��� ������ �̸��� ��ȸ�Ͻÿ�.
select * from employees;

select A.first_name as EMPLOYEE_NAME, B.first_name as MANGAGER_NAME
from employees A join employees B on (A.Manager_ID = B.EMPLOYEE_ID);
 

--�� �Ŵ��� �� ���� ���� ����>

2. ������ �̸��� ������ �̸��� ��ȸ�Ͻÿ�.
�����ڰ� ���� ���������� ��� ����Ͻÿ�.
select A.first_name as EMPLOYEE_NAME, B.first_name as MANGAGER_NAME
from employees A left join employees B on (A.Manager_ID = B.EMPLOYEE_ID);
  



3. ������ �̸��� �����ڰ� �����ϴ� ������ ���� ��ȸ�Ͻÿ�.
��, ������������ 3�� �̻��� �����ڸ� ��µǵ��� �Ͻÿ�.
select B.first_name || ' ' || B.last_name as MANAGER_FULL_NAME, count(*)
from employees A join employees B on (A.Manager_ID = B.Employee_id)
group by B.first_name || ' ' || B.last_name
having count(*) >= 3;
 

select deptno
from emp
where deptno = (
select deptno from emp
where ename = 'KING'
);

select *
from emp
where job = (
    select job from emp
    where ename = 'KING'
);

select deptno from emp
where ename = 'KING'

select *
from emp
where deptno = (
select deptno from dept
where loc = 'DALLAS'
);

select * from emp;

select e.ename, e.sal
from emp e join emp m on (e.mgr = m.empno)
where m.ename = 'KING';


select avg(salary)
from employees; --6164.XXX

select *
from employees
where salary > (
    select avg(salary)
    from employees
);

--�����߿� �޿��� 10000 �̻��� �޿��� �޴� �μ��� ���ϴ� �������� ��ȸ
select distinct department_id
from employees
where salary > 10000;

select *
from employees
where department_id in (
    select distinct department_id
    from employees
    where salary > 13000
);

--60�μ��� ��� �������� �޿����� �� ���� �޿��� �޴� ���� ��ȸ
select first_name
from employees
where salary > ALL (
    select salary
    from employees
    where department_id = 60
);


--========================================
		--SubQuery
--========================================
--1. 'IT'�μ����� �ٹ��ϴ� �������� �̸�, �޿�, �Ի����� ��ȸ�Ͻÿ�.
select first_name || ' ' || last_name as fullName, salary, hire_date
from employees e join departments d on (e.department_id = d.department_id)
where d.department_name = 'IT';



--2. 'Alexander' �� ���� �μ����� �ٹ��ϴ� ������ �̸��� �μ�id�� ��ȸ�Ͻÿ�.
select e.first_name || ' ' || e.last_name as fullName, e.department_id
from employees e join departments d on (e.department_id = d.department_id)
where d.department_id = any (select department_id from employees where employees.first_name = 'Alexander');



--3. 80���μ��� ��ձ޿����� ���� �޿��� �޴� ������ �̸�, �μ�id, �޿��� ��ȸ�Ͻÿ�.
select e.first_name, d.department_id, e.salary
from employees e join departments d on (e.department_id = d.department_id) 
where e.salary > (
    select avg(salary)
    from employees e join departments d on (e.department_id = d.department_id)
    where e.department_id = 80
);






select avg(salary)
from departments
where department_id = 80;




4. 'South San Francisco'�� �ٹ��ϴ� ������ �ּұ޿����� �޿��� ���� �����鼭 
50 ���μ��� ��ձ޿����� ���� �޿��� �޴� ������ �̸�, �޿�, �μ���, 
�μ�id�� ��ȸ�Ͻÿ�.

select first_name
from employees
where salary > (select avg(salary) from employees where department_id = 50)
and salary > (
    select min(salary) from employees
    where department_id = (
        select department_id
        from departments
        where location_id = (
            select location_id
            from locations
            where city = 'South San Francisco'
        )
    )
);

--4. ANS 1
select  first_name, salary, department_name, department_id
from employees join  departments using(department_id)
where salary > (select avg(salary) from employees where department_id = 50)
and salary > (
            select min(salary) from employees
            where department_id = (
                                    select department_id
                                    from departments
                                    where location_id = (
                                                            select  location_id
                                                            from locations
                                                            where city = 'South San Francisco')
                                )
          );

--4. ANS2
/*
4. 'South San Francisco'�� �ٹ��ϴ� ������ �ּұ޿����� �޿��� ���� �����鼭 
50 ���μ��� ��ձ޿����� ���� �޿��� �޴� ������ �̸�, �޿�, �μ���, 
�μ�id�� ��ȸ�Ͻÿ�.
*/
select  first_name, salary, department_name, department_id
from employees join  departments using(department_id)
where salary > (select avg(salary) from employees where department_id = 50)
and salary > (select min(salary)
              from departments join locations using(location_id)
              join employees using(department_id)
              where city = 'South San Francisco'
);          


select first_name
from employees
where salary > (select avg(salary) from employees where department_id = 50)
and salary > (
    select min(salary) from employees
    where department_id = (
        select department_id
        from departments
        where location_id = (
            select location_id
            from departments join locations using(location_id)
            where city = 'South San Francisco'
        )
    )
);







select * from employees
where department_id = (
select department_id
from departments
where location_id = (
select location_id
from locations
where city = 'South San Francisco')
);








-------------------scott/tiger (emp, dept)

1. BLAKE�� ������ �μ��� ���� ��� ����� �̸��� �Ի����� ǥ���ϴ� ���Ǹ� �ۼ��Ͻÿ�.
������� BLAKE�� ���ܽ�ŵ�ϴ�.

 


2. �μ��� ��ġ�� DALLAS�� ��� ����� �̸�, �μ���ȣ , ������ ǥ���Ͻÿ� 





3. KING���� �����ϴ� ��� ����� �̸��� �޿��� ǥ���ϴ� ���Ǹ� �ۼ��Ͻÿ� 

 














 




















