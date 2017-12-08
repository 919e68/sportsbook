SELECT
  Events.id AS bt_group_seq,
  Home.homeTeamName AS bt_home_name,
  Away.awayTeamName AS bt_away_name,
  DATEADD(HOUR, 9, Events.startTime) AS bt_stime,
  CASE
    WHEN (Events.statusId = 1 AND Events.startTime < GETUTCDATE()) THEN 5
    WHEN (Events.statusId = 1) THEN 2
    WHEN (Events.statusId = 3) THEN 6
    WHEN (Events.statusId = 4) THEN 1
    WHEN (Events.statusId IN (2)) THEN 5
    WHEN (Events.statusId IN (5, 6, 7, 8)) THEN 8
  END AS bt_status
FROM
  Events LEFT JOIN
  Events AS Leagues ON Leagues.id = Events.parentId LEFT JOIN
  (
    SELECT
      EventParticipantRelations.eventId,
      Participants.id AS homeTeamId,
      Participants.name AS homeTeamName
    FROM
      EventParticipantRelations LEFT JOIN
      Participants ON Participants.id = EventParticipantRelations.participantId
    WHERE
      EventParticipantRelations.participantRoleId = 1
  ) AS Home ON Home.eventId = Events.id LEFT JOIN
  (
    SELECT
      EventParticipantRelations.eventId,
      Participants.id AS awayTeamId,
      Participants.name AS awayTeamName
    FROM
      EventParticipantRelations LEFT JOIN
      Participants ON Participants.id = EventParticipantRelations.participantId
    WHERE
      EventParticipantRelations.participantRoleId = 2
  ) AS Away ON Away.eventId = Events.id
WHERE
  Events.statusId = 3 AND
  Events.sportId = 1
ORDER BY
 Events.startTime DESC
