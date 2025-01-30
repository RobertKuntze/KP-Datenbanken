-- average Post and Answer Count and corresponding scores for active users grouped by year of user creation date
-- compare to using cte/join to differentiate posttypes

EXPLAIN ANALYZE

WITH UserPostNumbers AS (
    SELECT
    u.id userId, 
    COUNT(CASE WHEN p.posttypeid = 1 THEN 1 END) QuestionCount,
    COUNT(CASE WHEN p.posttypeid = 2 THEN 1 END) AnswerCount,
    avg(CASE WHEN p.posttypeid = 1 THEN score END) avgPostScore,
    avg(CASE WHEN p.posttypeid = 2 THEN score END) avgAnswerScore
    FROM posts p
    JOIN users u ON p.owneruserid = u.id
    GROUP BY userId
    HAVING COUNT(CASE WHEN p.posttypeid = 1 THEN 1 END) >=3
    AND COUNT(CASE WHEN p.posttypeid = 2 THEN 1 END) >= 5
)
SELECT avg(avgPostScore) avgPostScorePerYear,
    avg(avgAnswerScore) avgAnswerScorePerYear,
    avg(QuestionCount) avgQuestionCount,
    avg(answercount) avgAnswerCount,
    extract(YEAR FROM u.creationdate) as Year
FROM UserPostNumbers upn
JOIN users u ON u.id = upn.userId
GROUP BY Year