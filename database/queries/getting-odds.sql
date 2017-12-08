SELECT
  BettingOffers.id AS [bg_seq],
  CASE
    WHEN (BettingOffers.bettingTypeId = 69 AND (EventParts.name IN ('Whole Match', 'Ordinary Time'))) THEN 1
    WHEN (BettingOffers.bettingTypeId = 69 AND (EventParts.name IN ('1st Half (Ordinary Time)'))) THEN 2

    WHEN (BettingOffers.bettingTypeId = 48 AND (EventParts.name IN ('Whole Match', 'Ordinary Time'))) THEN 3
    WHEN (BettingOffers.bettingTypeId = 48 AND (EventParts.name IN ('1st Half (Ordinary Time)'))) THEN 4

    WHEN (BettingOffers.bettingTypeId = 47 AND (EventParts.name IN ('Whole Match', 'Ordinary Time'))) THEN 5
    WHEN (BettingOffers.bettingTypeId = 47 AND (EventParts.name IN ('1st Half (Ordinary Time)'))) THEN 6

    WHEN (BettingOffers.bettingTypeId = 35 AND (EventParts.name IN ('Whole Match', 'Ordinary Time'))) THEN 7
    WHEN (BettingOffers.bettingTypeId = 32 AND (EventParts.name IN ('Whole Match', 'Ordinary Time'))) THEN 8
    WHEN (BettingOffers.bettingTypeId = 45 AND (EventParts.name IN ('Whole Match', 'Ordinary Time'))) THEN 9
    WHEN (BettingOffers.bettingTypeId = 76 AND (EventParts.name IN ('Whole Match', 'Ordinary Time'))) THEN 10
    WHEN (BettingOffers.bettingTypeId = 70 AND (EventParts.name IN ('Whole Match', 'Ordinary Time'))) THEN 11
  END AS be_index,

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
      CASE
        WHEN (Outcomes.paramParticipantId1 = Home.homeTeamId AND Outcomes.paramFloat1 > Outcomes.paramFloat2) THEN CONCAT(Outcomes.paramFloat1, ' - ', Outcomes.paramFloat2)
        WHEN (Outcomes.paramParticipantId2 = Home.homeTeamId AND Outcomes.paramFloat2 > Outcomes.paramFloat1) THEN CONCAT(Outcomes.paramFloat2, ' - ', Outcomes.paramFloat1)
        WHEN (Outcomes.paramParticipantId1 = Away.awayTeamId AND Outcomes.paramFloat1 > Outcomes.paramFloat2) THEN CONCAT(Outcomes.paramFloat2, ' - ', Outcomes.paramFloat1)
        WHEN (Outcomes.paramParticipantId2 = Away.awayTeamId AND Outcomes.paramFloat2 > Outcomes.paramFloat1) THEN CONCAT(Outcomes.paramFloat1, ' - ', Outcomes.paramFloat2)
        ELSE CONCAT(Outcomes.paramFloat1, ' - ', Outcomes.paramFloat2)
      END
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
            WHEN (Outcomes.paramParticipantId1 = Home.homeTeamId AND Outcomes.paramFloat1 > Outcomes.paramFloat2) OR (Outcomes.paramParticipantId2 = Home.homeTeamId AND Outcomes.paramFloat2 > Outcomes.paramFloat1) THEN 0
            WHEN (Outcomes.paramFloat1 = Outcomes.paramFloat2) THEN 1
            WHEN (Outcomes.paramParticipantId1 = Away.awayTeamId AND Outcomes.paramFloat1 > Outcomes.paramFloat2) OR (Outcomes.paramParticipantId2 = Away.awayTeamId AND Outcomes.paramFloat2 > Outcomes.paramFloat1) THEN 2
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

  CASE
    WHEN BettingOffers.bettingTypeId IN (48, 47) THEN
      ABS(Outcomes.paramFloat1) * 10
    WHEN BettingOffers.bettingTypeId =  45 THEN
      CASE
        WHEN CONCAT(Outcomes.paramFloat1, '', Outcomes.paramFloat2) IN ('10', '01', '00') THEN 0
        WHEN CONCAT(Outcomes.paramFloat1, '', Outcomes.paramFloat2) IN ('20', '02', '11') THEN 1
        WHEN CONCAT(Outcomes.paramFloat1, '', Outcomes.paramFloat2) IN ('21', '12', '22') THEN 2
        WHEN CONCAT(Outcomes.paramFloat1, '', Outcomes.paramFloat2) IN ('30', '03', '33') THEN 3
        WHEN CONCAT(Outcomes.paramFloat1, '', Outcomes.paramFloat2) IN ('31', '13', '44') THEN 4
        WHEN CONCAT(Outcomes.paramFloat1, '', Outcomes.paramFloat2) IN ('32', '23') THEN 5
        WHEN CONCAT(Outcomes.paramFloat1, '', Outcomes.paramFloat2) IN ('40', '04') THEN 6
        WHEN CONCAT(Outcomes.paramFloat1, '', Outcomes.paramFloat2) IN ('41', '14') THEN 7
        WHEN CONCAT(Outcomes.paramFloat1, '', Outcomes.paramFloat2) IN ('42', '24') THEN 8
        WHEN CONCAT(Outcomes.paramFloat1, '', Outcomes.paramFloat2) IN ('43', '34') THEN 9
      END
    ELSE 0
  END AS bg_line,

  BettingOffers.odds AS bg_rate,

  CASE
    WHEN (BettingOffers.bettingTypeId IN (48, 47)) THEN Outcomes.paramFloat1
    ELSE NULL
  END AS bg_baseline,
  CASE
    WHEN (BettingOffers.bettingTypeId IN (48, 47)) THEN ABS(Outcomes.paramFloat1)
    ELSE NULL
  END AS bg_baseline_abs,

  CASE
    WHEN (
      Events.statusId IN (5, 6, 7, 8)
    ) THEN 8
    WHEN (
      Events.startTime < GETUTCDATE() AND
      Events.statusId = 3
    ) THEN 6
    WHEN (
      Events.startTime <= GETUTCDATE() OR
      (
        Events.statusId IN (2, 4)
      )
    ) THEN 5
    WHEN (
      Events.startTime > GETUTCDATE() AND
      BettingOfferStatuses.isAvailable = 0
    ) THEN 4
    WHEN (
      Events.startTime > GETUTCDATE() AND
      BettingOfferStatuses.isAvailable = 1
    ) THEN 2
  END AS bg_status,

  CASE
    WHEN (BettingOffers.bettingTypeId IN (69, 70)) THEN 1
    WHEN (BettingOffers.bettingTypeId IN (48, 47)) THEN 2
    WHEN (BettingOffers.bettingTypeId IN (35, 32, 45, 76)) THEN 3
  END AS bt_type,

  CASE
    WHEN (Events.sportId = 1) THEN 146
    WHEN (Events.sportId = 9) THEN 147
    WHEN (Events.sportId = 8) THEN 148
    WHEN (Events.sportId = 20) THEN 149
    WHEN (Events.sportId = 6) THEN 150
    WHEN (Events.sportId = 2) THEN 152
  END AS bt_Item,

  CASE
    WHEN (BettingOffers.bettingTypeId = 69 AND (EventParts.name IN ('Whole Match', 'Ordinary Time'))) THEN 1
    WHEN (BettingOffers.bettingTypeId = 69 AND (EventParts.name IN ('1st Half (Ordinary Time)'))) THEN 2

    WHEN (BettingOffers.bettingTypeId = 48 AND (EventParts.name IN ('Whole Match', 'Ordinary Time'))) THEN 3
    WHEN (BettingOffers.bettingTypeId = 48 AND (EventParts.name IN ('1st Half (Ordinary Time)'))) THEN 4

    WHEN (BettingOffers.bettingTypeId = 47 AND (EventParts.name IN ('Whole Match', 'Ordinary Time'))) THEN 5
    WHEN (BettingOffers.bettingTypeId = 47 AND (EventParts.name IN ('1st Half (Ordinary Time)'))) THEN 6

    WHEN (BettingOffers.bettingTypeId = 35 AND (EventParts.name IN ('Whole Match', 'Ordinary Time'))) THEN 7
    WHEN (BettingOffers.bettingTypeId = 32 AND (EventParts.name IN ('Whole Match', 'Ordinary Time'))) THEN 8
    WHEN (BettingOffers.bettingTypeId = 45 AND (EventParts.name IN ('Whole Match', 'Ordinary Time'))) THEN 9
    WHEN (BettingOffers.bettingTypeId = 76 AND (EventParts.name IN ('Whole Match', 'Ordinary Time'))) THEN 10
    WHEN (BettingOffers.bettingTypeId = 70 AND (EventParts.name IN ('Whole Match', 'Ordinary Time'))) THEN 11
    ELSE NULL
  END AS bt_mark,

  Events.startTime AS bt_stime,

  Leagues.id AS bt_league,
  Leagues.name AS bt_league_name,
  Leagues.venueId AS location_id,
  Leagues.popularity AS sort,

  Home.homeTeamName AS bt_home_name,
  Away.awayTeamName AS bt_away_name,

  CASE
    WHEN (BettingOffers.bettingTypeId IN (69, 70)) THEN 'W'
    WHEN (BettingOffers.bettingTypeId = 48) THEN 'H'
    WHEN (BettingOffers.bettingTypeId = 47) THEN 'O'
    WHEN (BettingOffers.bettingTypeId IN (35, 32, 45, 76)) THEN 'W'
  END AS bt_gItem,

  CASE
    WHEN (
      Events.statusId IN (5, 6, 7, 8)
    ) THEN 8
    WHEN (
      Events.startTime < GETUTCDATE() AND
      Events.statusId = 3
    ) THEN 6
    WHEN (
      Events.startTime <= GETUTCDATE() OR
      (
        Events.statusId IN (2, 4)
      )
    ) THEN 5
    WHEN (
      Events.startTime > GETUTCDATE() AND
      BettingOfferStatuses.isAvailable = 0
    ) THEN 4
    WHEN (
      Events.startTime > GETUTCDATE() AND
      BettingOfferStatuses.isAvailable = 1
    ) THEN 2
  END AS bt_status,

  GETUTCDATE() AS bt_regdate,
  Events.id AS bt_group_seq,
  'N' AS bt_hold

