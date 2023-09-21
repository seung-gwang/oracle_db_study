--DBMS 서비스 시작? -> 제어판 확인
--DBMS Listener 확인
--툴에서(Client에서) DB 접속
--Client에서 요청 보냄 -> DB 응답

--sql문 보내기 -> sql문 파싱, 구문분석, table이름, 칼럼 이름들은 DD(data dictionary)에서 확인.
-- -> 이상을 확인하고 실행
select *
from employees
where salary >= 10000
and hire_date >= '2006-01-01'
order by SALARY desc;


--select 10+20; --error
select 10+20
from dual; -- ->1건만 나옴.

select * from dual; --dual : sys, -> sys가 모든 계정에 public으로 공개함.
--dual은 칼럼 하나, 한 건이 들어가 있음.

select ceil(3.14) 올림, floor(3.9) 버림, round(6.45595454884, 3) 반올림 --round(val, [place]) ... place+1에서 반올림
, round(146.555555, -2) 반올림2 -- -1: 1의 자리에서 반올림
from dual;


select email, lower(email), upper(first_name), initcap('hi hello goodbye')
from employees;

select *
from jobs;

select *
from employees
where job_id = 'IT_PROG'; --upper(...)

--union
select *
from employees
where department_id in (60,80);
--union
--select *
--from employees
--where department_id = 80;

--부서 정보 (부서 번호, 부서 이름), 직원 정보(직원 번호, 직원 이름) -> 하나로 뽑아달라~
--UNION : SELECT의 개수, 타입이 같아야 함.
SELECT DISTINCT '부서' AS AA, DEPARTMENT_ID AS DID, DEPARTMENT_NAME AS DN, -1 AS SALORMINUS1
FROM DEPARTMENTS
UNION
SELECT DISTINCT '직원' AS BB, EMPLOYEE_ID AS EI, FIRST_NAME AS FN, SALARY
FROM EMPLOYEES;

SELECT FIRST_NAME, length(FIRST_NAME), length('오라클'), lengthb('오라클') --utf8 : 9BYTES
from EMPLOYEES;



--substr
select first_name, substr(first_name, 1, 3), substr(first_name, -1, 3)
from employees;
select job_title,  MIN_SALARY, MAX_SALARY
from jobs
where substr(job_title, -7,7) = 'Manager';


select first_name, salary, hire_date
from employees
where substr(first_name, -1, 1) = 'm'; --vs LIKE '%m'
--first_name이 인덱싱 처리 되었다면 substr호출시 이 인덱스가 사라짐 -> 비효율적



select first_name, instr(first_name, 'a', 2, 2) --start idx, 
, lpad(first_name, 10, '%')
from employees;



--trim
select ltrim('             oracle'), rtrim('oracle               '), '*'||trim('                  asdf              ')||'*',
trim('A' from 'AAAAAAAAAAAAAAAAAAAAAAAAAAAoracleAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA')
from dual;

--입사 한 연수 
select  first_Name, to_char(sysdate,'yy') - to_char(hire_date,'yy')
from employees;

--날짜 함수
select first_name, sysdate, hire_date, floor(months_between(sysdate , hire_date)/ 12) 입사일수
from employees;

select first_name, hire_date, round(hire_date, 'MONTH') 월반올림 --'일' 에서 반올림 : [1~15] [16~]
from employees;

select first_name, hire_date, round(hire_date, 'YEAR') 연반올림 --'월'에서 반올림 [1-6] [7-12]
from employees;

select add_months(hire_date, 6) "6개월후"
from employees;

select to_date('2024-02-28') - sysdate
from dual;


select sysdate, sysdate+1, next_day(sysdate, '수요일'), last_day(sysdate)
from dual;

select sysdate, to_char(sysdate, 'yyyy/MON/dd hh24/mi:ss AM DAY DY'),
to_date('2023-09-20','yyyy-mm-dd') + 1 "문자->날짜"
from dual;


--nls params
select * from v$nls_parameters;

select first_name, salary, to_char(salary, '999,999,999')
from employees;



select first_name, salary, commission_pct, salary + nvl2(commission_pct,commission_pct*500, 0)
from employees
order by commission_pct nulls first;



--coalesce
select first_name, salary, commission_pct,
coalesce(commission_pct, manager_id, department_id) "null아닌최초칼럼값"
from employees
order by commission_pct nulls first;



--decode
select manager_id, decode(manager_id, 100, '스티븐',102, '니나', 103, '렉스', '기타') "decode example"
from employees;


select manager_id, job_id, salary, decode(job_id, 'IT_PROG', salary * 1.1, 'FI_ACCOUNT', salary * 1.2, salary * 1.05) "NEW SALARY"
from employees;



select manager_id, decode(manager_id, 100, '스티븐',102, '니나', 103, '렉스', '기타') "decode example",
    case when manager_id=100 then '스티븐'
    when manager_id=102 then '니나'
    when manager_id=103 then '렉스'
    else '기타' end "whenthen"
    
    case when salary > 15000 then 'A'
        when salary between 10000 and 15000 then 'B'
        when salary >= 5000 and salary < 10000 then 'C' esle 'D' end "case2"
from employees;








