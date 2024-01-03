/*
    조인
    1. 조회할 때 필요한 칼럼이 2개 이상의 테이블에 존재할 때 조인을 사용한다.
    2. 조인 조건을 이용해서 각 테이블을 조인한다.
    3. 조인 종류
        1) 내부 조인 : 조회할 테이블에 모두 존재하는 데이터를 대상으로 조인
        2) 외부 조인 : 어느 한 테이블에만 존재하는 데이터를 조회 대상에 포함
*/

/*
    내부 조인
*/

-- 1. 사원번호, 사원명, 부서번호, 부서명을 조회하시오.
SELECT E.EMP_NO AS 사원번호
     , E.NAME AS 사원명
     , E.DEPART AS 부서번호
     , D.DEPT_NAME AS 부서명
  FROM DEPARTMENT_T D, EMPLOYEE_T E
  WHERE D.DEPT_NO = E.DEPART;
    
-- 2. 부서별 평균연봉을 조회하시오. 부서명과 평균연봉을 조회하시오.
SELECT D.DEPT_NAME
     , AVG(E.SALARY)
  FROM DEPARTMENT_T D, EMPLOYEE_T E
  WHERE D.DEPT_NO = E.DEPART  
  GROUP BY D.DEPT_NAME;
    
/*
    외부 조인(OUTER JOIN)
    
*/

-- 외부 조인 확인을 위한 데이터 입력
INSERT INTO EMPLOYEE_T (
    EMP_NO
    , NAME
    , DEPART
    , POSITION
    , GENDER
    , HIRE_DATE
    , SALARY
) VALUES (
    EMPLOYEE_SEQ.NEXTVAL
    , '홍길동'
    , NULL
    , '회장'
    , 'F'
    , '00/01/01'
    , 10000000
);
COMMIT;

-- 1. 모든 사원들의 사원번호, 사원명, 부서병을 조회하시오. 
SELECT E.EMP_NO, E.NAME, D.DEPT_NAME
  FROM DEPARTMENT_T D, EMPLOYEE_T E
  WHERE D.DEPT_NO(+) = E.DEPART; -- [오른쪽 조인] 오른쪽 조인은 왼쪽에 (+) 추가하기
    
-- 2. 부서별 사원수를 조회하시오. 부서명, 사원수를 조회하시오. 사원이 없으면 0으로 조회하시오.
SELECT D.DEPT_NAME, COUNT(E.EMP_NO)
  FROM DEPARTMENT_T D JOIN EMPLOYEE_T E
  WHERE D.DEPT_NO = E.DEPART(+) -- 왼쪽 조인은 오른쪽에 (+) 추가하기
  GROUP BY D.DEPT_NAME;
  
-- HR 계정

-- 1. 사원번호, 사원명, 부서명을 조회하시오.
SELECT E.EMPLOYEE_ID, E.FIRST_NAME, E.LAST_NAME, D.DEPARTMENT_NAME
  FROM DEPARTMENTS D, EMPLOYEES E
  WHERE D.DEPARTMENT_ID = E.DEPARTMENT_ID;

-- 2. 부서번호, 부서명, 지역명을 조회하시오.
SELECT D.DEPARTMENT_ID, D.DEPARTMENT_NAME, L.STREET_ADDRESS
  FROM LOCATIONS L, DEPARTMENTS D
  WHERE L.LOCATION_ID = D.LOCATION_ID; 

-- 3. 사원번호, 사원명, 직업, 직업별 최대연봉, 연봉을 조회하시오.
SELECT E.EMPLOYEE_ID, E.LAST_NAME, E.JOB_ID, J.MAX_SALARY, E.SALARY
  FROM JOBS J, EMPLOYEES E
  WHERE J.JOB_ID = E.JOB_ID;
    
-- 외부 조인 

