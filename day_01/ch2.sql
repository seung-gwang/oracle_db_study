--select * from employees;

select to_char(hire_date,'yyyy/mm/dd hh:mm:ss') from employees;

desc employees;

--모든 칼럼 : *
select *
from employees;

--특정 칼럼들
--column as  "..." : alias 칼럼 이름, 테이블에 사용...(식별자) , "" 값 그대로 평가됨
-- ''는 값에 사용

select employee_id as 아이디, first_name as 이름, last_name as 성, salary, hire_date as "입사한 날짜" 
from employees
where first_name = 'Steven'; --FROM -> WHERE -> SELECT
--from "EMPLOYEES"; -- OK
--from "employees" --X
--data 사전에 자동으로 값을 대문자로 넣음

--SQL 문 : parse -> 구문 분석 -> 실행

select distinct first_name --중복제거
from employees;

select distinct department_id
from employees;

select first_name, department_id, salary, salary * 12 
from employees;

select 10+20, sysdate
from dual;

desc dual;
select * from dual; --DUMMY

Select *
from employees;

--select * from departments;


--null "확정된 값이 없다는 뜻"
--연산 참여시 -> null + ? -> null


select first_name, salary, commission_pct, salary + salary *nvl(commission_pct,0) 급여, nvl(to_char(department_id) ,'부서 없음')
from employees;

--strcat  == ||
select first_name, salary, commission_pct, salary+salary*nvl(commission_pct,0) 급여, nvl(to_char(department_id), '부서 없음')
from employees;

select first_name, last_name, first_name || ' ' || last_name
from employees;


