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


SELECT
    ISNULL(_FirstDeliveryFrequency.DeliveryFrequency, 0) AS DeliveryFrequencyFirst, /*距今1个月交货单频次*/
    ISNULL(_SecondDeliveryFrequency.DeliveryFrequency, 0) AS DeliveryFrequencySecond, /*距今2个月交货单频次*/
    ISNULL(_ThirdDeliveryFrequency.DeliveryFrequency, 0) AS DeliveryFrequencyThird, /*距今3个月交货单频次*/
    ISNULL(_ForthDeliveryFrequency.DeliveryFrequency, 0) AS DeliveryFrequencyForth, /*距今4-12个月交货单频次*/
    (
        ISNULL(_FirstDeliveryFrequency.DeliveryFrequency, 0) * 0.1968 +
        ISNULL(_SecondDeliveryFrequency.DeliveryFrequency, 0) * 0.1217 +
        ISNULL(_ThirdDeliveryFrequency.DeliveryFrequency, 0) * 0.1217 +
        ISNULL(_ForthDeliveryFrequency.DeliveryFrequency, 0) * 0.0622
    ) AS DeliveryFrequency /*近一年加权订单总数*/
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