-- 4. 사원번호, 사원명, 부서명을 조회하시오. 부서가 없으면 '부서없음'으로 조회하시오.
SELECT E.EMPLOYEE_ID, E.LAST_NAME, NVL(D.DEPARTMENT_NAME, '부서없음')
  FROM DEPARTMENTS D, EMPLOYEES E
  WHERE D.DEPARTMENT_ID(+) = E.DEPARTMENT_ID;
    
-- 5. 부서별 평균급여를 조회하시오. 부서명, 평균급여를 조회하시오. 근무중인 사원이 없으면 평균급여를 0으로 조회하시오.
SELECT D.DEPARTMENT_NAME, NVL(TRUNC(AVG(E.SALARY)), 0)
  FROM DEPARTMENTS D, EMPLOYEES E
  WHERE D.DEPARTMENT_ID = E.DEPARTMENT_ID(+)
  GROUP BY D.DEPARTMENT_ID, D.DEPARTMENT_NAME;
 
-- 3개 이상 테이블 조인하기

-- 6. 사원번호, 사원명, 부서번호, 부서명, 지역번호, 지역명
SELECT E.EMPLOYEE_ID, E.LAST_NAME, D.DEPARTMENT_ID, D.DEPARTMENT_NAME, L.LOCATION_ID, L.STREET_ADDRESS
  FROM DEPARTMENTS D, EMPLOYEES E, LOCATIONS L
  WHERE D.DEPARTMENT_ID = E.DEPARTMENT_ID 
  AND D.LOCATION_ID = L.LOCATION_ID ;
    
SELECT E.EMPLOYEE_ID, E.LAST_NAME, D.DEPARTMENT_ID, D.DEPARTMENT_NAME, L.LOCATION_ID, L.STREET_ADDRESS
  FROM LOCATIONS L, DEPARTMENTS D, EMPLOYEES E
  WHERE L.LOCATION_ID = D.LOCATION_ID  
  AND D.DEPARTMENT_ID = E.DEPARTMENT_ID;
    
-- 7. 국가명, 도시명, 부서명을 조회하시오.
SELECT C.COUNTRY_NAME, L.CITY, D.DEPARTMENT_NAME
  FROM COUNTRIES C, LOCATIONS L, DEPARTMENTS D
  WHERE C.COUNTRY_ID = L.COUNTRY_ID  
  AND L.LOCATION_ID = D.LOCATION_ID;
    
-- 셀프 조인 (하나의 테이블에 일대다 관계를 가지는 칼럼들이 존내하는 경우)

-- 8. 사원번호, 사원명, 매니저번호, 매니저명을 조회하시오.
-- 관계
-- 1명의 매니저가 N명의 사원을 관리한다.
-- 1                                 N
-- 매니저테이블 : EMPLOYEES M        사원테이블    : EMPLOYEES E 
-- PK           : EMPLOYEE_ID        FK            : MANAGER_ID
-- 조인조건      : 
SELECT E.EMPLOYEE_ID AS 사원번호
     , E.LAST_NAME   AS 사원명
     , E.MANAGER_ID  AS 매니저번호
     , M.LAST_NAME   AS 매니저명
  FROM EMPLOYEES M, EMPLOYEES E
  WHERE M.EMPLOYEE_ID = E.MANAGER_ID;

-- 9. 같은 부서내에서 나보다 급여를 더 많이 받는 사원을 조회하시오.
-- 관계
-- 나는 여러 사원과 관계를 맺는다.
-- 나(EMPLOYEES ME) 너님들(EMPLOYEES YOU)
-- 같은 부서의 사원만 조인하기 위해서 부서 번호로 조인조건을 생성함
SELECT ME.EMPLOYEE_ID AS 사원번호
     , ME.LAST_NAME AS 사원명
     , ME.SALARY AS 급여
     , YOU.EMPLOYEE_ID AS 너사원번호
     , YOU.LAST_NAME AS 너사원명
     , YOU.SALARY AS 너급여
  FROM EMPLOYEES ME, EMPLOYEES YOU
 WHERE ME.DEPARTMENT_ID = YOU.DEPARTMENT_ID
   AND ME.SALARY < YOU.SALARY;
    
    
    