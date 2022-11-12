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
/*库存排名*/
SELECT
T.Modle,
T.Brand,
/*01.询价频次*/
ISNULL(_FirstEnquiry1.InquiryFrequency, 0) AS InquiryFrequencyFirst1, /*贸易商类型客户距今1个月询价频次*/
ISNULL(_FirstEnquiry2.InquiryFrequency, 0) AS InquiryFrequencyFirst2, /*终端类型客户距今1个月询价频次*/
(ISNULL(_FirstEnquiry1.InquiryFrequency, 0) * 0.7 + ISNULL(_FirstEnquiry2.InquiryFrequency, 0) * 1.5) AS InquiryFrequencyFirst, /*距今1个月询价频次*/
ISNULL(_SecondEnquiry1.InquiryFrequency, 0) AS InquiryFrequencySecond1, /*贸易商类型客户距今2个月询价频次*/
ISNULL(_SecondEnquiry2.InquiryFrequency, 0) AS InquiryFrequencySecond2, /*终端类型客户距今2个月询价频次*/
(ISNULL(_SecondEnquiry1.InquiryFrequency, 0) * 0.7 + ISNULL(_SecondEnquiry2.InquiryFrequency, 0) * 1.5) AS InquiryFrequencySecond, /*距今2个月询价频次*/
ISNULL(_ThirdEnquiry1.InquiryFrequency, 0) AS InquiryFrequencyThird1, /*贸易商类型客户距今3个月询价频次*/
ISNULL(_ThirdEnquiry2.InquiryFrequency, 0) AS InquiryFrequencyThird2, /*终端类型客户距今3个月询价频次*/
(ISNULL(_ThirdEnquiry1.InquiryFrequency, 0) * 0.7 + ISNULL(_ThirdEnquiry2.InquiryFrequency, 0) * 1.5) AS InquiryFrequencyThird, /*距今3个月询价频次*/
ISNULL(_ForthEnquiry1.InquiryFrequency, 0) AS InquiryFrequencyForth1, /*贸易商类型客户距今4-12个月询价频次*/
ISNULL(_ForthEnquiry2.InquiryFrequency, 0) AS InquiryFrequencyForth2, /*终端类型客户距今4-12个月询价频次*/
(ISNULL(_ForthEnquiry1.InquiryFrequency, 0) * 0.7 + ISNULL(_ForthEnquiry2.InquiryFrequency, 0) * 1.5) AS InquiryFrequencyForth, /*距今4-12个月询价频次*/

/*02.询价客户数*/
ISNULL(_FirstEnquiry1.InquiryCustomers, 0) AS InquiryCustomersFirst1, /*贸易商类型客户距今1个月询价客户数*/
ISNULL(_FirstEnquiry2.InquiryCustomers, 0) AS InquiryCustomersFirst2, /*终端类型客户距今1个月询价客户数*/
(ISNULL(_FirstEnquiry1.InquiryCustomers, 0) * 0.7 + ISNULL(_FirstEnquiry2.InquiryCustomers, 0) * 1.5) AS InquiryCustomersFirst, /*距今1个月询价客户数*/
ISNULL(_SecondEnquiry1.InquiryCustomers, 0) AS InquiryCustomersSecond1, /*贸易商类型客户距今2个月询价客户数*/
ISNULL(_SecondEnquiry2.InquiryCustomers, 0) AS InquiryCustomersSecond2, /*终端类型客户距今2个月询价客户数*/
(ISNULL(_SecondEnquiry1.InquiryCustomers, 0) * 0.7 + ISNULL(_SecondEnquiry2.InquiryCustomers, 0) * 1.5) AS InquiryCustomersSecond, /*距今2个月询价客户数*/
ISNULL(_ThirdEnquiry1.InquiryCustomers, 0) AS InquiryCustomersThird1, /*贸易商类型客户距今3个月询价客户数*/
ISNULL(_ThirdEnquiry2.InquiryCustomers, 0) AS InquiryCustomersThird2, /*终端类型客户距今3个月询价客户数*/
(ISNULL(_ThirdEnquiry1.InquiryCustomers, 0) * 0.7 + ISNULL(_ThirdEnquiry2.InquiryCustomers, 0) * 1.5) AS InquiryCustomersThird, /*距今3个月询价客户数*/
ISNULL(_ForthEnquiry1.InquiryCustomers, 0) AS InquiryCustomersForth1, /*贸易商类型客户距今4个月询价客户数*/
ISNULL(_ForthEnquiry2.InquiryCustomers, 0) AS InquiryCustomersForth2, /*终端类型客户距今4个月询价客户数*/
(ISNULL(_ForthEnquiry1.InquiryCustomers, 0) * 0.7 + ISNULL(_ForthEnquiry2.InquiryCustomers, 0) * 1.5) AS InquiryCustomersForth, /*距今4个月询价客户数*/

