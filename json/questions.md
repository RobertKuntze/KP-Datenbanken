Does the cost estimation understand that jsons are harder to query than tables.

Wird der Aufwand von Json Funktionen realistisch geschätzt?



Hardware/Software Differences?
I get Hash Joins in both, effectively same plan

the main results have a hash join for json and a merge join for normal

Still the actual Join is 23800 vs 24200 and 77ms vs 754ms (and the 23800 has startup cost ~ 0 vs 12000 for the 24200)

Join Filter removes 24k vs 8k
Only half the shared hit blocks for json query
