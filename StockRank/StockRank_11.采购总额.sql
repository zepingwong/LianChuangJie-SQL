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


/*11.采购总额*/
SELECT
    T.Brand,
    T.Modle,
    ISNULL(Purchase.SumMoney, 0) AS SumPurchaseMoney, /*近一年采购总额*/
    ROW_NUMBER() OVER(ORDER BY Purchase.SumMoney DESC) as SumPurchaseMoneyRank /*近一年采购总额排名*/
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
/*采购数量、采购价格、采购频次、平均利润率*/
LEFT JOIN (
	SELECT
		OIVL.ItemName AS Modle,
		OIVL.Brand,
		SUM(OIVL.Quantity) AS SumQuantity, /*近一年采购总数*/
		SUM(OIVL.Quantity * PPriceAFVAT) AS SumMoney, /*近一年采购总额*/
		SUM(OIVL.Quantity * PPriceAFVAT) / SUM(Quantity) AS AveragePPriceAFVAT, /*近一年平均采购价格*/
		SUM(
		    OIVL.Quantity * (OIVL.SPriceAFVAT - OIVL.PPriceAFVAT)
		) / SUM(OIVL.Quantity) AS AverageProfit,
		COUNT(*) AS PurchaseFrequency
	FROM (
        SELECT
            U_OIVL.ItemName,
            U_OIVL.Quantity,
            U_OIVL.Brand,
            U_OIVL.SPriceAFVAT * SExchangeRate.Rate AS SPriceAFVAT,
            U_OIVL.PPriceAFVAT * PExchangeRate.Rate AS PPriceAFVAT
        FROM U_OIVL
        LEFT JOIN #ExchangeRate PExchangeRate ON PExchangeRate.Currency = U_OIVL.PCurrency
        LEFT JOIN #ExchangeRate SExchangeRate ON SExchangeRate.Currency = U_OIVL.SCurrency
        WHERE U_OIVL.BaseName = N'采购入库'
        AND DATEDIFF( MONTH, DocDate, GETDATE( ) ) < 12
    ) OIVL
	GROUP BY
        OIVL.Brand,
        OIVL.ItemName
) Purchase ON Purchase.Brand = T.Brand AND Purchase.Modle = T.Modle

DROP TABLE #ExchangeRate