-- posts that link to posts that don't share any tags

WITH posttags AS ( 
    SELECT id, array_remove(regexp_split_to_array(tags, '<|>'), '') AS tags
    FROM posts
    WHERE posttypeid=1
)
SELECT p1.id, p2.id, t1.tags, t2.tags
FROM posts p1
JOIN postlinks pl ON p1.id = pl.postid
JOIN posts p2 ON pl.relatedpostid = p2.id
JOIN posttags t1 ON p1.id = t1.id
JOIN posttags t2 ON p2.id = t2.id
WHERE NOT t1.tags && t2.tags