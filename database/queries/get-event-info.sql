
DECLARE @eventId BIGINT = 2745120996356096
--------------------------------------------------------------------------------
SELECT
  Events.id AS [eventId],
  DATEADD(HOUR, 9, Events.startTime) AS startTime,
  Leagues.name AS [leagueName],
  Sports.name AS [sportsName],
  Home.homeTeamName,
  Away.awayTeamName,
  Events.parentId,
  Events.statusId
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

--------------------------------------------------------------------------------
SELECT
	EventInfos.id,

	CASE
		WHEN EventParts.name = 'Whole Match' THEN 'FT'
		WHEN EventParts.name = '1st Half (Ordinary Time)' THEN 'HT'
		ELSE NULL
	END AS [time],

	CASE
		WHEN EventInfos.typeId = 1 THEN 'score'
		WHEN EventInfos.typeId = 92 THEN 'status'
    WHEN EventInfos.typeId = 95 THEN 'match-time'
		ELSE NULL
	END AS [data_type],

    CASE
		WHEN EventInfos.typeId = 1 THEN
			CASE
				WHEN Home.homeTeamId = EventInfos.paramParticipantId1 THEN EventInfos.paramFloat1
				WHEN Home.homeTeamId = EventInfos.paramParticipantId2 THEN EventInfos.paramFloat2
				ELSE NULL
			END
		ELSE NULL
    END AS bt_score_home,

    CASE
		WHEN EventInfos.typeId = 1 THEN
			CASE
				WHEN Away.awayTeamId = EventInfos.paramParticipantId1 THEN EventInfos.paramFloat1
				WHEN Away.awayTeamId = EventInfos.paramParticipantId2 THEN EventInfos.paramFloat2
				ELSE NULL
			END
		ELSE NULL
    END AS bt_score_away,

	CASE
		WHEN EventInfos.typeId = 95 THEN EventInfos.paramFloat1
		ELSE NULL
  END AS match_time,

	ParamEventPart.name AS [event_part],
	ParamEventStatus.name AS [event_status]
FROM
	EventInfos LEFT JOIN
	EventInfoTypes ON EventInfoTypes.id = EventInfos.typeId LEFT JOIN
	EventInfoStatuses ON EventInfoStatuses.id = EventInfos.statusId LEFT JOIN
	EventParts ON EventParts.id = EventInfos.eventPartId LEFT JOIN
	Events ON Events.id = EventInfos.eventId LEFT JOIN
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
    ) AS Home ON Home.eventId = EventInfos.eventId LEFT JOIN
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
    ) AS Away ON Away.eventId = EventInfos.eventId
	LEFT JOIN EventParts AS ParamEventPart ON ParamEventPart.id = EventInfos.paramEventPartId1
	LEFT JOIN EventStatuses AS ParamEventStatus ON ParamEventStatus.id = EventInfos.paramEventStatusId1
WHERE
	EventInfos.providerId = 3000979
	AND EventInfos.eventId = @eventId
	AND (
		(EventInfos.typeId = 1 AND EventParts.name IN ('Whole Match', '1st Half (Ordinary Time)')) OR
		(EventInfos.typeId = 92) OR
		(EventInfos.typeId = 95)
	)
ORDER BY
	EventInfos.updatedAt ASC
