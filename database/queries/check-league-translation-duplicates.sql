SELECT
  Translations.english,
  Translations.leagueId,
  Translations.locationId,
  COUNT(*)
FROM
  Translations
WHERE
  Translations.typeId = 1
GROUP BY
  Translations.english,
  Translations.leagueId,
  Translations.locationId
ORDER BY
  COUNT(*) DESC