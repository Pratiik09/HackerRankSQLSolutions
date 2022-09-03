-- Interviews --
-- OP: contest_id, hacker_id, name, and the sums of total_submissions, total_accepted_submissions, total_views, and total_unique_views

SELECT
    C.contest_id, 
    C.hacker_id,
    C.name,
    SUM(SubS.TSub) FTS,
    SUM(SubS.TASub) FTAS,
    SUM(ViewS.TView) FTV,
    SUM(ViewS.UView) FTUV
FROM Colleges Co
INNER JOIN Contests C
ON Co.contest_id = C.contest_id
LEFT JOIN (
    SELECT Ch.college_id, SUM(SS.total_submissions) AS TSub, SUM(SS.total_accepted_submissions) AS TASub
    FROM Challenges Ch
    INNER JOIN Submission_Stats SS
    ON Ch.challenge_id = SS.challenge_id
    GROUP BY Ch.college_id
) SubS
ON Co.college_id = SubS.college_id
LEFT JOIN (
    SELECT Ch.college_id, SUM(VS.total_views) AS TView, SUM(VS.total_unique_views) AS UView
    FROM Challenges Ch
    INNER JOIN View_Stats VS
    ON Ch.challenge_id = VS.challenge_id
    GROUP BY Ch.college_id
) ViewS
ON Co.college_id = ViewS.college_id
GROUP BY C.contest_id, C.hacker_id, C.name
HAVING FTS<>0 AND FTAS<>0 AND FTV<>0 AND FTUV<>0
ORDER BY C.contest_id


-- 15 Days of Learning SQL --
WITH HackerWhoDidMaxSubThatDay AS (
    SELECT submission_date, hacker_id,
    RANK() OVER( PARTITION BY submission_date ORDER BY SubCount DESC, hacker_id ASC ) RN
    FROM (
        SELECT submission_date, hacker_id, COUNT(1) SubCount
        FROM Submissions
        GROUP BY submission_date, hacker_id
    ) GetSubCount
),
DayCounter AS (
    SELECT submission_date, hacker_id,
    DENSE_RANK() OVER( ORDER BY submission_date ) DayIte
    FROM Submissions
),
ConsistentChecker AS (
    SELECT submission_date, hacker_id, DayIte,
    CASE
        WHEN submission_date = '2016-03-01' THEN 1
        ELSE 1+(SELECT COUNT(DISTINCT submission_date)
                FROM Submissions S1
                WHERE S1.hacker_id = DC.hacker_id
                AND S1.submission_date < DC.submission_date            
        ) END Regularity
    FROM DayCounter DC
),
SubmittedEachDay AS (
    SELECT submission_date,
           COUNT(DISTINCT hacker_id) RegularCnt
    FROM ConsistentChecker
    WHERE DayIte = Regularity
    GROUP BY submission_date   
)
SELECT
    SED.submission_date,
    SED.RegularCnt,
    MSTD.hacker_id,
    H.name
FROM SubmittedEachDay SED
INNER JOIN HackerWhoDidMaxSubThatDay MSTD
ON SED.submission_date = MSTD.submission_date
INNER JOIN Hackers H
ON MSTD.hacker_id = H.hacker_id
WHERE MSTD.RN = 1
ORDER BY submission_date