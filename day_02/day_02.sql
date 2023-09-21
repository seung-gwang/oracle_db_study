--DBMS ���� ����? -> ������ Ȯ��
--DBMS Listener Ȯ��
--������(Client����) DB ����
--Client���� ��û ���� -> DB ����

--sql�� ������ -> sql�� �Ľ�, �����м�, table�̸�, Į�� �̸����� DD(data dictionary)���� Ȯ��.
-- -> �̻��� Ȯ���ϰ� ����
select *
from employees
where salary >= 10000
and hire_date >= '2006-01-01'
order by SALARY desc;


--select 10+20; --error
select 10+20
from dual; -- ->1�Ǹ� ����.

select * from dual; --dual : sys, -> sys�� ��� ������ public���� ������.
--dual�� Į�� �ϳ�, �� ���� �� ����.

select ceil(3.14) �ø�, floor(3.9) ����, round(6.45595454884, 3) �ݿø� --round(val, [place]) ... place+1���� �ݿø�
, round(146.555555, -2) �ݿø�2 -- -1: 1�� �ڸ����� �ݿø�
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

--�μ� ���� (�μ� ��ȣ, �μ� �̸�), ���� ����(���� ��ȣ, ���� �̸�) -> �ϳ��� �̾ƴ޶�~
--UNION : SELECT�� ����, Ÿ���� ���ƾ� ��.
SELECT DISTINCT '�μ�' AS AA, DEPARTMENT_ID AS DID, DEPARTMENT_NAME AS DN, -1 AS SALORMINUS1
FROM DEPARTMENTS
UNION
SELECT DISTINCT '����' AS BB, EMPLOYEE_ID AS EI, FIRST_NAME AS FN, SALARY
FROM EMPLOYEES;

SELECT FIRST_NAME, length(FIRST_NAME), length('����Ŭ'), lengthb('����Ŭ') --utf8 : 9BYTES
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
--first_name�� �ε��� ó�� �Ǿ��ٸ� substrȣ��� �� �ε����� ����� -> ��ȿ����



select first_name, instr(first_name, 'a', 2, 2) --start idx, 
, lpad(first_name, 10, '%')
from employees;



--trim
select ltrim('             oracle'), rtrim('oracle               '), '*'||trim('                  asdf              ')||'*',
trim('A' from 'AAAAAAAAAAAAAAAAAAAAAAAAAAAoracleAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA')
from dual;

--�Ի� �� ���� 
select  first_Name, to_char(sysdate,'yy') - to_char(hire_date,'yy')
from employees;

--��¥ �Լ�
select first_name, sysdate, hire_date, floor(months_between(sysdate , hire_date)/ 12) �Ի��ϼ�
from employees;

select first_name, hire_date, round(hire_date, 'MONTH') ���ݿø� --'��' ���� �ݿø� : [1~15] [16~]
from employees;

select first_name, hire_date, round(hire_date, 'YEAR') ���ݿø� --'��'���� �ݿø� [1-6] [7-12]
from employees;

select add_months(hire_date, 6) "6������"
from employees;

select to_date('2024-02-28') - sysdate
from dual;


select sysdate, sysdate+1, next_day(sysdate, '������'), last_day(sysdate)
from dual;

select sysdate, to_char(sysdate, 'yyyy/MON/dd hh24/mi:ss AM DAY DY'),
to_date('2023-09-20','yyyy-mm-dd') + 1 "����->��¥"
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
coalesce(commission_pct, manager_id, department_id) "null�ƴ�����Į����"
from employees
order by commission_pct nulls first;



--decode
select manager_id, decode(manager_id, 100, '��Ƽ��',102, '�ϳ�', 103, '����', '��Ÿ') "decode example"
from employees;


select manager_id, job_id, salary, decode(job_id, 'IT_PROG', salary * 1.1, 'FI_ACCOUNT', salary * 1.2, salary * 1.05) "NEW SALARY"
from employees;



select manager_id, decode(manager_id, 100, '��Ƽ��',102, '�ϳ�', 103, '����', '��Ÿ') "decode example",
    case when manager_id=100 then '��Ƽ��'
    when manager_id=102 then '�ϳ�'
    when manager_id=103 then '����'
    else '��Ÿ' end "whenthen"
    
    case when salary > 15000 then 'A'
        when salary between 10000 and 15000 then 'B'
        when salary >= 5000 and salary < 10000 then 'C' esle 'D' end "case2"
from employees;








