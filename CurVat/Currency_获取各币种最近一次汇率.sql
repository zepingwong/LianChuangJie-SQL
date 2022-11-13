SELECT
	T_ORTT.Currency,
	T_ORTT.Rate
FROM (
	SELECT
		Currency,
		MAX(RateDate) AS RateDate
	FROM T_ORTT
	GROUP BY Currency
) T
LEFT JOIN T_ORTT ON T_ORTT.Currency = T.Currency AND T_ORTT.RateDate = T.RateDate
UNION ALL
SELECT
	'RMB' AS 'Currency',
	1.000000 AS 'Rate'
