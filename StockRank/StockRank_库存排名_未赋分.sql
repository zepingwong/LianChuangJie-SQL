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
DROP TABLE U_StockRank
SELECT
    -- COUNT(*)
    InitRank.Brand,
    InitRank.Modle,
    InitRank.InquiryDemandQty1, /*近三个月贸易商类型客户询价数量*/
    InitRank.InquiryDemandQty2, /*近三个月终端类型客户询价数量*/
    InitRank.InquiryFrequency, /*01.近一年加权询价频次*/
    ROW_NUMBER() OVER(ORDER BY InitRank.InquiryFrequency DESC) as InquiryFrequencyRank, /*加权询价频次排名*/
    NULL AS InquiryFrequencyScore, /*加权询价频次得分*/
    InitRank.InquiryFrequencyFirst,
    InitRank.InquiryFrequencySecond,
    InitRank.InquiryFrequencyThird,
    InitRank.InquiryFrequencyForth,
    InitRank.InquiryCustomers, /*02.加权询价客户数*/
    ROW_NUMBER() OVER(ORDER BY InitRank.InquiryCustomers DESC) as InquiryCustomersRank, /*加权询价客户数排名*/
    NULL AS InquiryCustomersScore, /*加权询价客户数得分*/
    InitRank.InquiryCustomersFirst,
    InitRank.InquiryCustomersSecond,
    InitRank.InquiryCustomersThird,
    InitRank.InquiryCustomersForth,
    InitRank.OrderCustomers, /*03.近一年加权订单客户数量*/
    ROW_NUMBER() OVER(ORDER BY InitRank.OrderCustomers DESC) as OrderCustomersRank, /*加权订单客户数量排名*/
    NULL AS OrderCustomersScore, /*加权订单客户数量得分*/
    InitRank.OrderCustomersFirst,
    InitRank.OrderCustomersSecond,
    InitRank.OrderCustomersThird,
    InitRank.OrderCustomersForth,
    InitRank.DeliveryFrequency, /*04.近一年加权交货单频次*/
    ROW_NUMBER() OVER(ORDER BY InitRank.DeliveryFrequency DESC) as DeliveryFrequencyRank, /*近一年加权交货单频次排名*/
    NULL AS DeliveryFrequencyScore, /*加权交货单频次得分*/
    InitRank.DeliveryFrequencyFirst,
    InitRank.DeliveryFrequencySecond,
    InitRank.DeliveryFrequencyThird,
    InitRank.DeliveryFrequencyForth,
    InitRank.DeliveryQuantity, /*05.近一年加权销售总数*/
    ROW_NUMBER() OVER(ORDER BY InitRank.DeliveryQuantity DESC) as DeliveryQuantityRank, /*近一年加权销售总数排名*/
    NULL AS DeliveryQuantityScore, /*加权销售总数得分*/
    InitRank.DeliveryQuantityFirst,
    InitRank.DeliveryQuantitySecond,
    InitRank.DeliveryQuantityThird,
    InitRank.DeliveryQuantityForth,
    InitRank.AverageProfit, /*06.近一年平均利润率*/
    ROW_NUMBER() OVER(ORDER BY InitRank.AverageProfit DESC) as AverageProfitRank, /*近一年平均利润率排名*/
    NULL AS AverageProfitScore, /*近一年平均利润率得分*/
    InitRank.AveragePPriceAFVAT, /*07.近一年平均采购价格*/
    InitRank.AveragePPriceAFVATRank, /*近一年采购价格排名*/
    NULL AS AveragePPriceAFVATScore, /*采购价格排名得分*/
    InitRank.SumPurchaseQuantity, /*08.近一年采购数量*/
    InitRank.SumPurchaseQuantityRank, /*近一年采购数量排名*/
    NULL AS SumPurchaseQuantityScore, /*采购数量排名得分*/
    InitRank.PurchaseFrequency, /*09.近一年采购总频次*/
    InitRank.PurchaseFrequencyRank, /*近一年采购总频次排名*/
    NULL AS PurchaseFrequencyScore, /*采购总频次得分*/
    InitRank.SumSaleMoney, /*10.近一年销售总额*/
    ROW_NUMBER() OVER(ORDER BY InitRank.SumSaleMoney DESC) as SumSaleMoneyRank, /*近一年销售总额排名*/
    NULL AS SumSaleMoneyScore, /*销售总额得分*/
    InitRank.SumSaleMoneyFirst,
    InitRank.SumSaleMoneySecond,
    InitRank.SumSaleMoneyThird,
    InitRank.SumSaleMoneyForth,
    InitRank.SumPurchaseMoney, /*11.近一年采购总额*/
    InitRank.SumPurchaseMoneyRank, /*近一年采购总额排名*/
    NULL AS SumPurchaseMoneyScore, /*采购总额得分*/
    /*12.品牌得分*/
    ROW_NUMBER() OVER(ORDER BY BrandSumPurchaseMoney DESC) as BrandSumPurchaseMoneyRank, /*品牌采购额排名*/
    NULL AS BrandSumPurchaseMoneyScore,
    ISNULL(BrandSumPurchaseMoney, 0) AS BrandSumPurchaseMoney,
    ROW_NUMBER() OVER(ORDER BY BrandSumPurchaseQuantity DESC) as BrandSumPurchaseQuantityRank, /*品牌采购数量排名*/
    NULL AS BrandSumPurchaseQuantityScore,
    ISNULL(BrandSumPurchaseQuantity, 0) AS BrandSumPurchaseQuantity,
    ROW_NUMBER() OVER(ORDER BY BrandSumPurchaseSuppliers DESC) as BrandSumPurchaseSuppliersRank, /*品牌供应商数量排名*/
    NULL AS BrandSumPurchaseSuppliersScore,
    ISNULL(BrandSumPurchaseSuppliers, 0) AS BrandSumPurchaseSuppliers,
    ROW_NUMBER() OVER(ORDER BY BrandSumSaleCustomers DESC) as BrandSumSaleCustomersRank, /*品牌客户数量排名*/
    NULL AS BrandSumSaleCustomersScore,
    ISNULL(BrandSumSaleCustomers, 0) AS BrandSumSaleCustomers,
    ROW_NUMBER() OVER(ORDER BY BrandModleCount DESC) as BrandModleCountRank, /*品牌所属型号数量排名*/
    NULL AS BrandModleCountScore,
    ISNULL(BrandModleCount, 0) AS BrandModleCount,
    NULL AS BrandScore, /*品牌*/
    NULL AS TotalScore /*总分*/
    INTO U_StockRank
