/* 
For PostgreSQL 9.3.4 
Find duplicate records in rebate_ziputilities table
Occasionally, there are duplicate records that have the
same utililty_id, energytype_id, and utilitytype_id 
for the same zipcode

These records are just clutter and need to be deleted.
This query accomplishes this by using 
ROWNUMBER() OVER PARTITION method

The subqueries seem excessive, but the have additional columns
to help the user visualize the data and check before committing the DELETE
*/

--SELECT *
DELETE 
FROM rebate_ziputilities--_bak
WHERE id IN 
(
	SELECT id
	FROM 
	(
		SELECT ROW_NUMBER() OVER (PARTITION BY zipcode
							,utility_id
							,energytype_id
							,utilitytype_id
					ORDER BY id) rank
	
			,zipcode
			,utility_id
			,energytype_id
			,utilitytype_id
			,id
		FROM rebate_ziputilities--_bak
		--WHERE zipcode = '19104'
		ORDER BY zipcode
			,utility_id
			,energytype_id
			,utilitytype_id
	) a
	WHERE a.rank > 1
)

