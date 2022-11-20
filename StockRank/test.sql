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
    T.Brand,
    ISNULL(BrandPurchase.SumMoney, 0) AS BrandSumPurchaseMoney, /*品牌总采购额*/
    ISNULL(BrandPurchase.SumQuantity, 0) AS BrandSumPurchaseQuantity, /*品牌总采购数量*/
    ISNULL(BrandPurchase.Suppliers, 0) AS BrandSumPurchaseSuppliers, /*品牌供应商数量*/
    ISNULL(BrandSale.Customers, 0) AS BrandSumSaleCustomers, /*销售客户数量*/
    ISNULL(BrandModle.ModleCount, 0) AS BrandModleCount /*所属型号数量*/
FROM (
        /*近一年询报价业务所涉及的品牌*/
        SELECT
            U_ICIN1.Brand
        FROM
            U_ICIN1
        LEFT JOIN T_ICIN ON U_ICIN1.DocEntry = T_ICIN.DocEntry
        WHERE DATEDIFF(MONTH ,T_ICIN.InquiryDate, GETDATE( )) < 12
        GROUP BY
            U_ICIN1.Brand
) T
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

DROP TABLE #ExchangeRate
