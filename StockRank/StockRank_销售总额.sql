/*各种货币最近一次汇率*/
SELECT T.* INTO #ExchangeRate
FROM (
    SELECT
        T_ORTT.Currency,
        T_ORTT.Rate
    FROM (
        SELECT
            Currency,
            MAX(RateDate) AS RateDate
        FROM T_ORTT
        GROUP BY Currency
    ) Latest
    LEFT JOIN T_ORTT ON T_ORTT.Currency = Latest.Currency AND T_ORTT.RateDate = Latest.RateDate
    UNION ALL
    SELECT
        'RMB'    AS 'Currency',
        1.000000 AS 'Rate'
) T

/*10.采购总额*/
SELECT
    TT.*,
    ROW_NUMBER() OVER(ORDER BY TT.SumMoney DESC) as SumSaleMoneyRank /*近一年采购总额排名*/
FROM (
SELECT
T.Brand,
T.Modle,
ISNULL(_FirstDeliveryFrequency.SumSaleMoney, 0) AS SumSaleMoneyFirst, /*距今1个月销售总额*/
ISNULL(_SecondDeliveryFrequency.SumSaleMoney, 0) AS SumSaleMoneySecond, /*距今2个月销售总额*/
ISNULL(_ThirdDeliveryFrequency.SumSaleMoney, 0) AS SumSaleMoneyThird, /*距今3个月销售总额*/
ISNULL(_ForthDeliveryFrequency.SumSaleMoney, 0) AS SumSaleMoneyForth, /*距今4-12个销售总额*/
(ISNULL(_FirstDeliveryFrequency.SumSaleMoney, 0) + ISNULL(_SecondDeliveryFrequency.SumSaleMoney, 0) + ISNULL(_ThirdDeliveryFrequency.SumSaleMoney, 0) + ISNULL(_ForthDeliveryFrequency.SumSaleMoney, 0)) AS SumMoney

FROM (
    SELECT
        1 AS DocEntry,
        ROW_NUMBER ( ) OVER ( ORDER BY U_ICIN1.Modle ) AS LineNum,
        U_ICIN1.Modle,
        U_ICIN1.Brand
    FROM
        U_ICIN1
    GROUP BY
        U_ICIN1.Modle,
        U_ICIN1.Brand
) T
/*距今1个月交货单频次*/
LEFT JOIN (
	SELECT
		COUNT(*) AS DeliveryFrequency,
		ItemName AS Modle, Brand,
		SUM(Quantity) AS Quantity, /*销售数量*/
		ABS(SUM(Quantity * SPriceAFVAT) * ExchangeRate.Rate) AS SumSaleMoney /*销售总额*/
	FROM U_OIVL
	LEFT JOIN #ExchangeRate ExchangeRate ON ExchangeRate.Currency = U_OIVL.SCurrency
	WHERE BaseName = N'交货单'
	AND DATEDIFF( MONTH, DocDate, GETDATE( ) ) = 0
	GROUP BY
	    ExchangeRate.Rate,
        U_OIVL.Brand,
        U_OIVL.ItemName
) _FirstDeliveryFrequency ON _FirstDeliveryFrequency.Brand = T.Brand AND _FirstDeliveryFrequency.Modle = T.Modle
/*距今2个月交货单频次*/
LEFT JOIN (
	SELECT
		COUNT(*) AS DeliveryFrequency,
		ItemName AS Modle, Brand,
		SUM(Quantity) AS Quantity, /*销售数量*/
		ABS(SUM(Quantity * SPriceAFVAT) * ExchangeRate.Rate) AS SumSaleMoney /*销售总额*/
	FROM U_OIVL
	LEFT JOIN #ExchangeRate ExchangeRate ON ExchangeRate.Currency = U_OIVL.SCurrency
	WHERE BaseName = N'交货单'
	AND DATEDIFF( MONTH, DocDate, GETDATE( ) ) = 1
	GROUP BY
	    ExchangeRate.Rate,
        U_OIVL.Brand,
        U_OIVL.ItemName
) _SecondDeliveryFrequency ON _SecondDeliveryFrequency.Brand = T.Brand AND _SecondDeliveryFrequency.Modle = T.Modle
/*距今3个月交货单频次*/
LEFT JOIN (
	SELECT
		COUNT(*) AS DeliveryFrequency,
		ItemName AS Modle, Brand,
		SUM(Quantity) AS Quantity, /*销售数量*/
		ABS(SUM(Quantity * SPriceAFVAT) * ExchangeRate.Rate) AS SumSaleMoney /*销售总额*/
	FROM U_OIVL
	LEFT JOIN #ExchangeRate ExchangeRate ON ExchangeRate.Currency = U_OIVL.SCurrency
	WHERE BaseName = N'交货单'
	AND DATEDIFF( MONTH, DocDate, GETDATE( ) ) = 2
	GROUP BY
	    ExchangeRate.Rate,
        U_OIVL.Brand,
        U_OIVL.ItemName
) _ThirdDeliveryFrequency ON _ThirdDeliveryFrequency.Brand = T.Brand AND _ThirdDeliveryFrequency.Modle = T.Modle
/*距今4-12个月交货单频次*/
LEFT JOIN (
	SELECT
		COUNT(*) AS DeliveryFrequency,
		ItemName AS Modle, Brand,
		SUM(Quantity) AS Quantity, /*销售数量*/
		ABS(SUM(Quantity * SPriceAFVAT) * ExchangeRate.Rate) AS SumSaleMoney /*销售总额*/
	FROM U_OIVL
	LEFT JOIN #ExchangeRate ExchangeRate ON ExchangeRate.Currency = U_OIVL.SCurrency
	WHERE BaseName = N'交货单'
        AND DATEDIFF( MONTH, DocDate, GETDATE( ) ) > 2
        AND DATEDIFF( MONTH, DocDate, GETDATE( ) ) < 12
	GROUP BY
	    ExchangeRate.Rate,
        U_OIVL.Brand,
        U_OIVL.ItemName
) _ForthDeliveryFrequency ON _ForthDeliveryFrequency.Brand = T.Brand AND _ForthDeliveryFrequency.Modle = T.Modle
) TT
DROP TABLE #ExchangeRate