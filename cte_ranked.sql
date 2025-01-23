-- rank users over their total votes per posttype
EXPLAIN ANALYZE

WITH VoteStats AS (
    SELECT 
        u.Id AS UserId,
        u.DisplayName,
        p.PostTypeId,
        SUM(CASE WHEN v.VoteTypeId = 2 THEN 1 ELSE 0 END) AS UpvotesReceived,
        SUM(CASE WHEN v.VoteTypeId = 3 THEN 1 ELSE 0 END) AS DownvotesReceived
    FROM users u
    JOIN posts p ON u.Id = p.OwnerUserId
    LEFT JOIN votes v ON p.Id = v.PostId
    GROUP BY u.Id, u.DisplayName, p.PostTypeId
)
SELECT 
    UserId,
    DisplayName,
    PostTypeId,
    UpvotesReceived,
    DownvotesReceived,
    UpvotesReceived - DownvotesReceived AS NetVotes,
    RANK() OVER (PARTITION BY PostTypeId ORDER BY UpvotesReceived - downvotesReceived DESC) AS RankWithinPostType
FROM VoteStats
ORDER BY netvotes DESC;