FROM
  BettingOffers LEFT JOIN
  Outcomes ON Outcomes.id = BettingOffers.outcomeId LEFT JOIN
  Events ON Events.id = Outcomes.eventId LEFT JOIN
  Events Leagues ON Leagues.id = Events.parentId LEFT JOIN
  EventParts ON EventParts.id = Outcomes.eventPartId LEFT JOIN
  BettingOfferStatuses ON BettingOfferStatuses.id = BettingOffers.statusId LEFT JOIN
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
  ) AS Away ON Away.eventId = Events.id LEFT JOIN
  (
    SELECT
      TOP 1
      EventInfos.eventId,
      EventInfos.paramEventStatusId1 AS statusId
    FROM
      EventInfos
    WHERE
      EventInfos.providerId = 3000979 AND
      EventInfos.typeId = 92
  ) AS EventInfos ON EventInfos.eventId = Events.id
WHERE
  DATEADD(MILLISECOND, Events.deleteTimeOffset, Events.startTime) >= GETUTCDATE() AND
  BettingOffers.providerId = 3000343 AND
  1 = CASE
    WHEN BettingOffers.bettingTypeId IN (48, 47) THEN
      CASE
        WHEN (Outcomes.paramFloat1 - FLOOR(Outcomes.paramFloat1 / 0.5) * 0.5) = 0 THEN 1
        ELSE 0
      END
    ELSE 1
  END AND
  Events.isComplete = 1 AND
  Events.typeId = 1 AND
  BettingOffers.isLive = 0 AND
  (
    (
      BettingOffers.bettingTypeId IN (69) AND Events.sportId IN (1, 6) AND
      EventParts.name IN ('Whole Match', 'Ordinary Time', '1st Half (Ordinary Time)')
    ) OR
    (
      BettingOffers.bettingTypeId IN (70) AND Events.sportId IN (8, 9, 20) AND
      EventParts.name IN ('Whole Match', 'Ordinary Time', '1st Half (Ordinary Time)')
    ) OR
    (BettingOffers.bettingTypeId IN (48, 47) AND EventParts.name IN ('Whole Match', 'Ordinary Time', '1st Half (Ordinary Time)')) OR
    (BettingOffers.bettingTypeId IN (35, 32, 45, 76) AND EventParts.name IN ('Whole Match', 'Ordinary Time'))
  ) AND
  Events.statusId IN (1, 2, 4)  AND
  Events.sportId IN (1, 9, 8, 26, 6, 2)
  ${dateFilter}
ORDER BY
  be_index ASC,
  bt_type ASC,
  bt_mark ASC,
  bt_stime ASC,
  bt_group_seq ASC,
  bg_baseline_abs ASC,
  Outcomes.paramFloat1 ASC,
  Outcomes.paramFloat2 ASC
