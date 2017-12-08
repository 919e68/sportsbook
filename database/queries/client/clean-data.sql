-- FOR DIST database
TRUNCATE TABLE bett_league
TRUNCATE TABLE bett
TRUNCATE TABLE bett_game
TRUNCATE TABLE bett_game_adj
TRUNCATE TABLE bett_game_count
-- TRUNCATE TABLE bett_token


-- FOR V3 database
DELETE FROM bett WHERE bt_type IN (1,2,3,4)
DELETE FROM bett_game
DELETE FROM bett_league
DELETE FROM bett_game_count
