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

--부서별 직원 급여현황
select department_id, HIRE_DATE, sum(salary), count(*)
from employees
group by department_id, HIRE_DATE
order by 1;
--select절에 참여 한 칼럼 (집계함수는 X) -> group by 절에 반드시 있어야 한다.


select department_id, job_id, max(first_name), sum(salary), count(*)
from employees
group by department_id, job_id
order by 1;


--XX별 집계 -> roll up
select job_id, department_id,  max(first_name), sum(salary), count(*)
from employees
group by rollup(job_id, department_id)
order by 1;

--모든 조합별 집계 -> cube
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



--groupby 조건 -> having, groupby having 작성 순서 바뀌어도 OK
select department_id, sum(salary)
from employees
where salary >= 100 --where 절에서는 집계함수 X
group by department_id
having sum(salary) >= 60000
;
--실행 순서 from->where->group by->having->select->order by




--7. 부서별 인원수 조회하되 인원수 5명 이상인 부서 출력
select department_id, count(*)
from employees
group by department_id
having count(*) >= 5;

--8. 부서별 최대 최소 급여 조회, 단 최대 급여와 최소 급여가 같은 부서는 제외 
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

--JOIN : 중복을 배제하기 위해 table이 나누어져 있는데, 다시 값을 참조하기 위해 연결함.
select first_name, employees.department_id
from employees, departments
where employees.department_id = departments.department_id; --표준은 아니지만 거의 모든 벤더가 지원하는 문법임.

--같은 column이름으로 join : 표준 문법
select first_name, department_id, departments.department_name --employees.department_id .... X
from employees join departments using(department_id);

--서로 다른 column이름으로 join -> ON 사용
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

-- 부서 -> 직원(부서장)
select departments.*, employees.first_name, employees.salary
from departments, employees
where departments.manager_id = employees.employee_id;

select departments.*, employees.first_name, employees.salary
from departments, employees
where departments.manager_id = employees.employee_id(+); 
--where departments.manager_id(+) = employees.employee_id(+);  ....X
--oracle ... managerId가 없는것까지 출력, (+) ... '없는 쪽에' 보탠다
--한쪽은 있지만 다른쪽은 일치한 것이 없는 경우에 있는 부분만 출력


--equi join
select d.*, e.first_name, e.salary, e.employee_id
from departments d join employees e on (d.manager_id = e.employee_id);

--outter join
select d.*, e.first_name, e.salary, e.employee_id
from departments d left outer join employees e on (d.manager_id = e.employee_id);

select d.*, e.first_name, e.salary, e.employee_id
from departments d full outer join employees e on (d.manager_id = e.employee_id);
--(+) (+)


--직원 기준으로 직원의 부서 정보 조회
select first_name, salary, department_name
from departments, employees
where departments.department_id(+) = employees.department_id; --not recommended


select first_name, salary, department_name
from departments right outer join employees using(department_id);

--SCOTT
--뉴욕에서 근무하는 사원 이름 조회
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






--1.직원들의 이름과 직급명(job_title)을 조회하시오.

select first_name, job_title
from employees join jobs on (employees.job_id = jobs.job_id);




--2.부서이름과 부서가 속한 도시명(city)을 조회하시오.
select department_name, city
from departments join locations on (departments.location_id = locations.location_id);



--3. 직원의 이름과 근무국가명을 조회하시오. (employees, departments, locations,countries)
select e.first_name, country_name
from employees e join departments d using(department_id)
join locations i using (location_id)
join countries c using (country_id);


 


--4. 직책(job_title)이 'manager' 인 사람의 이름, 직책, 부서명을 조회하시오.
 select first_name, job_title, department_name
 from employees e join departments d using(department_id)
 join jobs j using (job_id)
 where j.job_title like '%Manager';
 


--5. 직원들의 이름, 입사일, 부서명을 조회하시오.
select first_name || ' ' || last_name as fullname, hire_date, department_name
from employees e join departments d using(department_id);


--6. 직원들의 이름, 입사일, 부서명을 조회하시오.
--단, 부서가 없는 직원이 있다면 그 직원정보도 출력결과에 포함시킨다.
select first_name || ' ' || last_name as fullname, hire_date, department_name
from employees e left outer join departments d using(department_id);


--7. 직원의 이름과 직책(job_title)을 출력하시오.
--단, 사용되지 않는 직책이 있다면 그 직책정보도 출력결과에 포함시키시오.
select first_name || ' ' || last_name as fullname, job_title
from employees e right outer join jobs j using(job_id);
--직책은 있는데 그 직책을 가진 직원이 없음
--(Name) JOB_TITLE
--NULL   ABCDEF


-- SELF JOIN
--1. 직원의 이름과 관리자 이름을 조회하시오.
select * from employees;

select A.first_name as EMPLOYEE_NAME, B.first_name as MANGAGER_NAME
from employees A join employees B on (A.Manager_ID = B.EMPLOYEE_ID);
 

--각 매니저 당 부하 직원 수는>

2. 직원의 이름과 관리자 이름을 조회하시오.
관리자가 없는 직원정보도 모두 출력하시오.
select A.first_name as EMPLOYEE_NAME, B.first_name as MANGAGER_NAME
from employees A left join employees B on (A.Manager_ID = B.EMPLOYEE_ID);
  



3. 관리자 이름과 관리자가 관리하는 직원의 수를 조회하시오.
단, 관리직원수가 3명 이상인 관리자만 출력되도록 하시오.
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

--직원중에 급여가 10000 이상의 급여를 받는 부서에 속하는 직원들을 조회
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

--60부서의 모든 직원들의 급여보다 더 많은 급여를 받는 직원 조회
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
--1. 'IT'부서에서 근무하는 직원들의 이름, 급여, 입사일을 조회하시오.
select first_name || ' ' || last_name as fullName, salary, hire_date
from employees e join departments d on (e.department_id = d.department_id)
where d.department_name = 'IT';



--2. 'Alexander' 와 같은 부서에서 근무하는 직원의 이름과 부서id를 조회하시오.
select e.first_name || ' ' || e.last_name as fullName, e.department_id
from employees e join departments d on (e.department_id = d.department_id)
where d.department_id = any (select department_id from employees where employees.first_name = 'Alexander');



--3. 80번부서의 평균급여보다 많은 급여를 받는 직원의 이름, 부서id, 급여를 조회하시오.
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




4. 'South San Francisco'에 근무하는 직원의 최소급여보다 급여를 많이 받으면서 
50 번부서의 평균급여보다 많은 급여를 받는 직원의 이름, 급여, 부서명, 
부서id를 조회하시오.

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
4. 'South San Francisco'에 근무하는 직원의 최소급여보다 급여를 많이 받으면서 
50 번부서의 평균급여보다 많은 급여를 받는 직원의 이름, 급여, 부서명, 
부서id를 조회하시오.
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

1. BLAKE와 동일한 부서에 속한 모든 사원의 이름및 입사일을 표시하는 질의를 작성하시오.
결과에서 BLAKE는 제외시킵니다.

 


2. 부서의 위치가 DALLAS인 모든 사원의 이름, 부서번호 , 직무를 표시하시오 





3. KING에게 보고하는 모든 사원의 이름과 급여를 표시하는 질의를 작성하시오 

 














 




















