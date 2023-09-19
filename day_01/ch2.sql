--select * from employees;

select to_char(hire_date,'yyyy/mm/dd hh:mm:ss') from employees;

desc employees;

--��� Į�� : *
select *
from employees;

--Ư�� Į����
--column as  "..." : alias Į�� �̸�, ���̺� ���...(�ĺ���) , "" �� �״�� �򰡵�
-- ''�� ���� ���

select employee_id as ���̵�, first_name as �̸�, last_name as ��, salary, hire_date as "�Ի��� ��¥" 
from employees
where first_name = 'Steven'; --FROM -> WHERE -> SELECT
--from "EMPLOYEES"; -- OK
--from "employees" --X
--data ������ �ڵ����� ���� �빮�ڷ� ����

--SQL �� : parse -> ���� �м� -> ����

select distinct first_name --�ߺ�����
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


--null "Ȯ���� ���� ���ٴ� ��"
--���� ������ -> null + ? -> null


select first_name, salary, commission_pct, salary + salary *nvl(commission_pct,0) �޿�, nvl(to_char(department_id) ,'�μ� ����')
from employees;

--strcat  == ||
select first_name, salary, commission_pct, salary+salary*nvl(commission_pct,0) �޿�, nvl(to_char(department_id), '�μ� ����')
from employees;

select first_name, last_name, first_name || ' ' || last_name
from employees;


