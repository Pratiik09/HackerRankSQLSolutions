-- Occupations --
SET @D:=0, @P:=0, @S:=0, @A:=0;

WITH TempTab AS (
    SELECT
        CASE
            WHEN Occupation='Doctor' THEN (@D:=@D+1)
            WHEN Occupation='Professor' THEN (@P:=@P+1)
            WHEN Occupation='Singer' THEN (@S:=@S+1)
            WHEN Occupation='Actor' THEN (@A:=@A+1)
        END AS RowNumber,
        CASE WHEN Occupation='Doctor' THEN Name END AS Doctor,
        CASE WHEN Occupation='Professor' THEN Name END AS Professor,
        CASE WHEN Occupation='Singer' THEN Name END AS Singer,
        CASE WHEN Occupation='Actor' THEN Name END AS Actor
    FROM OCCUPATIONS
    ORDER BY Name
)
SELECT MIN(Doctor), MIN(Professor), MIN(Singer), MIN(Actor)
FROM TempTab
GROUP BY RowNumber


-- Binary Tree Nodes--
SELECT
    N,
    CASE 
        WHEN P IS NULL THEN 'Root' 
        WHEN N IN (SELECT P FROM BST) THEN 'Inner'
        ELSE 'Leaf'
    END AS Type
FROM BST
ORDER BY N


-- New Companies --
SELECT 
    T1.company_code,
    T2.founder,
    COUNT(DISTINCT lead_manager_code),
    COUNT(DISTINCT senior_manager_code),
    COUNT(DISTINCT manager_code),
    COUNT(DISTINCT employee_code)
FROM Employee AS T1
INNER JOIN Company AS T2
ON T1.company_code = T2.company_code
GROUP BY T1.company_code, T2.founder
ORDER BY company_code ASC


-- Weather Observation Station 20 --
""" 
This solution will fetch the Median for the set
having odd number of values.
"""
SELECT COUNT(*) FROM STATION INTO @LEN;

WITH TempTab1 AS (
SELECT 
    ROW_NUMBER() OVER 
    (ORDER BY LAT_N ASC) R_Num,
    LAT_N
FROM STATION
)
SELECT ROUND(LAT_N, 4)
FROM TempTab1
WHERE R_Num = (
SELECT CEIL(@LEN/2)
)


-- The Report --
WITH TempTab AS (
SELECT 
Name,
CASE 
    WHEN Marks BETWEEN 0 AND 9 THEN 1
    WHEN Marks BETWEEN 10 AND 19 THEN 2
    WHEN Marks BETWEEN 20 AND 29 THEN 3
    WHEN Marks BETWEEN 30 AND 39 THEN 4
    WHEN Marks BETWEEN 40 AND 49 THEN 5
    WHEN Marks BETWEEN 50 AND 59 THEN 6
    WHEN Marks BETWEEN 60 AND 69 THEN 7
    WHEN Marks BETWEEN 70 AND 79 THEN 8
    WHEN Marks BETWEEN 80 AND 89 THEN 9
    WHEN Marks BETWEEN 90 AND 100 THEN 10
END AS Grade,
Marks
FROM Students
)
SELECT
CASE
    WHEN Grade < 7 THEN NULL
    WHEN Grade > 7 THEN Name
END AS Name,
Grade,
Marks
FROM TempTab
ORDER BY Grade DESC, Name ASC, Marks ASC

"""
Clean Solution:
Comment: I missed the Join first time, as I was unaware of Non-Equi Joins
"""
SELECT IF(Grade < 8, NULL, Name), Grade, Marks
FROM Students 
INNER JOIN Grades
WHERE Marks BETWEEN Min_Mark AND Max_Mark
ORDER BY Grade DESC, Name ASC, Marks ASC

-- Top Competitors --
