SELECT
	bett_game.bt_group_seq,
	DATEADD(HOUR, 9, bett.bt_stime) AS bt_stime,
	bett.bt_home_name,
	bett.bt_away_name,
	bett_game.be_index,

	CASE
		WHEN bett_game.be_index = 1 THEN 'Home Draw Away'
		WHEN bett_game.be_index = 2 THEN 'Home Dra Away (1st Half)'
		WHEN bett_game.be_index = 3 THEN 'Handicap'
		WHEN bett_game.be_index = 4 THEN 'Handicap (1st Half)'
		WHEN bett_game.be_index = 5 THEN 'Over Under'
		WHEN bett_game.be_index = 6 THEN 'Over Under (1st Half)'
		WHEN bett_game.be_index = 7 THEN 'Odd Even'
		WHEN bett_game.be_index = 8 THEN 'Total Goal'
		WHEN bett_game.be_index = 9 THEN 'Correct Score'
		WHEN bett_game.be_index = 10 THEN 'Both Team To Score'
		WHEN bett_game.be_index = 11 THEN 'Home Away'
		ELSE NULL
	END AS [bt_type],

	bett_game.bg_line
FROM
	bett_game LEFT JOIN
	bett ON bett.seq = bett_game.bg_group_seq
WHERE
	bett.bt_status IN (1, 2, 5) AND
	bett_game.bg_status IN (1, 2, 5) AND
	bett_game.be_index IN (3, 4, 5, 6)
	AND bett.bt_stime >= DATEADD(HOUR, -3, GETUTCDATE())
	AND bett.bt_stime < '2017-11-11 15:00:00'
GROUP BY
	bett_game.bt_group_seq,
	bett.bt_stime,
	bett.bt_home_name,
	bett.bt_away_name,
	bett_game.be_index,
	bett_game.bg_line
ORDER BY
	bett.bt_stime ASC,
	bett_game.bt_group_seq ASC,
	bett_game.be_index ASC,
	bett_game.bg_line