/*03.订单客户数量*/
ISNULL(_FirstOrderCustomers.OrderCustomers, 0) AS OrderCustomersFirst, /*距今1个月订单客户数量*/
ISNULL(_SecondOrderCustomers.OrderCustomers, 0) AS OrderCustomersSecond, /*距今2个月订单客户数量*/
ISNULL(_ThirdOrderCustomers.OrderCustomers, 0) AS OrderCustomersThird, /*距今3个月订单客户数量*/
ISNULL(_ForthOrderCustomers.OrderCustomers, 0) AS OrderCustomersForth, /*距今4-12个月订单客户数量*/
(
    ISNULL(_FirstDeliveryFrequency.DeliveryFrequency, 0) * 0.1968 +
    ISNULL(_SecondDeliveryFrequency.DeliveryFrequency, 0) * 0.1217 +
    ISNULL(_ThirdDeliveryFrequency.DeliveryFrequency, 0) * 0.1217 +
    ISNULL(_ForthDeliveryFrequency.DeliveryFrequency, 0) * 0.0622
) AS DeliveryFrequency, /*近一年加权订单客户数量*/

/*04.交货单频次*/
ISNULL(_FirstDeliveryFrequency.DeliveryFrequency, 0) AS DeliveryFrequencyFirst, /*距今1个月交货单频次*/
ISNULL(_SecondDeliveryFrequency.DeliveryFrequency, 0) AS DeliveryFrequencySecond, /*距今2个月交货单频次*/
ISNULL(_ThirdDeliveryFrequency.DeliveryFrequency, 0) AS DeliveryFrequencyThird, /*距今3个月交货单频次*/
ISNULL(_ForthDeliveryFrequency.DeliveryFrequency, 0) AS DeliveryFrequencyForth, /*距今4-12个月交货单频次*/
(
    ISNULL(_FirstDeliveryFrequency.DeliveryFrequency, 0) * 0.1968 +
    ISNULL(_SecondDeliveryFrequency.DeliveryFrequency, 0) * 0.1217 +
    ISNULL(_ThirdDeliveryFrequency.DeliveryFrequency, 0) * 0.1217 +
    ISNULL(_ForthDeliveryFrequency.DeliveryFrequency, 0) * 0.0622
) AS DeliveryFrequency, /*近一年订单总数*/

/*05.销售数量*/
ISNULL(_FirstDeliveryFrequency.Quantity, 0) AS DeliveryQuantityFirst, /*距今1个月销售数量*/
ISNULL(_SecondDeliveryFrequency.Quantity, 0) AS DeliveryQuantitySecond, /*距今2个月销售数量*/
ISNULL(_ThirdDeliveryFrequency.Quantity, 0) AS DeliveryQuantityThird, /*距今3个月销售数量*/
ISNULL(_ForthDeliveryFrequency.Quantity, 0) AS DeliveryQuantityForth, /*距今4-12个月销售数量*/
(
    ISNULL(_FirstDeliveryFrequency.Quantity, 0) * 0.1968 +
    ISNULL(_SecondDeliveryFrequency.Quantity, 0) * 0.1217 +
    ISNULL(_ThirdDeliveryFrequency.Quantity, 0) * 0.1217 +
    ISNULL(_ForthDeliveryFrequency.Quantity, 0) * 0.0622
) AS DeliveryQuantity, /*近一年销售总数*/

/*06.平均利润率*/
IIF(
    Purchase.SumMoney IS NOT NULL AND Purchase.SumMoney != 0,
    (
        ISNULL(_FirstDeliveryFrequency.SumSaleMoney, 0) + /*距今1个月销售总额*/
        ISNULL(_SecondDeliveryFrequency.SumSaleMoney, 0) + /*距今2个月销售总额*/
        ISNULL(_ThirdDeliveryFrequency.SumSaleMoney, 0) + /*距今3个月销售总额*/
        ISNULL(_ForthDeliveryFrequency.SumSaleMoney, 0) - /*距今4-12个销售总额*/
        ISNULL(Purchase.SumMoney, 0) /*近一年采购总额*/
    ) / Purchase.SumMoney,
    0
) AS AverageProfit /*近一年平均利润率*/,

