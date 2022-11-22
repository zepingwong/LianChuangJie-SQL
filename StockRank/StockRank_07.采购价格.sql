/*07.采购价格*/
SELECT T.Brand,
       T.Modle,
       ISNULL(PurchaseOrder.AveragePPriceAFVAT, 0) AS AveragePPriceAFVAT /*近一年平均采购价格*/
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
