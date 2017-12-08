
SELECT
	Home.homeTeamId,
	Home.homeTeamName,
	away.awayTeamId,
	Away.awayTeamName,

	CASE
		WHEN BettingOffers.bettingTypeId = 45 THEN
		CASE
			WHEN (Outcomes.paramParticipantId1 = Home.homeTeamId AND Outcomes.paramFloat1 > Outcomes.paramFloat2) OR (Outcomes.paramParticipantId2 = Home.homeTeamId AND Outcomes.paramFloat2 > Outcomes.paramFloat1) THEN 0
			WHEN (Outcomes.paramFloat1 = Outcomes.paramFloat2) THEN 1
			WHEN (Outcomes.paramParticipantId1 = Away.awayTeamId AND Outcomes.paramFloat1 > Outcomes.paramFloat2) OR (Outcomes.paramParticipantId2 = Away.awayTeamId AND Outcomes.paramFloat2 > Outcomes.paramFloat1) THEN 2
			ELSE NULL
		END
	END AS bg_pos,

    CASE
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

	CASE
		WHEN BettingOffers.bettingTypeId = 45 THEN
			CASE
				WHEN (Outcomes.paramParticipantId1 = Home.homeTeamId AND Outcomes.paramFloat1 > Outcomes.paramFloat2) THEN CONCAT(Outcomes.paramFloat1, ' - ', Outcomes.paramFloat2)
				WHEN (Outcomes.paramParticipantId2 = Home.homeTeamId AND Outcomes.paramFloat2 > Outcomes.paramFloat1) THEN CONCAT(Outcomes.paramFloat2, ' - ', Outcomes.paramFloat1)
				WHEN (Outcomes.paramParticipantId1 = Away.awayTeamId AND Outcomes.paramFloat1 > Outcomes.paramFloat2) THEN CONCAT(Outcomes.paramFloat2, ' - ', Outcomes.paramFloat1)
				WHEN (Outcomes.paramParticipantId2 = Away.awayTeamId AND Outcomes.paramFloat2 > Outcomes.paramFloat1) THEN CONCAT(Outcomes.paramFloat1, ' - ', Outcomes.paramFloat2)
				ELSE CONCAT(Outcomes.paramFloat1, ' - ', Outcomes.paramFloat2)
			END
	END AS bg_name_eng,
	BettingOffers.odds

FROM
	BettingOffers LEFT JOIN
	Outcomes ON Outcomes.id = BettingOffers.outcomeId LEFT JOIN
	Events ON Events.id = Outcomes.eventId LEFT JOIN
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
    ) AS Home ON Home.eventId = Outcomes.eventId LEFT JOIN
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
    ) AS Away ON Away.eventId = Outcomes.eventId
WHERE
	BettingOffers.providerId = 3000343 AND
	Events.id = 2758013198430208 AND
	BettingOffers.bettingTypeId = 45 AND
	Outcomes.eventPartId = 3
ORDER BY
	bg_pos,
	bg_line
