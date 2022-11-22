/*06.平均利润率*/
SELECT T.Brand,
       T.Modle,
       IIF(
                   PurchaseOrder.SumPurchaseMoney IS NOT NULL AND PurchaseOrder.SumPurchaseMoney != 0,
                   (
                               ISNULL(_FirstSaleOrder.SumSaleMoney, 0) + /*距今1个月销售总额*/
                               ISNULL(_SecondSaleOrder.SumSaleMoney, 0) + /*距今2个月销售总额*/
                               ISNULL(_ThirdSaleOrder.SumSaleMoney, 0) + /*距今3个月销售总额*/
                               ISNULL(_ForthSaleOrder.SumSaleMoney, 0) - /*距今4-12个销售总额*/
                               ISNULL(PurchaseOrder.SumPurchaseMoney, 0) /*近1年采购总额*/
                       ) / PurchaseOrder.SumPurchaseMoney,
                   0
           ) AS AverageProfit /*近1年平均利润率*/
FROM (
         /*近一年询报价业务所涉及的品牌、型号*/
         SELECT U_ICIN1.Modle,
                U_ICIN1.Brand
         FROM U_ICIN1
                  LEFT JOIN T_ICIN ON U_ICIN1.DocEntry = T_ICIN.DocEntry
         WHERE DATEDIFF(MONTH, T_ICIN.InquiryDate, GETDATE()) < 12
         GROUP BY U_ICIN1.Modle,
                  U_ICIN1.Brand) T
         /*采购数量、采购价格、采购频次*/
         LEFT JOIN (SELECT OPOR1.U_Brand,
                           OPOR1.Dscription,
                           OPOR1.SumPurchaseQuantity, /*近1年采购数量*/
                           OPOR1.PurchaseFrequency, /*近1年采购频次*/
                           OPOR1.AveragePPriceAFVAT, /*近1年平均采购价格*/
                           OPOR1.SumPurchaseMoney /*近1年总采购额*/
                    FROM (SELECT T_OPOR1.U_Brand,
                                 T_OPOR1.Dscription,
                                 COUNT(*)                                                      AS PurchaseFrequency,
                                 SUM(T_OPOR1.Quantity)                                         AS SumPurchaseQuantity,
                                 SUM(T_OPOR1.Quantity * T_OPOR1.U_PriceAfVAT * T_OPOR.DocRate) AS SumPurchaseMoney,
                                 SUM(T_OPOR1.Quantity * T_OPOR1.U_PriceAfVAT * T_OPOR.DocRate) /
                                 SUM(T_OPOR1.Quantity)                                         AS AveragePPriceAFVAT
                          FROM T_OPOR1
                                   LEFT JOIN T_OPOR ON T_OPOR.DocEntry = T_OPOR1.DocEntry
                          WHERE DATEDIFF(MONTH, T_OPOR.DocDate, GETDATE()) < 12
                          GROUP BY T_OPOR1.U_Brand,
                                   T_OPOR1.Dscription) OPOR1) PurchaseOrder
                   ON PurchaseOrder.U_Brand = T.Brand AND PurchaseOrder.Dscription = T.Modle
    /*距今1个月销售订单*/
         LEFT JOIN (SELECT COUNT(DISTINCT ORDR1.CardCode) AS OrderCustomers, /*销售订单客户数量*/
                           COUNT(*)                       AS DeliveryFrequency, /*销售订单频次*/
                           SUM(ORDR1.Quantity)            AS SumSaleQuantity, /*销售数量*/
                           SUM(ORDR1.SumSaleMoney)        AS SumSaleMoney, /*销售金额*/
                           ORDR1.U_Brand,
                           ORDR1.Dscription
                    FROM (SELECT T_ORDR1.U_Brand,
                                 T_ORDR1.Dscription,
                                 T_ORDR1.Quantity,
                                 T_ORDR.CardCode,
                                 (T_ORDR1.U_PriceAfVAT * T_ORDR.DocRate * T_ORDR1.Quantity) AS SumSaleMoney
                          FROM T_ORDR1
                                   LEFT JOIN T_ORDR ON T_ORDR.DocEntry = T_ORDR1.DocEntry
                          WHERE DATEDIFF(MONTH, T_ORDR.DocDate, GETDATE()) = 0) ORDR1
                    GROUP BY ORDR1.U_Brand,
                             ORDR1.Dscription) _FirstSaleOrder
                   ON _FirstSaleOrder.U_Brand = T.Brand AND _FirstSaleOrder.Dscription = T.Modle
    /*距今2个月销售订单*/
         LEFT JOIN (SELECT COUNT(DISTINCT ORDR1.CardCode) AS OrderCustomers, /*销售订单客户数量*/
                           COUNT(*)                       AS DeliveryFrequency, /*销售订单频次*/
                           SUM(ORDR1.Quantity)            AS SumSaleQuantity, /*销售数量*/
                           SUM(ORDR1.SumSaleMoney)        AS SumSaleMoney, /*销售金额*/
                           ORDR1.U_Brand,
                           ORDR1.Dscription
                    FROM (SELECT T_ORDR1.U_Brand,
                                 T_ORDR1.Dscription,
                                 T_ORDR1.Quantity,
                                 T_ORDR.CardCode,
                                 (T_ORDR1.U_PriceAfVAT * T_ORDR.DocRate * T_ORDR1.Quantity) AS SumSaleMoney
                          FROM T_ORDR1
                                   LEFT JOIN T_ORDR ON T_ORDR.DocEntry = T_ORDR1.DocEntry
                          WHERE DATEDIFF(MONTH, T_ORDR.DocDate, GETDATE()) = 1) ORDR1
                    GROUP BY ORDR1.U_Brand,
                             ORDR1.Dscription) _SecondSaleOrder
                   ON _SecondSaleOrder.U_Brand = T.Brand AND _SecondSaleOrder.Dscription = T.Modle
    /*距今3个月销售订单*/
         LEFT JOIN (SELECT COUNT(DISTINCT ORDR1.CardCode) AS OrderCustomers, /*销售订单客户数量*/
                           COUNT(*)                       AS DeliveryFrequency, /*销售订单频次*/
                           SUM(ORDR1.Quantity)            AS SumSaleQuantity, /*销售数量*/
                           SUM(ORDR1.SumSaleMoney)        AS SumSaleMoney, /*销售金额*/
                           ORDR1.U_Brand,
                           ORDR1.Dscription
                    FROM (SELECT T_ORDR1.U_Brand,
                                 T_ORDR1.Dscription,
                                 T_ORDR1.Quantity,
                                 T_ORDR.CardCode,
                                 (T_ORDR1.U_PriceAfVAT * T_ORDR.DocRate * T_ORDR1.Quantity) AS SumSaleMoney
                          FROM T_ORDR1
                                   LEFT JOIN T_ORDR ON T_ORDR.DocEntry = T_ORDR1.DocEntry
                          WHERE DATEDIFF(MONTH, T_ORDR.DocDate, GETDATE()) = 2) ORDR1
                    GROUP BY ORDR1.U_Brand,
                             ORDR1.Dscription) _ThirdSaleOrder
                   ON _ThirdSaleOrder.U_Brand = T.Brand AND _ThirdSaleOrder.Dscription = T.Modle
    /*距今4-12个月销售订单*/
         LEFT JOIN (SELECT COUNT(DISTINCT ORDR1.CardCode) AS OrderCustomers, /*销售订单客户数量*/
                           COUNT(*)                       AS DeliveryFrequency, /*销售订单频次*/
                           SUM(ORDR1.Quantity)            AS SumSaleQuantity, /*销售数量*/
                           SUM(ORDR1.SumSaleMoney)        AS SumSaleMoney, /*销售金额*/
                           ORDR1.U_Brand,
                           ORDR1.Dscription
                    FROM (SELECT T_ORDR1.U_Brand,
                                 T_ORDR1.Dscription,
                                 T_ORDR1.Quantity,
                                 T_ORDR.CardCode,
                                 (T_ORDR1.U_PriceAfVAT * T_ORDR.DocRate * T_ORDR1.Quantity) AS SumSaleMoney
                          FROM T_ORDR1
                                   LEFT JOIN T_ORDR ON T_ORDR.DocEntry = T_ORDR1.DocEntry
                          WHERE DATEDIFF(MONTH, T_ORDR.DocDate, GETDATE()) > 2
                            AND DATEDIFF(MONTH, T_ORDR.DocDate, GETDATE()) < 12) ORDR1
                    GROUP BY ORDR1.U_Brand,
                             ORDR1.Dscription) _ForthSaleOrder
                   ON _ForthSaleOrder.U_Brand = T.Brand AND _ForthSaleOrder.Dscription = T.Modle