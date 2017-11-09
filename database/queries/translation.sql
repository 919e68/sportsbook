SELECT COUNT(*) AS [count] FROM Translations 


SELECT
  Translations.english,
  Translations.korean,
  Translations.leagueId,
  Translations.locationId,
  COUNT(*) AS [count]
FROM
  Translations
WHERE
  Translations.typeId = 1
GROUP BY
  Translations.english,
  Translations.korean,
  Translations.leagueId,
  Translations.locationId
ORDER BY
  COUNT(*) DESC



SELECT
  Translations.english,
  Translations.korean,
  COUNT(*) AS [count]
FROM
  Translations
WHERE
  Translations.typeId = 2
GROUP BY
  Translations.english,
  Translations.korean


/*
TRUNCATE TABLE Translations

DECLARE @english NVARCHAR(255) = 'Parana'
DECLARE @korean NVARCHAR(255) = 'Parana'

SELECT * FROM Translations WHERE english LIKE @english
UPDATE Translations SET korean = @korean WHERE english LIKE @english
*/