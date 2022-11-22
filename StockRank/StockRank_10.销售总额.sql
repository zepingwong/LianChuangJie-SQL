/*10.销售总额*/
SELECT TT.*,
       ROW_NUMBER() OVER (ORDER BY TT.SumSaleMoney DESC) as SumSaleMoneyRank /*近一年加权销售总额排名*/
FROM (SELECT T.Brand,
             T.Modle,
             ISNULL(_FirstSaleOrder.SumMoney, 0)  AS SumSaleMoneyFirst, /*距今1个月销售总额*/
             ISNULL(_SecondSaleOrder.SumMoney, 0) AS SumSaleMoneySecond, /*距今2个月销售总额*/
             ISNULL(_ThirdSaleOrder.SumMoney, 0)  AS SumSaleMoneyThird, /*距今3个月销售总额*/
             ISNULL(_ForthSaleOrder.SumMoney, 0)  AS SumSaleMoneyForth, /*距今4-12个销售总额*/
             (
                         ISNULL(_FirstSaleOrder.SumMoney, 0) * 0.0622 +
                         ISNULL(_SecondSaleOrder.SumMoney, 0) * 0.1217 +
                         ISNULL(_ThirdSaleOrder.SumMoney, 0) * 0.1217 +
                         ISNULL(_ForthSaleOrder.SumMoney, 0) * 0.1968
                 )                                AS SumSaleMoney /*近一年加权销售总额*/

      FROM (
               /*近一年询报价业务所涉及的品牌、型号*/
               SELECT U_ICIN1.Modle,
                      U_ICIN1.Brand
               FROM U_ICIN1
                        LEFT JOIN T_ICIN ON U_ICIN1.DocEntry = T_ICIN.DocEntry
               WHERE DATEDIFF(MONTH, T_ICIN.InquiryDate, GETDATE()) < 12
               GROUP BY U_ICIN1.Modle,
                        U_ICIN1.Brand) T
               /*距今1个月销售订单*/
               LEFT JOIN (SELECT COUNT(DISTINCT ORDR1.CardCode) AS OrderCustomers, /*订单客户数量*/
                                 COUNT(*)                       AS DeliveryFrequency,
                                 SUM(ORDR1.Quantity)            AS SumQuantity, /*销售数量*/
                                 SUM(ORDR1.SumMoney)            AS SumMoney, /*销售金额*/
                                 ORDR1.U_Brand,
                                 ORDR1.Dscription
                          FROM (SELECT T_ORDR1.U_Brand,
                                       T_ORDR1.Dscription,
                                       T_ORDR1.Quantity,
                                       T_ORDR.CardCode,
                                       (T_ORDR1.U_PriceAfVAT * T_ORDR.DocRate * T_ORDR1.Quantity) AS SumMoney
                                FROM T_ORDR1
                                         LEFT JOIN T_ORDR ON T_ORDR.DocEntry = T_ORDR1.DocEntry
                                WHERE DATEDIFF(MONTH, T_ORDR.DocDate, GETDATE()) = 0) ORDR1
                          GROUP BY ORDR1.U_Brand,
                                   ORDR1.Dscription) _FirstSaleOrder
                         ON _FirstSaleOrder.U_Brand = T.Brand AND _FirstSaleOrder.Dscription = T.Modle
          /*距今2个月销售订单*/
               LEFT JOIN (SELECT COUNT(DISTINCT ORDR1.CardCode) AS OrderCustomers, /*订单客户数量*/
                                 COUNT(*)                       AS DeliveryFrequency,
                                 SUM(ORDR1.Quantity)            AS SumQuantity, /*销售数量*/
                                 SUM(ORDR1.SumMoney)            AS SumMoney, /*销售金额*/
                                 ORDR1.U_Brand,
                                 ORDR1.Dscription
                          FROM (SELECT T_ORDR1.U_Brand,
                                       T_ORDR1.Dscription,
                                       T_ORDR1.Quantity,
                                       T_ORDR.CardCode,
                                       (T_ORDR1.U_PriceAfVAT * T_ORDR.DocRate * T_ORDR1.Quantity) AS SumMoney
                                FROM T_ORDR1
                                         LEFT JOIN T_ORDR ON T_ORDR.DocEntry = T_ORDR1.DocEntry
                                WHERE DATEDIFF(MONTH, T_ORDR.DocDate, GETDATE()) = 1) ORDR1
                          GROUP BY ORDR1.U_Brand,
                                   ORDR1.Dscription) _SecondSaleOrder
                         ON _SecondSaleOrder.U_Brand = T.Brand AND _SecondSaleOrder.Dscription = T.Modle
          /*距今3个月销售订单*/
               LEFT JOIN (SELECT COUNT(DISTINCT ORDR1.CardCode) AS OrderCustomers, /*订单客户数量*/
                                 COUNT(*)                       AS DeliveryFrequency,
                                 SUM(ORDR1.Quantity)            AS SumQuantity, /*销售数量*/
                                 SUM(ORDR1.SumMoney)            AS SumMoney, /*销售金额*/
                                 ORDR1.U_Brand,
                                 ORDR1.Dscription
                          FROM (SELECT T_ORDR1.U_Brand,
                                       T_ORDR1.Dscription,
                                       T_ORDR1.Quantity,
                                       T_ORDR.CardCode,
                                       (T_ORDR1.U_PriceAfVAT * T_ORDR.DocRate * T_ORDR1.Quantity) AS SumMoney
                                FROM T_ORDR1
                                         LEFT JOIN T_ORDR ON T_ORDR.DocEntry = T_ORDR1.DocEntry
                                WHERE DATEDIFF(MONTH, T_ORDR.DocDate, GETDATE()) = 2) ORDR1
                          GROUP BY ORDR1.U_Brand,
                                   ORDR1.Dscription) _ThirdSaleOrder
                         ON _ThirdSaleOrder.U_Brand = T.Brand AND _ThirdSaleOrder.Dscription = T.Modle
          /*距今4-12个月销售订单*/
               LEFT JOIN (SELECT COUNT(DISTINCT ORDR1.CardCode) AS OrderCustomers, /*订单客户数量*/
                                 COUNT(*)                       AS DeliveryFrequency,
                                 SUM(ORDR1.Quantity)            AS SumQuantity, /*销售数量*/
                                 SUM(ORDR1.SumMoney)            AS SumMoney, /*销售金额*/
                                 ORDR1.U_Brand,
                                 ORDR1.Dscription
                          FROM (SELECT T_ORDR1.U_Brand,
                                       T_ORDR1.Dscription,
                                       T_ORDR1.Quantity,
                                       T_ORDR.CardCode,
                                       (T_ORDR1.U_PriceAfVAT * T_ORDR.DocRate * T_ORDR1.Quantity) AS SumMoney
                                FROM T_ORDR1
                                         LEFT JOIN T_ORDR ON T_ORDR.DocEntry = T_ORDR1.DocEntry
                                WHERE DATEDIFF(MONTH, T_ORDR.DocDate, GETDATE()) > 2
                                  AND DATEDIFF(MONTH, T_ORDR.DocDate, GETDATE()) < 12) ORDR1
                          GROUP BY ORDR1.U_Brand,
                                   ORDR1.Dscription) _ForthSaleOrder
                         ON _ForthSaleOrder.U_Brand = T.Brand AND _ForthSaleOrder.Dscription = T.Modle) TT