/*07.采购价格*/
ISNULL(Purchase.AveragePPriceAFVAT, 0) AS AveragePPriceAFVAT,
ROW_NUMBER() OVER(ORDER BY Purchase.AveragePPriceAFVAT DESC) as AveragePPriceAFVATRank, /*近一年采购价格排名*/

/*08.采购数量*/
ISNULL(Purchase.SumQuantity, 0) AS SumPurchaseQuantity, /*近一年采购总数*/
ROW_NUMBER() OVER(ORDER BY Purchase.SumQuantity DESC) as SumPurchaseQuantityRank, /*近一年采购数量排名*/

/*09.采购频次*/
ISNULL(Purchase.PurchaseFrequency, 0) AS PurchaseFrequency, /*近一年采购频次总数*/
ROW_NUMBER() OVER(ORDER BY Purchase.PurchaseFrequency DESC) as PurchaseFrequencyRank, /*近一年采购频次排名*/

/*10.销售额*/ /***************************汇率使用当前最近一次汇率**************************/
ISNULL(_FirstDeliveryFrequency.SumSaleMoney, 0) AS SumSaleMoneyFirst, /*距今1个月销售总额*/
ISNULL(_SecondDeliveryFrequency.SumSaleMoney, 0) AS SumSaleMoneySecond, /*距今2个月销售总额*/
ISNULL(_ThirdDeliveryFrequency.SumSaleMoney, 0) AS SumSaleMoneyThird, /*距今3个月销售总额*/
ISNULL(_ForthDeliveryFrequency.SumSaleMoney, 0) AS SumSaleMoneyForth, /*距今4-12个销售总额*/

/*11.采购总额*/
ISNULL(Purchase.SumMoney, 0) AS SumPurchaseMoney, /*近一年采购总额*/
ROW_NUMBER() OVER(ORDER BY Purchase.SumMoney DESC) as SumPurchaseMoneyRank /*近一年销售总额排名*/

/*12.品牌得分*/

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
/*贸易商类型客户距今一个月询价频次，询价客户数*/
LEFT JOIN (
SELECT
	U_ICIN1.Brand,
	U_ICIN1.Modle,
	COUNT ( * ) AS InquiryFrequency,  /*询价频次*/
	COUNT ( T_ICIN.CardName ) AS InquiryCustomers /*询价客户数*/
FROM
	U_ICIN1
	LEFT JOIN T_ICIN ON T_ICIN.DocEntry = U_ICIN1.DocEntry
WHERE DATEDIFF( MONTH, T_ICIN.InquiryDate, GETDATE( ) ) = 0
AND T_ICIN.U_CusGroupCode IN (N'关系型贸易商', N'一般贸易商', N'其它')
GROUP BY
	U_ICIN1.Brand,
	U_ICIN1.Modle
) _FirstEnquiry1 ON _FirstEnquiry1.Modle = T.Modle AND _FirstEnquiry1.Brand = T.Brand
/*终端类型客户距今一个月询价频次，询价客户数*/
LEFT JOIN (
SELECT
	U_ICIN1.Brand,
	U_ICIN1.Modle,
	COUNT ( * ) AS InquiryFrequency,  /*询价频次*/
	COUNT ( T_ICIN.CardName ) AS InquiryCustomers /*询价客户数*/
FROM
	U_ICIN1
	LEFT JOIN T_ICIN ON T_ICIN.DocEntry = U_ICIN1.DocEntry
WHERE DATEDIFF( MONTH, T_ICIN.InquiryDate, GETDATE( ) ) = 0
AND T_ICIN.U_CusGroupCode IN ('OEM/EMS', N'终端用户')
GROUP BY
	U_ICIN1.Brand,
	U_ICIN1.Modle
) _FirstEnquiry2 ON _FirstEnquiry2.Modle = T.Modle AND _FirstEnquiry2.Brand = T.Brand


