SELECT
	bt_group_seq,
	bt_home_name_init,
	bt_away_name_init,
	DATEADD(HOUR, 9, bt_stime) AS bt_stime
FROM
	bett
WHERE
	bt_status = 6 AND
	bt_Item = 146
GROUP BY
	bt_group_seq,
	bt_home_name_init,
	bt_away_name_init,
	bt_stime
ORDER BY
	bt_stime DESC
