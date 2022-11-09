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

/*采购订单*/
SELECT
	ItemName AS Modle,
	Brand,
	SUM(Quantity) AS SumQuantity, /*近一年采购总数*/
	SUM(Quantity * PPriceAFVAT) * PExchangeRate.Rate AS SumMoney /*近一年采购总额*/
FROM U_OIVL
LEFT JOIN #ExchangeRate PExchangeRate ON PExchangeRate.Currency = U_OIVL.PCurrency
WHERE U_OIVL.BaseName = N'采购入库'
AND DATEDIFF( MONTH, DocDate, GETDATE( ) ) < 12
GROUP BY
	PExchangeRate.Rate,
    U_OIVL.Brand,
    U_OIVL.ItemName
ORDER BY SumMoney DESC

/*销售订单*/
SELECT
	ItemName AS Modle,
	Brand,
	SUM(Quantity) AS SumQuantity, /*近一年采购总数*/
	ABS(SUM(Quantity * SPriceAFVAT) * SExchangeRate.Rate) AS SumMoney /*销售总额*/
FROM U_OIVL
LEFT JOIN #ExchangeRate SExchangeRate ON SExchangeRate.Currency = U_OIVL.PCurrency
WHERE U_OIVL.BaseName = N'交货单'
AND DATEDIFF( MONTH, DocDate, GETDATE( ) ) < 12
GROUP BY
	SExchangeRate.Rate,
    U_OIVL.Brand,
    U_OIVL.ItemName
ORDER BY SumMoney DESC

/*销售订单*/
SELECT
	ItemName AS Modle,
	Brand,
	SUM(Quantity) AS SumQuantity, /*近一年采购总数*/
	ABS(SUM(Quantity * SPriceAFVAT) * SExchangeRate.Rate) AS SumMoney /*销售总额*/
FROM U_OIVL
LEFT JOIN #ExchangeRate SExchangeRate ON SExchangeRate.Currency = U_OIVL.SCurrency
WHERE U_OIVL.BaseName = N'交货单'
AND DATEDIFF( MONTH, DocDate, GETDATE( ) ) < 12
GROUP BY
	SExchangeRate.Rate,
    U_OIVL.Brand,
    U_OIVL.ItemName
ORDER BY SumMoney DESC

DROP TABLE #ExchangeRate
