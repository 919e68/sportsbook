SELECT
  Leagues.id AS [League ID],
  LeagueLocation.id AS [Location ID],
  Sports.id AS [Sport ID],
  DATEADD(HOUR, 9, Events.startTime) AS [Start Time],
  LeagueLocation.name AS [Country],
  Leagues.name AS [League Name (English)],
  '' AS [League Name (Korean)],
  Home.homeTeamName AS [Home Team Name (English)],
  '' AS [Home Team Name (Korean)],
  Away.awayTeamName AS [Away Team Name (English)],
  '' AS [Away Team Name (Korean)]
FROM
  Events LEFT JOIN
  Events Leagues ON Events.parentId = Leagues.id LEFT JOIN
  Sports ON Events.sportId = Sports.id LEFT JOIN
  Locations AS LeagueLocation ON Leagues.venueId = LeagueLocation.id LEFT JOIN
  EventParts ON Events.currentPartId = EventParts.id LEFT JOIN
  EventStatuses ON Events.statusId = EventStatuses.id LEFT JOIN
  (
    SELECT
      Outcomes.eventId,
      COUNT(*) AS [offerCount],
      MAX(BettingOffers.updatedAt) AS offerLastUpdate
    FROM
      BettingOffers LEFT JOIN
      BettingOfferStatuses ON BettingOffers.statusId = BettingOfferStatuses.id LEFT JOIN
      Outcomes ON BettingOffers.outcomeId = Outcomes.id
    WHERE
      BettingOfferStatuses.isAvailable = 1 AND
      BettingOffers.providerId = 3000343
    GROUP BY
      Outcomes.eventId
  ) AS BettingOffers ON Events.id = BettingOffers.eventId LEFT JOIN
  (
    SELECT
      EventInfos.eventId,
      COUNT(*) AS [infoCount],
      MAX(EventInfos.updatedAt) AS infoLastUpdate
    FROM
      EventInfos
    WHERE
      EventInfos.providerId = 3000979
    GROUP BY
      EventInfos.eventId
  ) AS EventInfos ON Events.id = EventInfos.eventId LEFT JOIN
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
  DATEADD(MILLISECOND, Events.deleteTimeOffset, Events.startTime) >= GETUTCDATE() AND
  Events.typeId = 1
  AND Events.statusId IN (1, 2, 4) 
  AND Events.sportId = 1
  AND BettingOffers.offerCount > 0
GROUP BY
  Leagues.id,
  LeagueLocation.id,
  Sports.id,
  Events.startTime,
  LeagueLocation.name,
  Leagues.name,
  Home.homeTeamName,
  Away.awayTeamName
ORDER BY
  Events.startTime ASC