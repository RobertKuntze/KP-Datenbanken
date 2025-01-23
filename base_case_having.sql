-- get Post and Answer Count and average scores for active users

EXPLAIN ANALYZE
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