/*贸易商类型客户距今两个月询价频次，询价客户数*/
LEFT JOIN (
SELECT
	U_ICIN1.Brand,
	U_ICIN1.Modle,
	COUNT ( * ) AS InquiryFrequency,  /*询价频次*/
	COUNT ( T_ICIN.CardName ) AS InquiryCustomers /*询价客户数*/
FROM
	U_ICIN1
	LEFT JOIN T_ICIN ON T_ICIN.DocEntry = U_ICIN1.DocEntry
WHERE DATEDIFF( MONTH, T_ICIN.InquiryDate, GETDATE( ) ) = 1
AND T_ICIN.U_CusGroupCode IN (N'关系型贸易商', N'一般贸易商', N'其它')
GROUP BY
	U_ICIN1.Brand,
	U_ICIN1.Modle
) _SecondEnquiry1 ON _SecondEnquiry1.Modle = T.Modle AND _SecondEnquiry1.Brand = T.Brand
/*终端类型客户距今两个月询价频次，询价客户数*/
LEFT JOIN (
SELECT
	U_ICIN1.Brand,
	U_ICIN1.Modle,
	COUNT ( * ) AS InquiryFrequency,  /*询价频次*/
	COUNT ( T_ICIN.CardName ) AS InquiryCustomers /*询价客户数*/
FROM
	U_ICIN1
	LEFT JOIN T_ICIN ON T_ICIN.DocEntry = U_ICIN1.DocEntry
WHERE DATEDIFF( MONTH, T_ICIN.InquiryDate, GETDATE( ) ) = 1
AND T_ICIN.U_CusGroupCode IN ('OEM/EMS', N'终端用户')
GROUP BY
	U_ICIN1.Brand,
	U_ICIN1.Modle
) _SecondEnquiry2 ON _SecondEnquiry2.Modle = T.Modle AND _SecondEnquiry2.Brand = T.Brand

/*贸易商类型客户距今三个月询价频次，询价客户数*/
LEFT JOIN (
SELECT
	U_ICIN1.Brand,
	U_ICIN1.Modle,
	COUNT ( * ) AS InquiryFrequency,  /*询价频次*/
	COUNT ( T_ICIN.CardName ) AS InquiryCustomers /*询价客户数*/
FROM
	U_ICIN1
	LEFT JOIN T_ICIN ON T_ICIN.DocEntry = U_ICIN1.DocEntry
WHERE DATEDIFF( MONTH, T_ICIN.InquiryDate, GETDATE( ) ) = 2
AND T_ICIN.U_CusGroupCode IN (N'关系型贸易商', N'一般贸易商', N'其它')
GROUP BY
	U_ICIN1.Brand,
	U_ICIN1.Modle
) _ThirdEnquiry1 ON _ThirdEnquiry1.Modle = T.Modle AND _ThirdEnquiry1.Brand = T.Brand
/*终端类型客户距今三个月询价频次，询价客户数*/
LEFT JOIN (
SELECT
	U_ICIN1.Brand,
	U_ICIN1.Modle,
	COUNT ( * ) AS InquiryFrequency,  /*询价频次*/
	COUNT ( T_ICIN.CardName ) AS InquiryCustomers /*询价客户数*/
FROM
	U_ICIN1
	LEFT JOIN T_ICIN ON T_ICIN.DocEntry = U_ICIN1.DocEntry
WHERE DATEDIFF( MONTH, T_ICIN.InquiryDate, GETDATE( ) ) = 2
AND T_ICIN.U_CusGroupCode IN ('OEM/EMS', N'终端用户')
GROUP BY
	U_ICIN1.Brand,
	U_ICIN1.Modle
) _ThirdEnquiry2 ON _ThirdEnquiry2.Modle = T.Modle AND _ThirdEnquiry2.Brand = T.Brand

