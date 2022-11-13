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

/*08.采购数量*/
/*近一年该品牌、型号的采购数量*/
SELECT
--     COUNT(*)
    T.Brand,
    T.Modle,
    ISNULL(Purchase.SumQuantity, 0) AS SumPurchaseQuantity,
    ROW_NUMBER() OVER(ORDER BY Purchase.SumQuantity DESC) as SumPurchaseQuantityRank /*近一年采购数量排名*/
FROM (
        /*近一年询报价业务所涉及的品牌、型号*/
        SELECT
            U_ICIN1.Modle,
            U_ICIN1.Brand
        FROM
            U_ICIN1
        LEFT JOIN T_ICIN ON U_ICIN1.DocEntry = T_ICIN.DocEntry
        WHERE DATEDIFF(MONTH ,T_ICIN.InquiryDate, GETDATE( )) < 12
        GROUP BY
            U_ICIN1.Modle,
            U_ICIN1.Brand
) T
/*采购数量、采购价格、采购频次*/
LEFT JOIN (
	SELECT
		OIVL.ItemName AS Modle,
		OIVL.Brand,
		SUM(OIVL.Quantity) AS SumQuantity, /*近一年采购总数*/
		SUM(OIVL.Quantity * PPriceAFVAT) AS SumMoney, /*近一年采购总额*/
		SUM(OIVL.Quantity * PPriceAFVAT) / SUM(Quantity) AS AveragePPriceAFVAT, /*近一年平均采购价格*/
		COUNT(*) AS PurchaseFrequency /*近一年采购频次*/
	FROM (
        SELECT
            U_OIVL.ItemName,
            U_OIVL.Quantity,
            U_OIVL.Brand,
            U_OIVL.PPriceAFVAT
        FROM U_OIVL
        WHERE U_OIVL.BaseName = N'采购入库'
        AND DATEDIFF( MONTH, DocDate, GETDATE( ) ) < 12
    ) OIVL
	GROUP BY
        OIVL.Brand,
        OIVL.ItemName
) Purchase ON Purchase.Brand = T.Brand AND Purchase.Modle = T.Modle

DROP TABLE #ExchangeRate
