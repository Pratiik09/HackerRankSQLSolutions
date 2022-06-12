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


