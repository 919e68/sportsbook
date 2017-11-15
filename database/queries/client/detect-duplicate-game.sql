SELECT
  bt_mark,
  bt_home_name_init,
  bt_away_name_init,
  bt_stime,
  COUNT(*) AS count
FROM
  bett
GROUP BY
  bt_mark,
  bt_home_name_init,
  bt_away_name_init,
  bt_stime
ORDER BY
 COUNT(*) DESC
