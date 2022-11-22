/*03.订单客户数量*/

SELECT T.Brand,
       T.Modle,
       ISNULL(_FirstSaleOrder.OrderCustomers, 0)  AS OrderCustomersFirst, /*距今1个月订单客户数量*/
       ISNULL(_SecondSaleOrder.OrderCustomers, 0) AS OrderCustomersSecond, /*距今2个月订单客户数量*/
       ISNULL(_ThirdSaleOrder.OrderCustomers, 0)  AS OrderCustomersThird, /*距今3个月订单客户数量*/
       ISNULL(_ForthSaleOrder.OrderCustomers, 0)  AS OrderCustomersForth, /*距今4-12个月订单客户数量*/
       (
                   ISNULL(_FirstSaleOrder.OrderCustomers, 0) * 0.1968 +
                   ISNULL(_SecondSaleOrder.OrderCustomers, 0) * 0.1217 +
                   ISNULL(_ThirdSaleOrder.OrderCustomers, 0) * 0.1217 +
                   ISNULL(_ForthSaleOrder.OrderCustomers, 0) * 0.0622
           )                                      AS OrderCustomers /*近一年加权订单客户数量*/
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
                   ON _ForthSaleOrder.U_Brand = T.Brand AND _ForthSaleOrder.Dscription = T.Modle

