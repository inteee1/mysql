USE sqldb;
SET @myvar1 = 5;
SET @myvar2 = 3;
SET @myvar3 = 4.25;
SET @myvar4 = '가수 이름 ==>';

SELECT @myvar1, @myvar2, @myvar3, @myvar4;
SELECT @myvar4, name FROM usertbl WHERE height > 180;
testtbl1
-- 데이터의 형식과 형변환
SELECT AVG(amount) FROM buytbl;
-- 실수를 정수로 변환 
SELECT cast(AVG(amount) AS SIGNED INTEGER) AS '평균 구매 개수' FROM buytbl;  -- 실수를 반올림해서 정수로 변환한다.
SELECT CONVERT(AVG(amount), SIGNED INTEGER) AS '평균 구매 개수' FROM buytbl;

-- 문자열을 DATE 형으로 변환
 SELECT cast('2020-01-01' AS DATE);
  SELECT cast('12:34:56' AS TIME);
 SELECT cast('2020+01+02' AS DATE);  
 
-- 암시적인 형변환
SELECT '100' + '200'; -- 문자형 숫자와 문자형 숫자를 더함(정수로 변환)
SELECT 'ABC'+'DEF'; -- 문자 + 문자 = NULL
SELECT CONCAT('ABC', 'DEF'); -- ABCDEF
SELECT CONCAT('100', '200'); -- 100200
SELECT CONCAT(100, '200'); -- 100200
SELECT CONCAT(100, 200); -- 100200

SELECT 1 > '2mega'; -- 0 문자열이 정수 2로 변환
SELECT 3 > '2MEGA'; -- 1 문자열이 정수 2로 변환
SELECT 0 > 'mega2'; -- 0 문자열이 정수 0으로 변환

-- 제어 흐름 함수
SELECT IF (100 > 200, '참이다', '거짓이다');
SELECT IFNULL (NULL, 'NULL이군요'), IFNULL(100, 'NULL이군요'), IFNULL(100>200, 'NULL이군요');
SELECT NULLIF(100, 100), nullif(200, 100); -- IF (A = B) -> NULL, ELSE (A != B) -> 값

-- 문자열 함수
SELECT ASCII('A'), char(65) ;
SELECT BIT_LENGTH('abc'), CHAR_LENGTH('abc'), length('abc');
SELECT BIT_LENGTH('가나다'), CHAR_LENGTH('가나다'), length('가나다');
SELECT CONCAT('abc', 'def','ghi');
SELECT concat_ws(' ','abc','def', 'ghi');
SELECT ELT(2, '하나', '둘', '셋'), FIELD('둘', '하나','둘', '셋'), find_in_set('둘', '하나,둘,셋');
SELECT instr('하나둘셋', '둘'), locate('나','하나둘셋');

SELECT format(123456.12349556,5);
SELECT BIN(31), HEX(31), OCT(31);
SELECT INSERT('ABCDEFGHI', 3, 4, '@@@');
SELECT LPAD('이것이', 5,'##');
SELECT RPAD('이것이', 5,'##');
 
 -- 날짜 및 시간 함수
SELECT ADDDATE('2023-02-20', 90); -- DAY 더하기 
SELECT ADDDATE('2023-02-20', interval 90 day);  
SELECT ADDDATE('2023-02-20', interval 3 MONTH);  -- MONTH 더하기
SELECT ADDDATE('2023-02-20', interval 1 YEAR); -- YEAR 더하기 
SELECT SUBDATE('2023-02-20', 90); -- DAY 빼기

SELECT addtime('10:18:30', '07:12:00' ), addtime('2023-03-10 10:18:30', '20:12:00' );
SELECT SUBtime('17:30:30', '07:12:00' ), SUBtime('2023-03-10 10:18:30', '20:12:00' );
SELECT curdate(), curtime(), NOW(), sysdate();
SELECT YEAR(CURDATE()), mONTH(CURDATE()), DAY(curdate()); 
SELECT HOUR(CURTIME()), minute(CURTIME(5)), second(CURTIME());
SELECT microsecond(curtime(6));
SELECT DATEDIFF('2023-02-20', NOW()), TIMEDIFF('23:23:59', '12:11:10');
select last_day('4040-02-02');
select quarter('2023-06-22');
select time_to_sec('12:11:10');

select user();
select database();
select * from usertbl;
select found_rows();
-- --------------피벗 테스트----------------- 
CREATE TABLE pivotTest(uName char(3), season char(2), amount int);
INSERT INTO pivottest(uName, season, amount) VALUE('김범수', '겨울', 10);
INSERT INTO pivottest(uName, season, amount) VALUE('윤종신', '여름', 15);
INSERT INTO pivottest(uName, season, amount) VALUE('김범수', '가을', 25);
INSERT INTO pivottest(uName, season, amount) VALUE('김범수', '봄', 3);
INSERT INTO pivottest(uName, season, amount) VALUE('김범수', '봄', 37);
INSERT INTO pivottest(uName, season, amount) VALUE('윤종신', '겨울', 40);
INSERT INTO pivottest(uName, season, amount) VALUE('김범수', '여름', 14);
INSERT INTO pivottest(uName, season, amount) VALUE('김범수', '겨울', 22);
INSERT INTO pivottest(uName, season, amount) VALUE('윤종신', '여름', 64);
select * from pivottest;
select uName, 
			  sum(IF(season = '봄', amount, 0)) as '봄', 
			  sum(IF(season = '여름', amount, 0)) as '여름', 
              sum(IF(season = '가을', amount, 0)) as '가을', 
              sum(IF(season = '겨울', amount, 0)) as '겨울', 
              sum(amount) as '합계' 
from pivottest group by uName;

SELECT season, 
	 sum(IF(uName = '김범수', amount, 0)) as '김범수',
     sum(IF(uName = '윤종신', amount, 0)) as '윤종신',
     sum(amount) as '합계'
from pivottest  group by season order by season;

select version();

  -- join
use sqldb;
SELECT 
    B.userID, U.NAME, B.prodName, 
    U.ADDR, concat(U.MOBILE1, U.MOBILE2) AS '연락처'
FROM buytbl B
        INNER JOIN usertbl U ON B.userID = U.userID
/*WHERE
    buytbl.userID = 'JYP'*/
ORDER BY num;

SELECT 
    *
FROM buytbl, usertbl;
--  세　개의　테이블 조인
select 
	SC.stdName, S.ADDR, SC.clubName, C.roomNo
from stdtbl S
	INNER JOIN stdclubtbl SC ON S.stdName = SC.stdName
    INNER JOIN clubtbl C ON SC.clubName = C.clubName
ORDER BY S.stdName;

-- 실습 1 : 각각의 사람들이 가입한 클럽의 갯수 출력
-- 김범수 2곳, 바비킴 1, 조용필 1

-- 프로시저 프로그래밍(PL/SQL)
DROP PROCEDURE IF EXISTS ifPROC;
DELIMITER $$
CREATE PROCEDURE ifPROC()
BEGIN
	DECLARE var1 INT;	-- 변수 생성
	SET var1 = 100;		-- 변수값 대입
    
    IF var1 = 100 THEN
		SELECT "100입니다.";
	ELSE
		SELECT "100이 아닙니다.";
	END IF;
    

END $$

DELIMITER ;

CALL ifPROC();

-- 2

 