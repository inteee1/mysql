use sqldb;
-- 열 이름   테이블
select * from usertbl;
select * from buytbl;

-- 
select userid, name, birthYear from usertbl where birthyear >= 1970 and height > 170;
select name, addr from usertbl where addr IN('경남', '전남', '경북');
 -- 서브 쿼리의 결과가 하나일 떄
select * from usertbl where height > ( select height from usertbl where name='김경호');

--  서브 쿼리의 결과가 여러개일때
--  ANY: 173보다 크거나 170보다 크거나 모두 출력(some)
select * from usertbl where height > any( select height from usertbl where addr='경남');
select * from usertbl where height > some( select height from usertbl where addr='경남');

-- ALL : 173보다 크고 170보다 큰 사람을 모두 출력(AND)
select * from usertbl where height > ALL (  select height from usertbl where addr='경남');

select * from usertbl where height in(select height from usertbl where addr='경남');


 -- 정렬(order by) : 원하는 순서대로 정렬하여 출력
select name, mDate from usertbl order by mDate ASC; --  오름차순(기본), ASC는 생략 가능
select name, mDate from usertbl order by mDate DESC; -- 내림차순
select name, height from usertbl order by height, name;
-- 실습 3, 입사일자가 빠른 사람 10명을 출력하시오. 
SELECT * FROM employees.employees;
use employees; 
select * from employees order by hire_date ASC, emp_no ASC limit 10;
select * from employees where hire_date >= '1990-01-01' order by hire_date ASC, emp_no ASC limit 100;
desc employees.employees; 

-- distinct : 중복된것은 하나만 남김 
select distinct addr from usertbl ORDER BY addr;

-- limit : 출력의 개수를 제한
select emp_no, hire_date from employees.employees order by hire_date asc limit 0,5;  
-- limit 5 offset 0과 동일
 
 -- 테이블 생성과 복사
 use sqldb;
 create table buytbl2 (select * from buytbl);
 -- 실습 4: 휴대폰 사용하는 사람중 019와 018 쓰는 사람 출력
 select * from usertbl where mobile1 = 019 or mobile1 = 018;
select * from usertbl where mobile1 = 019 
union
select * from usertbl where mobile1 =  018;
select mobile1 from usertbl where mobile1 = 011 
union all
select mobile1 from usertbl where mobile1 =  018;
select 
	userid as '사용자 아이디', 
    sum(amount) as '총 구매 개수', 
    sum(amount*price) as '총 구매액' 
from buytbl 
GROUP BY userid;
select userid, sum(amount), sum(prodname) from buytbl GROUP BY userid;
select prodName, sum(amount) from buytbl GROUP BY prodName;

-- 실습 5: 제품별 판매 개수를 출력하시오.
select prodName, sum(amount), sum(price) from buytbl GROUP BY prodName;
select userid as '사용자 아이디', avg(amount) as '평균 구매 개수' from buytbl GROUP BY userID;
use usertbl;
select name, max(height), min(height) from usertbl group by ;
select name, height from usertbl 
where height = (select max(height) from usertbl) or height = (select min(height) from usertbl);
-- 실습 6 구매 가장 많이 한사람, 가장 적게 한사람 
select userid, amount from buytbl where amount = (select max(amount) from buytbl) or amount = (select min(amount) from buytbl);

SELECT 
    userid, sumamount
FROM
    (SELECT 
        userid, SUM(amount) AS 'sumamount'
    FROM
        buytbl
    GROUP BY userid) tempTBL
WHERE
    sumamount = (SELECT 
            MAX(sumamount)
        FROM
            (SELECT 
                userid, SUM(amount) AS 'sumamount'
            FROM
                buytbl
            GROUP BY userid) tempTBL)
        OR 
			sumamount = (SELECT 
            MIN(sumamount)
        FROM
            (SELECT 
                userid, SUM(amount) AS 'sumamount'
            FROM
                buytbl
            GROUP BY userid) tempTBL);
-- 테이블의 행의 수 
select count(*) From usertbl;
-- 휴대폰 사용자의 수 
select count(mobile1) From usertbl;
select count(DISTINCT mobile1) From usertbl;

-- having 절: 
select 
	userid as '사용자 아이디', 
    sum(amount*price) as '총 구매액' 
from buytbl 
GROUP BY userid;

select 
	userid as '사용자 아이디', 
    sum(amount*price) as '총 구매액'
from buytbl 
group by userid
having sum(amount*price) > 1000
order by sum(amount*price);

select num, groupName, sum(price*amount) as '비용' 
from buytbl
GROUP BY groupName, num
with rollup;

 -- -------------------------------- 데이터 변경을 위한 sql 문-----------------
 use sqldb;
 create table testTBL1( id int, userName char(3), age int);
 INSERT INTO testTBL1 VALUES(1, '홍길동', 25);
 SELECT * FROM testtbl1;
 INSERT INTO testTBL1(id, userName) VALUE(2, '설현');
 SELECT * FROM testtbl1;
 INSERT INTO testTBL1(id, age) VALUE(3, 34);
 INSERT INTO testTBL1(userName, age, id) VALUE('하니', 26, 4);
 
  create table testTBL2( id int AUTO_INCREMENT PRIMARY KEY, userName char(3), age int);
  SELECT * FROM testtbl2;
  INSERT INTO testTBL2 VALUES(NULL, '지민', 25);
  INSERT INTO testTBL2 VALUES(NULL, '유나', 22);
   INSERT INTO testTBL2 VALUES(NULL, '유경', 21);
SELECT last_insert_id();
INSERT INTO testTBL2 VALUES(10, '민호', 45);
INSERT INTO testTBL2 VALUES(NULL, '제니', 21); 

ALTER TABLE testtbl2 AUTO_INCREMENT = 20; -- 원하는 번째부터 값을 설정(현재의 값보다 작은 것은 설정 불가) 
INSERT INTO testTBL2 VALUES(NULL, '리사', 21); 
set @@auto_increment_increment=3;
INSERT INTO testTBL2 VALUES(NULL, '나연', 20); 
INSERT INTO testTBL2 VALUES(NULL, '정연', 19);
INSERT INTO testTBL2 VALUES(NULL, '모모', 18);

-- 대량의 샘플 데이터 생성
use sqldb;
CREATE TABLE testTBL4(id int, Fname varchar(50), Lname varchar(50));
INSERT INTO testTBL4 SELECT emp_no, first_name, last_name FROM employees.employees;
CREATE TABLE testTBL5(SELECT emp_no, first_name, last_name FROM employees.employees);
CREATE TABLE testTBL6 (SELECT emp_no AS 'id', first_name AS 'Fname', last_name AS 'Lname' FROM
    employees.employees);

-- 데이터의 수정 : UPDATE(사용시 주의)
UPDATE testTBL4 SET Lname = '없음' WHERE Fname = 'kyoichi';
UPDATE buytbl SET price = price * 1.5;
DELETE FROM testtbl4 WHERE Fname ='Aamer';  
DELETE FROM testtbl4 WHERE Fname ='Domenick' Having  LIMIT 5;


