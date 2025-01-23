-- compare percentage of answered questions by year
EXPLAIN ANALYZE

WITH QuestionsAnswered AS (
    SELECT 
        extract(YEAR FROM p.CreationDate) AS Year,
        COUNT(p.Id) AS TotalQuestions,
        COUNT(CASE WHEN p.AcceptedAnswerId IS NOT NULL THEN 1 END) AS AnsweredQuestions
    FROM posts p
    WHERE p.PostTypeId = 1 -- Questions only
    GROUP BY extract(YEAR FROM p.CreationDate)
)
SELECT 
    Year,
    TotalQuestions,
    AnsweredQuestions,
    (AnsweredQuestions * 100.0 / TotalQuestions) AS AnsweredPercentage
FROM QuestionsAnswered
ORDER BY Year;
