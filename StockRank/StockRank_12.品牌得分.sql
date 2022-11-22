SELECT T.Brand,
       ISNULL(BrandPurchase.BrandSumPurchaseMoney, 0)    AS BrandSumPurchaseMoney, /*品牌总采购额*/
       ISNULL(BrandPurchase.BrandSumPurchaseQuantity, 0) AS BrandSumPurchaseQuantity, /*品牌总采购数量*/
       ISNULL(BrandPurchase.BrandSuppliers, 0)           AS BrandSumPurchaseSuppliers, /*品牌供应商数量*/
       ISNULL(BrandSale.BrandCustomers, 0)               AS BrandSumSaleCustomers, /*销售客户数量*/
       ISNULL(BrandModle.BrandModleCount, 0)             AS BrandModleCount /*所属型号数量*//*取采购订单已成单的品牌和对应型号*/
FROM (
         /*近一年询报价业务所涉及的品牌*/
         SELECT U_ICIN1.Brand
         FROM U_ICIN1
                  LEFT JOIN T_ICIN ON U_ICIN1.DocEntry = T_ICIN.DocEntry
         WHERE DATEDIFF(MONTH, T_ICIN.InquiryDate, GETDATE()) < 12
         GROUP BY U_ICIN1.Brand) T

         /*品牌采购订单*/
         LEFT JOIN (SELECT T_OPOR1.U_Brand,
                           COUNT(DISTINCT T_OPOR.CardCode)                               AS BrandSuppliers,
                           SUM(T_OPOR1.Quantity)                                         AS BrandSumPurchaseQuantity,
                           SUM(T_OPOR1.Quantity * T_OPOR1.U_PriceAfVAT * T_OPOR.DocRate) AS BrandSumPurchaseMoney
                    FROM T_OPOR1
                             LEFT JOIN T_OPOR ON T_OPOR.DocEntry = T_OPOR1.DocEntry
                    WHERE DATEDIFF(MONTH, T_OPOR.DocDate, GETDATE()) < 12
                    GROUP BY U_Brand) BrandPurchase ON BrandPurchase.U_Brand = T.Brand
    /*品牌销售订单*/
         LEFT JOIN (SELECT T_ORDR1.U_Brand,
                           COUNT(DISTINCT T_ORDR.CardCode) AS BrandCustomers
                    FROM T_ORDR1
                             LEFT JOIN T_ORDR ON T_ORDR1.DocEntry = T_ORDR.DocEntry
                    WHERE DATEDIFF(MONTH, T_ORDR.DocDate, GETDATE()) < 12
                    GROUP BY U_Brand) BrandSale ON BrandSale.U_Brand = T.Brand
    /*品牌所属型号数量*/
         LEFT JOIN (SELECT U_Brand,
                           COUNT(DISTINCT T_OPOR1.Dscription) AS BrandModleCount
                    FROM T_OPOR1
                             LEFT JOIN T_OPOR ON T_OPOR.DocEntry = T_OPOR1.DocEntry
                    WHERE DATEDIFF(MONTH, T_OPOR.CreateDate, GETDATE()) < 12
                    GROUP BY U_Brand) BrandModle ON BrandModle.U_Brand = T.Brand