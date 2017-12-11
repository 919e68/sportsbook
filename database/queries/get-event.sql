DECLARE @eventId BIGINT = 2397386476646400

SELECT
  Events.id AS [eventId],
  Events.startTime,
  Leagues.name AS [leagueName],
  Sports.name AS [sportsName],
  Home.homeTeamName,
  Away.awayTeamName,
  Events.parentId
FROM
  Events LEFT JOIN
  Sports ON Sports.id = Events.sportId LEFT JOIN
  Events Leagues ON Leagues.id = Events.parentId LEFT JOIN
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
   Events.id = @eventId