/*贸易商类型客户距今4-12个月询价频次，询价客户数*/
LEFT JOIN (
SELECT
	U_ICIN1.Brand,
	U_ICIN1.Modle,
	COUNT ( * ) AS InquiryFrequency,  /*询价频次*/
	COUNT ( T_ICIN.CardName ) AS InquiryCustomers /*询价客户数*/
FROM
	U_ICIN1
	LEFT JOIN T_ICIN ON T_ICIN.DocEntry = U_ICIN1.DocEntry
WHERE DATEDIFF( MONTH, T_ICIN.InquiryDate, GETDATE( ) ) > 2
AND DATEDIFF( MONTH, T_ICIN.InquiryDate, GETDATE( ) ) < 12
AND T_ICIN.U_CusGroupCode IN (N'关系型贸易商', N'一般贸易商', N'其它')
GROUP BY
	U_ICIN1.Brand,
	U_ICIN1.Modle
) _ForthEnquiry1 ON _ForthEnquiry1.Modle = T.Modle AND _ForthEnquiry1.Brand = T.Brand
/*终端类型客户距今4-12个月询价频次，询价客户数*/
LEFT JOIN (
SELECT
	U_ICIN1.Brand,
	U_ICIN1.Modle,
	COUNT ( * ) AS InquiryFrequency,  /*询价频次*/
	COUNT ( T_ICIN.CardName ) AS InquiryCustomers /*询价客户数*/
FROM
	U_ICIN1
	LEFT JOIN T_ICIN ON T_ICIN.DocEntry = U_ICIN1.DocEntry
WHERE DATEDIFF( MONTH, T_ICIN.InquiryDate, GETDATE( ) ) > 2
AND DATEDIFF( MONTH, T_ICIN.InquiryDate, GETDATE( ) ) < 12
AND T_ICIN.U_CusGroupCode IN ('OEM/EMS', N'终端用户')
GROUP BY
	U_ICIN1.Brand,
	U_ICIN1.Modle
) _ForthEnquiry2 ON _ForthEnquiry2.Modle = T.Modle AND _ForthEnquiry2.Brand = T.Brand

/*距今1个月订单客户数量*/
LEFT JOIN (
	SELECT COUNT(*) AS OrderCustomers, ItemName AS Modle, Brand
	FROM U_OIVL
	WHERE BaseName IN (N'采购入库', N'交货单')
	AND DATEDIFF( MONTH, DocDate, GETDATE( ) ) = 0
	GROUP BY
	U_OIVL.Brand,
	U_OIVL.ItemName
) _FirstOrderCustomers ON _FirstOrderCustomers.Brand = T.Brand AND _FirstOrderCustomers.Modle = T.Modle
/*距今2个月订单客户数量*/
LEFT JOIN (
	SELECT COUNT(*) AS OrderCustomers, ItemName AS Modle, Brand
	FROM U_OIVL
	WHERE BaseName IN (N'采购入库', N'交货单')
	AND DATEDIFF( MONTH, DocDate, GETDATE( ) ) = 1
	GROUP BY
	U_OIVL.Brand,
	U_OIVL.ItemName
) _SecondOrderCustomers ON _SecondOrderCustomers.Brand = T.Brand AND _SecondOrderCustomers.Modle = T.Modle
/*距今3个月订单客户数量*/
LEFT JOIN (
	SELECT COUNT(*) AS OrderCustomers, ItemName AS Modle, Brand
	FROM U_OIVL
	WHERE BaseName IN (N'采购入库', N'交货单')
	AND DATEDIFF( MONTH, DocDate, GETDATE( ) ) = 2
	GROUP BY
	U_OIVL.Brand,
	U_OIVL.ItemName
) _ThirdOrderCustomers ON _ThirdOrderCustomers.Brand = T.Brand AND _ThirdOrderCustomers.Modle = T.Modle
/*距今3个月订单客户数量*/
LEFT JOIN (
	SELECT COUNT(*) AS OrderCustomers, ItemName AS Modle, Brand
	FROM U_OIVL
	WHERE BaseName IN (N'采购入库', N'交货单')
	AND DATEDIFF( MONTH, DocDate, GETDATE( ) ) > 2
	AND DATEDIFF( MONTH, DocDate, GETDATE( ) ) < 12
	GROUP BY
	U_OIVL.Brand,
	U_OIVL.ItemName
) _ForthOrderCustomers ON _ForthOrderCustomers.Brand = T.Brand AND _ForthOrderCustomers.Modle = T.Modle

