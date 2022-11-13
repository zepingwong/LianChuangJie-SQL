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
--     COUNT(*)
    T.Modle,
    T.Brand,
    ISNULL(BrandPurchase.SumMoney, 0) AS BrandSumPurchaseMoney, /*品牌总采购额*/
    ISNULL(BrandPurchase.SumQuantity, 0) AS BrandSumPurchaseQuantity, /*品牌总采购数量*/
    ISNULL(BrandPurchase.Suppliers, 0) AS BrandSumPurchaseSuppliers, /*品牌供应商数量*/
    ISNULL(BrandSale.Customers, 0) AS BrandSumSaleCustomers, /*销售客户数量*/
    ISNULL(BrandModle.ModleCount, 0) AS BrandModleCount, /*所属型号数量*/
    (
        ISNULL(BrandPurchase.SumMoney, 0) * 0.34 +
        ISNULL(BrandPurchase.SumQuantity, 0) * 0.34 +
        ISNULL(BrandSale.Customers, 0) * 0.178 +
        ISNULL(BrandPurchase.Suppliers, 0) * 0.099 +
        ISNULL(BrandModle.ModleCount, 0) * 0.043
    ) BrandScore
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
LEFT JOIN (
    SELECT
        Brand,
        SUM(Quantity * U_OIVL.PPriceAFVAT) AS SumMoney,
        SUM(Quantity) AS SumQuantity,
        COUNT(DISTINCT CardCode) AS Suppliers
    FROM U_OIVL
    WHERE BaseName = N'采购入库'
    AND DATEDIFF(MONTH ,U_OIVL.DocDate, GETDATE( )) < 12
    GROUP BY Brand
) BrandPurchase ON BrandPurchase.Brand = T.Brand

LEFT JOIN (
    SELECT
        Brand,
        SUM(Quantity * U_OIVL.SPriceAFVAT * ExchangeRate.Rate) AS SumMoney,
        SUM(Quantity) AS SumQuantity,
        COUNT (DISTINCT CardCode) AS Customers
    FROM U_OIVL
    LEFT JOIN #ExchangeRate ExchangeRate ON ExchangeRate.Currency = U_OIVL.SCurrency
    WHERE BaseName = N'交货单'
    AND DATEDIFF(MONTH ,U_OIVL.DocDate, GETDATE( )) < 12
    GROUP BY Brand
) BrandSale ON BrandSale.Brand = T.Brand
LEFT JOIN (
    SELECT
        Brand,
        COUNT(DISTINCT U_OIVL.ItemName) AS ModleCount
    FROM U_OIVL
    WHERE BaseName IN ( N'交货单', N'采购入库')
    AND DATEDIFF(MONTH ,U_OIVL.DocDate, GETDATE( )) < 12
    GROUP BY Brand
) BrandModle ON BrandModle.Brand = T.Brand

DROP TABLE #ExchangeRate