FROM (
    SELECT
    T.Modle,
    T.Brand,
    (
        ISNULL(_FirstEnquiry1.InquiryDemandQty, 0) +
        ISNULL(_SecondEnquiry1.InquiryDemandQty, 0) +
        ISNULL(_ThirdEnquiry1.InquiryDemandQty, 0)
    ) AS InquiryDemandQty1, /*近三个月贸易商类型客户询价数量*/
    (
        ISNULL(_FirstEnquiry2.InquiryDemandQty, 0) +
        ISNULL(_SecondEnquiry2.InquiryDemandQty, 0) +
        ISNULL(_ThirdEnquiry2.InquiryDemandQty, 0)
    ) AS InquiryDemandQty2, /*近三个月终端类型客户询价数量*/
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
    (
        (ISNULL(_ForthEnquiry1.InquiryFrequency, 0) * 0.7 + ISNULL(_ForthEnquiry2.InquiryFrequency, 0) * 1.5) * 0.0622 +
        (ISNULL(_ThirdEnquiry1.InquiryFrequency, 0) * 0.7 + ISNULL(_ThirdEnquiry2.InquiryFrequency, 0) * 1.5) * 0.1217 +
        (ISNULL(_SecondEnquiry1.InquiryFrequency, 0) * 0.7 + ISNULL(_SecondEnquiry2.InquiryFrequency, 0) * 1.5) * 0.1217 +
        (ISNULL(_FirstEnquiry1.InquiryFrequency, 0) * 0.7 + ISNULL(_FirstEnquiry2.InquiryFrequency, 0) * 1.5) * 0.1968
    ) AS InquiryFrequency, /*近一年加权询价频次*/

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
    (
        (ISNULL(_ForthEnquiry1.InquiryCustomers, 0) * 0.7 + ISNULL(_ForthEnquiry2.InquiryCustomers, 0) * 1.5) * 0.0622 +
        (ISNULL(_ThirdEnquiry1.InquiryCustomers, 0) * 0.7 + ISNULL(_ThirdEnquiry2.InquiryCustomers, 0) * 1.5) * 0.1217 +
        (ISNULL(_SecondEnquiry1.InquiryCustomers, 0) * 0.7 + ISNULL(_SecondEnquiry2.InquiryCustomers, 0) * 1.5) * 0.1217 +
        (ISNULL(_FirstEnquiry1.InquiryCustomers, 0) * 0.7 + ISNULL(_FirstEnquiry2.InquiryCustomers, 0) * 1.5) * 0.1968
    ) AS InquiryCustomers, /*近一年加权询价客户数*/

    /*03.订单客户数量*/
    ISNULL(_FirstOrderCustomers.OrderCustomers, 0) AS OrderCustomersFirst, /*距今1个月订单客户数量*/
    ISNULL(_SecondOrderCustomers.OrderCustomers, 0) AS OrderCustomersSecond, /*距今2个月订单客户数量*/
    ISNULL(_ThirdOrderCustomers.OrderCustomers, 0) AS OrderCustomersThird, /*距今3个月订单客户数量*/
    ISNULL(_ForthOrderCustomers.OrderCustomers, 0) AS OrderCustomersForth, /*距今4-12个月订单客户数量*/
    (
        ISNULL(_FirstOrderCustomers.OrderCustomers, 0) * 0.1968 +
        ISNULL(_SecondOrderCustomers.OrderCustomers, 0) * 0.1217 +
        ISNULL(_ThirdOrderCustomers.OrderCustomers, 0) * 0.1217 +
        ISNULL(_ForthOrderCustomers.OrderCustomers, 0) * 0.0622
    ) AS OrderCustomers, /*近一年加权订单客户数量*/

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
    ) AS DeliveryFrequency, /*近一年加权订单总数*/

    /*05.销售数量*/
    ISNULL(_FirstOrderCustomers.SumQuantity, 0) AS DeliveryQuantityFirst, /*距今1个月销售数量*/
    ISNULL(_SecondOrderCustomers.SumQuantity, 0) AS DeliveryQuantitySecond, /*距今2个月销售数量*/
    ISNULL(_ThirdOrderCustomers.SumQuantity, 0) AS DeliveryQuantityThird, /*距今3个月销售数量*/
    ISNULL(_ForthOrderCustomers.SumQuantity, 0) AS DeliveryQuantityForth, /*距今4-12个月销售数量*/
    (
        ISNULL(_FirstOrderCustomers.SumQuantity, 0) * 0.1968 +
        ISNULL(_SecondOrderCustomers.SumQuantity, 0) * 0.1217 +
        ISNULL(_ThirdOrderCustomers.SumQuantity, 0) * 0.1217 +
        ISNULL(_ForthOrderCustomers.SumQuantity, 0) * 0.0622
    ) AS DeliveryQuantity, /*近一年加权销售总数*/

    /*06.平均利润率*/
    IIF(
        Purchase.SumMoney IS NOT NULL AND Purchase.SumMoney != 0,
        (
            ISNULL(_FirstOrderCustomers.SumMoney, 0) + /*距今1个月销售总额*/
            ISNULL(_SecondOrderCustomers.SumMoney, 0) + /*距今2个月销售总额*/
            ISNULL(_ThirdOrderCustomers.SumMoney, 0) + /*距今3个月销售总额*/
            ISNULL(_ForthOrderCustomers.SumMoney, 0) - /*距今4-12个销售总额*/
            ISNULL(Purchase.SumMoney, 0) /*近一年采购总额*/
        ) / Purchase.SumMoney,
        0
    ) AS AverageProfit /*近一年平均利润率*/,

    /*07.采购价格*/
    ISNULL(Purchase.AveragePPriceAFVAT, 0) AS AveragePPriceAFVAT, /*近一年平均采购价格*/
    ROW_NUMBER() OVER(ORDER BY Purchase.AveragePPriceAFVAT DESC) as AveragePPriceAFVATRank, /*近一年采购价格排名*/

    /*08.采购数量*/
    ISNULL(Purchase.SumQuantity, 0) AS SumPurchaseQuantity, /*近一年采购总数*/
    ROW_NUMBER() OVER(ORDER BY Purchase.SumQuantity DESC) as SumPurchaseQuantityRank, /*近一年采购数量排名*/

    /*09.采购频次*/
    ISNULL(Purchase.PurchaseFrequency, 0) AS PurchaseFrequency, /*近一年采购频次总数*/
    ROW_NUMBER() OVER(ORDER BY Purchase.PurchaseFrequency DESC) as PurchaseFrequencyRank, /*近一年采购频次排名*/

    /*10.销售额*/
    ISNULL(_FirstOrderCustomers.SumMoney, 0) AS SumSaleMoneyFirst, /*距今1个月销售总额*/
    ISNULL(_SecondOrderCustomers.SumMoney, 0) AS SumSaleMoneySecond, /*距今2个月销售总额*/
    ISNULL(_ThirdOrderCustomers.SumMoney, 0) AS SumSaleMoneyThird, /*距今3个月销售总额*/
    ISNULL(_ForthOrderCustomers.SumMoney, 0) AS SumSaleMoneyForth, /*距今4-12个销售总额*/
    (
        ISNULL(_FirstOrderCustomers.SumMoney, 0) * 0.0622 +
        ISNULL(_SecondOrderCustomers.SumMoney, 0) * 0.1217 +
        ISNULL(_ThirdOrderCustomers.SumMoney, 0) * 0.1217 +
        ISNULL(_ForthOrderCustomers.SumMoney, 0) * 0.1968
    ) AS SumSaleMoney, /*近一年加权销售总额*/

    /*11.采购总额*/
    ISNULL(Purchase.SumMoney, 0) AS SumPurchaseMoney, /*近一年采购总额*/
    ROW_NUMBER() OVER(ORDER BY Purchase.SumMoney DESC) as SumPurchaseMoneyRank, /*近一年销售总额排名*/

    /*12.品牌得分*/
    ISNULL(BrandPurchase.SumMoney, 0) AS BrandSumPurchaseMoney, /*品牌总采购额*/
    ISNULL(BrandPurchase.SumQuantity, 0) AS BrandSumPurchaseQuantity, /*品牌总采购数量*/
    ISNULL(BrandPurchase.Suppliers, 0) AS BrandSumPurchaseSuppliers, /*品牌供应商数量*/
    ISNULL(BrandSale.Customers, 0) AS BrandSumSaleCustomers, /*销售客户数量*/
    ISNULL(BrandModle.ModleCount, 0) AS BrandModleCount /*所属型号数量*/

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
    /*贸易商类型客户距今一个月询价频次，询价客户数*/
    LEFT JOIN (
    SELECT
        U_ICIN1.Brand,
        U_ICIN1.Modle,
        SUM(U_ICIN1.DemandQty) AS InquiryDemandQty,
        COUNT ( * ) AS InquiryFrequency,  /*询价频次*/
        COUNT (DISTINCT  T_ICIN.CardName ) AS InquiryCustomers /*询价客户数*/
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
        SUM(U_ICIN1.DemandQty) AS InquiryDemandQty,
        COUNT ( * ) AS InquiryFrequency,  /*询价频次*/
        COUNT (DISTINCT  T_ICIN.CardName ) AS InquiryCustomers /*询价客户数*/
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
        SUM(U_ICIN1.DemandQty) AS InquiryDemandQty,
        COUNT ( * ) AS InquiryFrequency,  /*询价频次*/
        COUNT (DISTINCT  T_ICIN.CardName ) AS InquiryCustomers /*询价客户数*/
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
        SUM(U_ICIN1.DemandQty) AS InquiryDemandQty,
        COUNT ( * ) AS InquiryFrequency,  /*询价频次*/
        COUNT (DISTINCT  T_ICIN.CardName ) AS InquiryCustomers /*询价客户数*/
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
        SUM(U_ICIN1.DemandQty) AS InquiryDemandQty,
        COUNT ( * ) AS InquiryFrequency,  /*询价频次*/
        COUNT (DISTINCT  T_ICIN.CardName ) AS InquiryCustomers /*询价客户数*/
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
        SUM(U_ICIN1.DemandQty) AS InquiryDemandQty,
        COUNT ( * ) AS InquiryFrequency,  /*询价频次*/
        COUNT (DISTINCT  T_ICIN.CardName ) AS InquiryCustomers /*询价客户数*/
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
        SUM(U_ICIN1.DemandQty) AS InquiryDemandQty,
        COUNT ( * ) AS InquiryFrequency,  /*询价频次*/
        COUNT (DISTINCT  T_ICIN.CardName ) AS InquiryCustomers /*询价客户数*/
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
        SUM(U_ICIN1.DemandQty) AS InquiryDemandQty,
        COUNT ( * ) AS InquiryFrequency,  /*询价频次*/
        COUNT (DISTINCT  T_ICIN.CardName ) AS InquiryCustomers /*询价客户数*/
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
        SELECT
            COUNT(*) AS OrderCustomers, /*订单客户数量*/
            SUM(ORDR1.Quantity) AS SumQuantity, /*销售数量*/
            SUM(ORDR1.SumMoney) AS SumMoney, /*销售金额*/
            ORDR1.U_Brand,
            ORDR1.U_ItemName
        FROM (
            SELECT
                T_ORDR1.U_Brand,
                T_ORDR1.U_ItemName,
                T_ORDR1.Quantity,
                (T_ORDR1.U_PriceAfVAT * ExchangeRate.Rate * T_ORDR1.Quantity) AS SumMoney
            FROM T_ORDR1
            LEFT JOIN T_ORDR ON T_ORDR.DocEntry = T_ORDR1.DocEntry
            LEFT JOIN #ExchangeRate ExchangeRate ON ExchangeRate.Currency = U_Currency
            WHERE DATEDIFF( MONTH, T_ORDR.DocDate, GETDATE( ) ) = 0
        ) ORDR1
        GROUP BY
        ORDR1.U_Brand,
        ORDR1.U_ItemName
    ) _FirstOrderCustomers ON _FirstOrderCustomers.U_Brand = T.Brand AND _FirstOrderCustomers.U_ItemName = T.Modle
    /*距今2个月订单客户数量*/
    LEFT JOIN (
        SELECT
            COUNT(*) AS OrderCustomers, /*订单客户数量*/
            SUM(ORDR1.Quantity) AS SumQuantity, /*销售数量*/
            SUM(ORDR1.SumMoney) AS SumMoney, /*销售金额*/
            ORDR1.U_Brand,
            ORDR1.U_ItemName
        FROM (
            SELECT
                T_ORDR1.U_Brand,
                T_ORDR1.U_ItemName,
                T_ORDR1.Quantity,
                (T_ORDR1.U_PriceAfVAT * ExchangeRate.Rate * T_ORDR1.Quantity) AS SumMoney
            FROM T_ORDR1
            LEFT JOIN T_ORDR ON T_ORDR.DocEntry = T_ORDR1.DocEntry
            LEFT JOIN #ExchangeRate ExchangeRate ON ExchangeRate.Currency = U_Currency
            WHERE DATEDIFF( MONTH, T_ORDR.DocDate, GETDATE( ) ) = 1
        ) ORDR1
        GROUP BY
        ORDR1.U_Brand,
        ORDR1.U_ItemName
    ) _SecondOrderCustomers ON _SecondOrderCustomers.U_Brand = T.Brand AND _SecondOrderCustomers.U_ItemName = T.Modle
    /*距今3个月订单客户数量*/
    LEFT JOIN (
        SELECT
            COUNT(*) AS OrderCustomers, /*订单客户数量*/
            SUM(ORDR1.Quantity) AS SumQuantity, /*销售数量*/
            SUM(ORDR1.SumMoney) AS SumMoney, /*销售金额*/
            ORDR1.U_Brand,
            ORDR1.U_ItemName
        FROM (
            SELECT
                T_ORDR1.U_Brand,
                T_ORDR1.U_ItemName,
                T_ORDR1.Quantity,
                (T_ORDR1.U_PriceAfVAT * ExchangeRate.Rate * T_ORDR1.Quantity) AS SumMoney
            FROM T_ORDR1
            LEFT JOIN T_ORDR ON T_ORDR.DocEntry = T_ORDR1.DocEntry
            LEFT JOIN #ExchangeRate ExchangeRate ON ExchangeRate.Currency = U_Currency
            WHERE DATEDIFF( MONTH, T_ORDR.DocDate, GETDATE( ) ) = 2
        ) ORDR1
        GROUP BY
        ORDR1.U_Brand,
        ORDR1.U_ItemName
    ) _ThirdOrderCustomers ON _ThirdOrderCustomers.U_Brand = T.Brand AND _ThirdOrderCustomers.U_ItemName = T.Modle
    /*距今4-12个月订单客户数量*/
    LEFT JOIN (
        SELECT
            COUNT(*) AS OrderCustomers, /*订单客户数量*/
            SUM(ORDR1.Quantity) AS SumQuantity, /*销售数量*/
            SUM(ORDR1.SumMoney) AS SumMoney, /*销售金额*/
            ORDR1.U_Brand,
            ORDR1.U_ItemName
        FROM (
            SELECT
                T_ORDR1.U_Brand,
                T_ORDR1.U_ItemName,
                T_ORDR1.Quantity,
                (T_ORDR1.U_PriceAfVAT * ExchangeRate.Rate * T_ORDR1.Quantity) AS SumMoney
            FROM T_ORDR1
            LEFT JOIN T_ORDR ON T_ORDR.DocEntry = T_ORDR1.DocEntry
            LEFT JOIN #ExchangeRate ExchangeRate ON ExchangeRate.Currency = U_Currency
            WHERE DATEDIFF( MONTH, T_ORDR.DocDate, GETDATE( ) ) > 2
            AND DATEDIFF( MONTH, T_ORDR.DocDate, GETDATE( ) ) < 12
        ) ORDR1
        GROUP BY
        ORDR1.U_Brand,
        ORDR1.U_ItemName
    ) _ForthOrderCustomers ON _ForthOrderCustomers.U_Brand = T.Brand AND _ForthOrderCustomers.U_ItemName = T.Modle

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
            OPOR1.U_Brand,
            OPOR1.U_ItemName,
            OPOR1.SumQuantity,
            OPOR1.PurchaseFrequency,
            OPOR1.AveragePPriceAFVAT,
            OPOR1.SumMoney
        FROM (
            SELECT
                T_OPOR1.U_Brand,
                T_OPOR1.U_ItemName,
                COUNT(*) AS PurchaseFrequency,
                SUM(T_OPOR1.Quantity) AS SumQuantity,
                SUM(T_OPOR1.Quantity * T_OPOR1.U_PriceAfVAT * ExchangeRate.Rate) AS SumMoney,
                SUM(T_OPOR1.Quantity * T_OPOR1.U_PriceAfVAT * ExchangeRate.Rate) / SUM(T_OPOR1.Quantity) AS AveragePPriceAFVAT
            FROM T_OPOR1
            LEFT JOIN #ExchangeRate ExchangeRate ON ExchangeRate.Currency = T_OPOR1.U_Currency
            LEFT JOIN T_OPOR ON T_OPOR.DocEntry = T_OPOR1.DocEntry
            WHERE DATEDIFF( MONTH, T_OPOR.DocDate, GETDATE( ) ) < 12
            GROUP BY
                T_OPOR1.U_Brand,
                T_OPOR1.U_ItemName
        )OPOR1
    ) Purchase ON Purchase.U_Brand = T.Brand AND Purchase.U_ItemName = T.Modle

    LEFT JOIN (
        SELECT
                T_OPOR1.U_Brand,
                COUNT(DISTINCT T_OPOR.CardCode) AS Suppliers,
                SUM(T_OPOR1.Quantity) AS SumQuantity,
                SUM(T_OPOR1.Quantity * T_OPOR1.U_PriceAfVAT * ExchangeRate.Rate) AS SumMoney
        FROM T_OPOR1
        LEFT JOIN T_OPOR ON T_OPOR.DocEntry = T_OPOR1.DocEntry
        LEFT JOIN #ExchangeRate ExchangeRate ON ExchangeRate.Currency = T_OPOR1.U_Currency
        GROUP BY U_Brand
    ) BrandPurchase ON BrandPurchase.U_Brand = T.Brand

    LEFT JOIN (
        SELECT
            T_ORDR1.U_Brand,
            COUNT(DISTINCT T_ORDR.CardCode) AS Customers
        FROM T_ORDR1
        LEFT JOIN T_ORDR ON T_ORDR1.DocEntry = T_ORDR.DocEntry
        GROUP BY U_Brand
    ) BrandSale ON BrandSale.U_Brand = T.Brand
    LEFT JOIN (
        SELECT
            Brand,
            COUNT(DISTINCT U_ICIN1.Modle) AS ModleCount
        FROM U_ICIN1
            LEFT JOIN T_ICIN ON T_ICIN.DocEntry = U_ICIN1.DocEntry
        WHERE DATEDIFF(MONTH ,T_ICIN.CreateDate, GETDATE( )) < 12
        GROUP BY Brand
    ) BrandModle ON BrandModle.Brand = T.Brand
) InitRank

DROP TABLE #ExchangeRate