/*距今1个月交货单频次*/
LEFT JOIN (
        SELECT
            COUNT(*) AS DeliveryFrequency,
            OIVL.Brand,
            OIVL.ItemName AS Modle,
            SUM(Quantity) AS Quantity, /*销售数量*/
            ABS(SUM(Quantity * SPriceAFVAT)) AS SumSaleMoney /*销售总额*/
        FROM (
            SELECT
                U_OIVL.ItemName,
                U_OIVL.Brand,
                ABS(U_OIVL.Quantity) AS Quantity,
                U_OIVL.SPriceAFVAT * ExchangeRate.Rate AS SPriceAFVAT
            FROM U_OIVL
            LEFT JOIN #ExchangeRate ExchangeRate ON ExchangeRate.Currency = U_OIVL.SCurrency
            WHERE BaseName = N'交货单'
            AND DATEDIFF( MONTH, DocDate, GETDATE( ) ) = 0
        ) OIVL
        GROUP BY
            OIVL.Brand,
            OIVL.ItemName
) _FirstDeliveryFrequency ON _FirstDeliveryFrequency.Brand = T.Brand AND _FirstDeliveryFrequency.Modle = T.Modle
/*距今2个月交货单频次*/
LEFT JOIN (
        SELECT
            COUNT(*) AS DeliveryFrequency,
            OIVL.Brand,
            OIVL.ItemName AS Modle,
            SUM(Quantity) AS Quantity, /*销售数量*/
            ABS(SUM(Quantity * SPriceAFVAT)) AS SumSaleMoney /*销售总额*/
        FROM (
            SELECT
                U_OIVL.ItemName,
                U_OIVL.Brand,
                ABS(U_OIVL.Quantity) AS Quantity,
                U_OIVL.SPriceAFVAT * ExchangeRate.Rate AS SPriceAFVAT
            FROM U_OIVL
            LEFT JOIN #ExchangeRate ExchangeRate ON ExchangeRate.Currency = U_OIVL.SCurrency
            WHERE BaseName = N'交货单'
            AND DATEDIFF( MONTH, DocDate, GETDATE( ) ) = 1
        ) OIVL
        GROUP BY
            OIVL.Brand,
            OIVL.ItemName
) _SecondDeliveryFrequency ON _SecondDeliveryFrequency.Brand = T.Brand AND _SecondDeliveryFrequency.Modle = T.Modle
/*距今3个月交货单频次*/
LEFT JOIN (
        SELECT
            COUNT(*) AS DeliveryFrequency,
            OIVL.Brand,
            OIVL.ItemName AS Modle,
            SUM(Quantity) AS Quantity, /*销售数量*/
            ABS(SUM(Quantity * SPriceAFVAT)) AS SumSaleMoney /*销售总额*/
        FROM (
            SELECT
                U_OIVL.ItemName,
                U_OIVL.Brand,
                ABS(U_OIVL.Quantity) AS Quantity,
                U_OIVL.SPriceAFVAT * ExchangeRate.Rate AS SPriceAFVAT
            FROM U_OIVL
            LEFT JOIN #ExchangeRate ExchangeRate ON ExchangeRate.Currency = U_OIVL.SCurrency
            WHERE BaseName = N'交货单'
            AND DATEDIFF( MONTH, DocDate, GETDATE( ) ) = 2
        ) OIVL
        GROUP BY
            OIVL.Brand,
            OIVL.ItemName
) _ThirdDeliveryFrequency ON _ThirdDeliveryFrequency.Brand = T.Brand AND _ThirdDeliveryFrequency.Modle = T.Modle
/*距今4-12个月交货单频次*/
LEFT JOIN (
        SELECT
            COUNT(*) AS DeliveryFrequency,
            OIVL.Brand,
            OIVL.ItemName AS Modle,
            SUM(Quantity) AS Quantity, /*销售数量*/
            ABS(SUM(Quantity * SPriceAFVAT)) AS SumSaleMoney /*销售总额*/
        FROM (
            SELECT
                U_OIVL.ItemName,
                U_OIVL.Brand,
                ABS(U_OIVL.Quantity) AS Quantity,
                U_OIVL.SPriceAFVAT * ExchangeRate.Rate AS SPriceAFVAT
            FROM U_OIVL
            LEFT JOIN #ExchangeRate ExchangeRate ON ExchangeRate.Currency = U_OIVL.SCurrency
            WHERE BaseName = N'交货单'
            AND DATEDIFF( MONTH, DocDate, GETDATE( ) ) > 2
            AND DATEDIFF( MONTH, DocDate, GETDATE( ) ) < 12
        ) OIVL
        GROUP BY
            OIVL.Brand,
            OIVL.ItemName
) _ForthDeliveryFrequency ON _ForthDeliveryFrequency.Brand = T.Brand AND _ForthDeliveryFrequency.Modle = T.Modle

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