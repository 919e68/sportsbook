DECLARE @eventId BIGINT = 2733531698851840

SELECT
  EventParts.name,
  CASE
    WHEN BettingOffers.bettingTypeId = 69 THEN
      CASE
        WHEN Outcomes.typeId = 10 THEN
          CASE
            WHEN Outcomes.paramParticipantId1 = Home.homeTeamId THEN Home.homeTeamName
            WHEN Outcomes.paramParticipantId1 = Away.awayTeamId THEN Away.awayTeamName
            ELSE NULL
          END
        WHEN Outcomes.typeId = 11 THEN 'Draw'
        ELSE NULL
      END
    WHEN BettingOffers.bettingTypeId = 48 THEN
      CASE
        WHEN Outcomes.typeId = 60 THEN
          CASE
            WHEN Outcomes.paramParticipantId1 = Home.homeTeamId THEN Home.homeTeamName
            WHEN Outcomes.paramParticipantId1 = Away.awayTeamId THEN Away.awayTeamName
            ELSE NULL
          END
        ELSE NULL
      END
    WHEN BettingOffers.bettingTypeId = 47 THEN
      CASE
        WHEN Outcomes.typeId = 13 THEN 'Over'
        WHEN Outcomes.typeId = 14 THEN 'Under'
        ELSE NULL
      END
    WHEN BettingOffers.bettingTypeId = 35 THEN
      CASE
        WHEN Outcomes.typeId = 22 THEN 'Odd'
        WHEN Outcomes.typeId = 23 THEN 'Even'
        ELSE NULL
      END
    WHEN BettingOffers.bettingTypeId = 32 THEN
      CASE
        WHEN Outcomes.paramFloat2 IS NOT NULL THEN
          CONCAT(Outcomes.paramFloat1, ' - ', Outcomes.paramFloat2)
        ELSE
          CONCAT(Outcomes.paramFloat1, ' & Over')
      END
    WHEN BettingOffers.bettingTypeId = 45 THEN
      CONCAT(Outcomes.paramFloat1, ' - ', Outcomes.paramFloat2)
    WHEN BettingOffers.bettingTypeId = 76 THEN
      CASE
        WHEN Outcomes.paramBoolean1 = 1 THEN 'Yes'
        WHEN Outcomes.paramBoolean1 = 0 THEN 'No'
        ELSE NULL
      END
    WHEN BettingOffers.bettingTypeId = 70 THEN
      CASE
        WHEN Outcomes.typeId = 10 THEN
          CASE
            WHEN Outcomes.paramParticipantId1 = Home.homeTeamId THEN Home.homeTeamName
            WHEN Outcomes.paramParticipantId1 = Away.awayTeamId THEN Away.awayTeamName
            ELSE NULL
          END
        ELSE NULL
      END
    ELSE NULL
  END AS bg_name_eng,

  CASE
    WHEN BettingOffers.bettingTypeId = 69 THEN
      CASE
        WHEN Outcomes.typeId = 10 THEN
          CASE
            WHEN Outcomes.paramParticipantId1 = Home.homeTeamId THEN 0
            WHEN Outcomes.paramParticipantId1 = Away.awayTeamId THEN 2
            ELSE NULL
          END
        WHEN Outcomes.typeId = 11 THEN 1
        ELSE NULL
      END
    WHEN BettingOffers.bettingTypeId = 48 THEN
      CASE
        WHEN Outcomes.typeId = 60 THEN
         CASE
            WHEN Outcomes.paramParticipantId1 = Home.homeTeamId THEN 0
            WHEN Outcomes.paramParticipantId1 = Away.awayTeamId THEN 1
            ELSE NULL
         END
      END
    WHEN BettingOffers.bettingTypeId = 47 THEN
      CASE
        WHEN Outcomes.typeId = 13 THEN 0
        WHEN Outcomes.typeId = 14 THEN 1
        ELSE NULL
      END
    WHEN BettingOffers.bettingTypeId = 35 THEN
      CASE
        WHEN Outcomes.typeId = 22 THEN 0
        WHEN Outcomes.typeId = 23 THEN 1
        ELSE NULL
      END
    WHEN BettingOffers.bettingTypeId = 32 THEN
      CASE
        WHEN Events.sportId = 1 THEN
          CASE
            WHEN Outcomes.paramFloat1 = 0 THEN 0
            WHEN Outcomes.paramFloat1 = 2 THEN 1
            WHEN Outcomes.paramFloat1 = 4 THEN 2
            WHEN Outcomes.paramFloat1 = 7 THEN 3
            ELSE NULL
          END
      END
    WHEN BettingOffers.bettingTypeId = 45 THEN
      CASE
        WHEN Events.sportId = 1 THEN
          CASE
            WHEN Outcomes.paramFloat1 > Outcomes.paramFloat2 THEN 0
            WHEN Outcomes.paramFloat1 = Outcomes.paramFloat2 THEN 1
            WHEN Outcomes.paramFloat1 < Outcomes.paramFloat2 THEN 2
            ELSE NULL
          END
      END
    WHEN BettingOffers.bettingTypeId = 76 THEN
      CASE
        WHEN Outcomes.paramBoolean1 = 1 THEN 0
        WHEN Outcomes.paramBoolean1 = 0 THEN 1
        ELSE NULL
      END
    WHEN BettingOffers.bettingTypeId = 70 THEN
      CASE
        WHEN Outcomes.typeId = 10 THEN
          CASE
            WHEN Outcomes.paramParticipantId1 = Home.homeTeamId THEN 0
            WHEN Outcomes.paramParticipantId1 = Away.awayTeamId THEN 2
            ELSE NULL
          END
        ELSE NULL
      END
    ELSE NULL
  END AS bg_pos,

  BettingOffers.odds,
  BettingOfferStatuses.isAvailable
FROM
  BettingOffers LEFT JOIN
  BettingOfferStatuses ON BettingOfferStatuses.id = BettingOffers.statusId LEFT JOIN
  Outcomes ON Outcomes.id = BettingOffers.outcomeId LEFT JOIN
  Events ON Events.id = Outcomes.eventId LEFT JOIN
  EventParts ON EventParts.id = Outcomes.eventPartId LEFT JOIN
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
  BettingOffers.providerId = 3000343 AND
  BettingOffers.bettingTypeId = 69 AND
  EventParts.name IN ('Whole Match', 'Ordinary Time', '1st Half (Ordinary Time)') AND
  Events.id = @eventId
ORDER BY
  EventParts.name ASC,
  bg_pos ASC
