SELECT
  bt_group_seq,
  be_index,
  bg_pos,
  bg_line,
  COUNT(*) AS [count]
FROM 
  bett_game
GROUP BY
  bt_group_seq,
  be_index,
  bg_pos,
  bg_line
ORDER BY
  COUNT(*) DESC

DECLARE @bt_group_seq BIGINT = 232255825
DECLARE @be_index INT = 1
DECLARE @bg_pos INT = 0
DECLARE @bg_line INT  = 0

SELECT * 
FROM bett_game 
WHERE 
  bt_group_seq = @bt_group_seq AND
  be_index = @be_index AND
  bg_pos = @bg_pos AND
  bg_line = @bg_line

/*

DELETE FROM bett_game WHERE seq = 243584

*/

