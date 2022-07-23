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


