/*库存排名*/
DROP TABLE U_StockRank
SELECT InitRank.Brand,
       InitRank.Modle,
       InitRank.InquiryDemandQty1, /*近3个月贸易商类型客户询价数量*/
       InitRank.InquiryDemandQty2, /*近3个月终端类型客户询价数量*/
    /*01.询价频次*/
       ROW_NUMBER() OVER (ORDER BY InitRank.InquiryFrequency DESC)    as InquiryFrequencyRank, /*近1年加权询价频次排名*/
       NULL                                                           AS InquiryFrequencyScore, /*近1年加权询价频次得分*/
       InitRank.InquiryFrequencyFirst1, /*第1个月贸易商类型客户询价频次*/
       InitRank.InquiryFrequencyFirst2, /*第1个月终端类型客户询价频次*/
       InitRank.InquiryFrequencySecond1, /*第2个月贸易商类型客户询价频次*/
       InitRank.InquiryFrequencySecond2, /*第2个月终端类型客户询价频次*/
       InitRank.InquiryFrequencyThird1, /*第3个月贸易商类型客户询价频次*/
       InitRank.InquiryFrequencyThird2, /*第3个月终端类型客户询价频次*/
       InitRank.InquiryFrequencyForth1, /*第4-12个月贸易商类型客户询价频次*/
       InitRank.InquiryFrequencyForth2, /*第4-12个月终端类型客户询价频次*/
       InitRank.InquiryFrequencyFirst, /*第1个月加权询价频次*/
       InitRank.InquiryFrequencySecond, /*第2个月加权询价频次*/
       InitRank.InquiryFrequencyThird, /*第3个月加权询价频次*/
       InitRank.InquiryFrequencyForth, /*第4-12个月加权询价频次*/
       InitRank.InquiryFrequency, /*近1年加权询价频次*/
    /*02.询价客户数*/
       ROW_NUMBER() OVER (ORDER BY InitRank.InquiryCustomers DESC)    as InquiryCustomersRank, /*加权询价客户数排名*/
       NULL                                                           AS InquiryCustomersScore, /*加权询价客户数得分*/
       InitRank.InquiryCustomersFirst1, /*第1个月贸易商类型询价客户数*/
       InitRank.InquiryCustomersFirst2, /*第1个月终端类型询价客户数*/
       InitRank.InquiryCustomersSecond1, /*第2个月贸易商类型询价客户数*/
       InitRank.InquiryCustomersSecond2, /*第2个月终端类型询价客户数*/
       InitRank.InquiryCustomersThird1, /*第3个月贸易商类型询价客户数*/
       InitRank.InquiryCustomersThird2, /*第3个月终端类型询价客户数*/
       InitRank.InquiryCustomersForth1, /*第4-12个月贸易商类型询价客户数*/
       InitRank.InquiryCustomersForth2, /*第4-12个月终端类型询价客户数*/
       InitRank.InquiryCustomersFirst, /*第1个月加权询价客户数*/
       InitRank.InquiryCustomersSecond, /*第2个月加权询价客户数*/
       InitRank.InquiryCustomersThird, /*第3个月加权询价客户数*/
       InitRank.InquiryCustomersForth, /*第4-12个月加权询价客户数*/
       InitRank.InquiryCustomers, /*近1年加权询价客户数*/
    /*03.销售订单客户数*/
       InitRank.OrderCustomers,
       ROW_NUMBER() OVER (ORDER BY InitRank.OrderCustomers DESC)      as OrderCustomersRank, /*近1年加权销售订单客户数排名*/
       NULL                                                           AS OrderCustomersScore, /*近1年加权销售订单客户数得分*/
       InitRank.OrderCustomersFirst, /*第1个月销售订单客户数*/
       InitRank.OrderCustomersSecond, /*第2个月销售订单客户数*/
       InitRank.OrderCustomersThird, /*第3个月销售订单客户数*/
       InitRank.OrderCustomersForth, /*第4-2个月销售订单客户数*/
       InitRank.DeliveryFrequency, /*近1年销售订单客户数*/
    /*04.销售订单频次*/
       ROW_NUMBER() OVER (ORDER BY InitRank.DeliveryFrequency DESC)   as DeliveryFrequencyRank, /*近1年加权销售订单频次排名*/
       NULL                                                           AS DeliveryFrequencyScore, /*近1年加权销售订单频次得分*/
       InitRank.DeliveryFrequencyFirst, /*第1个月销售订单频次*/
       InitRank.DeliveryFrequencySecond, /*第2个月销售订单频次*/
       InitRank.DeliveryFrequencyThird, /*第3个月销售订单频次*/
       InitRank.DeliveryFrequencyForth, /*第4-12个月销售订单频次*/
    /*05.销售总数*/
       ROW_NUMBER() OVER (ORDER BY InitRank.DeliveryQuantity DESC)    as DeliveryQuantityRank, /*近1年加权销售总数排名*/
       NULL                                                           AS DeliveryQuantityScore, /*加权销售总数得分*/
       InitRank.DeliveryQuantity,
       InitRank.DeliveryQuantityFirst,
       InitRank.DeliveryQuantitySecond,
       InitRank.DeliveryQuantityThird,
       InitRank.DeliveryQuantityForth,
       InitRank.AverageProfit,
    /*06.平均利润率*/
       ROW_NUMBER() OVER (ORDER BY InitRank.AverageProfit DESC)       as AverageProfitRank, /*近1年平均利润率排名*/
       NULL                                                           AS AverageProfitScore, /*近1年平均利润率得分*/
       InitRank.AveragePPriceAFVAT, /*近1年平均利润率*/
    /*07.采购价格*/
       ROW_NUMBER() OVER (ORDER BY InitRank.AveragePPriceAFVAT DESC)  as AveragePPriceAFVATRank, /*近1年平均采购价格排名*/
       NULL                                                           AS AveragePPriceAFVATScore, /*近1年平均采购价格得分*/
       InitRank.AveragePPriceAFVAT, /*近1年平均采购价格*/
    /*08.采购数量*/
       ROW_NUMBER() OVER (ORDER BY InitRank.SumPurchaseQuantity DESC) as SumPurchaseQuantityRank, /*近1年采购数量排名*/
       NULL                                                           AS SumPurchaseQuantityScore, /*近1年采购数量得分*/
       InitRank.SumPurchaseQuantity, /*近1年采购数量*/
    /*09.采购频次*/
       ROW_NUMBER() OVER (ORDER BY InitRank.PurchaseFrequency DESC)   as PurchaseFrequencyRank, /*近1年采购频次排名*/
       NULL                                                           AS PurchaseFrequencyScore, /*近1年采购总频次得分*/
       InitRank.PurchaseFrequency, /*近1年采购频次*/
    /*10.销售总额*/
       ROW_NUMBER() OVER (ORDER BY InitRank.SumSaleMoney DESC)        as SumSaleMoneyRank, /*近1年销售总额排名*/
       NULL                                                           AS SumSaleMoneyScore, /*近1年销售总额得分*/
       InitRank.SumSaleMoney, /*近1年销售总额*/
       InitRank.SumSaleMoneyFirst, /*第1个月销售总额*/
       InitRank.SumSaleMoneySecond, /*第2个月销售总额*/
       InitRank.SumSaleMoneyThird, /*第3个月销售总额*/
       InitRank.SumSaleMoneyForth, /*第4-12个月销售总额*/
    /*11.采购总额*/
       ROW_NUMBER() OVER (ORDER BY InitRank.SumPurchaseMoney DESC)    as SumPurchaseMoneyRank, /*近1年采购总额排名*/
       NULL                                                           AS SumPurchaseMoneyScore, /*近1年采购总额得分*/
       InitRank.SumPurchaseMoney, /*近1年采购总额排名*/
    /*12.品牌得分*/
       ROW_NUMBER() OVER (ORDER BY BrandSumPurchaseMoney DESC)        as BrandSumPurchaseMoneyRank, /*近1年品牌采购额排名*/
       NULL                                                           AS BrandSumPurchaseMoneyScore, /*近1年品牌采购额得分*/
       ISNULL(BrandSumPurchaseMoney, 0)                               AS BrandSumPurchaseMoney, /*近1年品牌采购额*/

       ROW_NUMBER() OVER (ORDER BY BrandSumPurchaseQuantity DESC)     as BrandSumPurchaseQuantityRank, /*近1年品牌采购数量排名*/
       NULL                                                           AS BrandSumPurchaseQuantityScore, /*近1年品牌采购数量得分*/
       ISNULL(BrandSumPurchaseQuantity, 0)                            AS BrandSumPurchaseQuantity, /*近1年品牌采购数量*/

       ROW_NUMBER() OVER (ORDER BY BrandSumPurchaseSuppliers DESC)    as BrandSumPurchaseSuppliersRank, /*近1年品牌供应商数量排名*/
       NULL                                                           AS BrandSumPurchaseSuppliersScore, /*近1年品牌供应商数量得分*/
       ISNULL(BrandSumPurchaseSuppliers, 0)                           AS BrandSumPurchaseSuppliers, /*近1年品牌供应商数量*/

       ROW_NUMBER() OVER (ORDER BY BrandSumSaleCustomers DESC)        as BrandSumSaleCustomersRank, /*近1年品牌客户数量排名*/
       NULL                                                           AS BrandSumSaleCustomersScore, /*近1年品牌客户数量得分*/
       ISNULL(BrandSumSaleCustomers, 0)                               AS BrandSumSaleCustomers, /*近1年品牌客户数量*/

       ROW_NUMBER() OVER (ORDER BY BrandModleCount DESC)              as BrandModleCountRank, /*近1年采购订单品牌所属型号数量排名*/
       NULL                                                           AS BrandModleCountScore, /*近1年采购订单品牌所属型号数量得分*/
       ISNULL(BrandModleCount, 0)                                     AS BrandModleCount, /*近1年采购订单品牌所属型号数量*/
       NULL                                                           AS BrandScore, /*品牌得分*/
    /*总分*/
       NULL                                                           AS TotalScore /*总分*/
INTO U_StockRank

FROM (SELECT T.Modle,
             T.Brand,
             (
                     ISNULL(_FirstEnquiry1.InquiryDemandQty, 0) +
                     ISNULL(_SecondEnquiry1.InquiryDemandQty, 0) +
                     ISNULL(_ThirdEnquiry1.InquiryDemandQty, 0)
                 )                                                     AS InquiryDemandQty1, /*近三个月贸易商类型客户询价数量*/
             (
                     ISNULL(_FirstEnquiry2.InquiryDemandQty, 0) +
                     ISNULL(_SecondEnquiry2.InquiryDemandQty, 0) +
                     ISNULL(_ThirdEnquiry2.InquiryDemandQty, 0)
                 )                                                     AS InquiryDemandQty2, /*近三个月终端类型客户询价数量*/
          /*01.询价频次*/
             ISNULL(_FirstEnquiry1.InquiryFrequency, 0)                AS InquiryFrequencyFirst1, /*贸易商类型客户距今1个月询价频次*/
             ISNULL(_FirstEnquiry2.InquiryFrequency, 0)                AS InquiryFrequencyFirst2, /*终端类型客户距今1个月询价频次*/
             (ISNULL(_FirstEnquiry1.InquiryFrequency, 0) * 0.7 + ISNULL(_FirstEnquiry2.InquiryFrequency, 0) *
                                                                 1.5)  AS InquiryFrequencyFirst, /*距今1个月询价频次*/
             ISNULL(_SecondEnquiry1.InquiryFrequency, 0)               AS InquiryFrequencySecond1, /*贸易商类型客户距今2个月询价频次*/
             ISNULL(_SecondEnquiry2.InquiryFrequency, 0)               AS InquiryFrequencySecond2, /*终端类型客户距今2个月询价频次*/
             (ISNULL(_SecondEnquiry1.InquiryFrequency, 0) * 0.7 + ISNULL(_SecondEnquiry2.InquiryFrequency, 0) *
                                                                  1.5) AS InquiryFrequencySecond, /*距今2个月询价频次*/
             ISNULL(_ThirdEnquiry1.InquiryFrequency, 0)                AS InquiryFrequencyThird1, /*贸易商类型客户距今3个月询价频次*/
             ISNULL(_ThirdEnquiry2.InquiryFrequency, 0)                AS InquiryFrequencyThird2, /*终端类型客户距今3个月询价频次*/
             (ISNULL(_ThirdEnquiry1.InquiryFrequency, 0) * 0.7 + ISNULL(_ThirdEnquiry2.InquiryFrequency, 0) *
                                                                 1.5)  AS InquiryFrequencyThird, /*距今3个月询价频次*/
             ISNULL(_ForthEnquiry1.InquiryFrequency, 0)                AS InquiryFrequencyForth1, /*贸易商类型客户距今4-12个月询价频次*/
             ISNULL(_ForthEnquiry2.InquiryFrequency, 0)                AS InquiryFrequencyForth2, /*终端类型客户距今4-12个月询价频次*/
             (ISNULL(_ForthEnquiry1.InquiryFrequency, 0) * 0.7 + ISNULL(_ForthEnquiry2.InquiryFrequency, 0) *
                                                                 1.5)  AS InquiryFrequencyForth, /*距今4-12个月询价频次*/
             (
                         (ISNULL(_ForthEnquiry1.InquiryFrequency, 0) * 0.7 +
                          ISNULL(_ForthEnquiry2.InquiryFrequency, 0) * 1.5) * 0.0622 +
                         (ISNULL(_ThirdEnquiry1.InquiryFrequency, 0) * 0.7 +
                          ISNULL(_ThirdEnquiry2.InquiryFrequency, 0) * 1.5) * 0.1217 +
                         (ISNULL(_SecondEnquiry1.InquiryFrequency, 0) * 0.7 +
                          ISNULL(_SecondEnquiry2.InquiryFrequency, 0) * 1.5) * 0.1217 +
                         (ISNULL(_FirstEnquiry1.InquiryFrequency, 0) * 0.7 +
                          ISNULL(_FirstEnquiry2.InquiryFrequency, 0) * 1.5) * 0.1968
                 )                                                     AS InquiryFrequency, /*近1年加权询价频次*/

          /*02.询价客户数*/
             ISNULL(_FirstEnquiry1.InquiryCustomers, 0)                AS InquiryCustomersFirst1, /*贸易商类型客户距今1个月询价客户数*/
             ISNULL(_FirstEnquiry2.InquiryCustomers, 0)                AS InquiryCustomersFirst2, /*终端类型客户距今1个月询价客户数*/
             (ISNULL(_FirstEnquiry1.InquiryCustomers, 0) * 0.7 + ISNULL(_FirstEnquiry2.InquiryCustomers, 0) *
                                                                 1.5)  AS InquiryCustomersFirst, /*距今1个月询价客户数*/
             ISNULL(_SecondEnquiry1.InquiryCustomers, 0)               AS InquiryCustomersSecond1, /*贸易商类型客户距今2个月询价客户数*/
             ISNULL(_SecondEnquiry2.InquiryCustomers, 0)               AS InquiryCustomersSecond2, /*终端类型客户距今2个月询价客户数*/
             (ISNULL(_SecondEnquiry1.InquiryCustomers, 0) * 0.7 + ISNULL(_SecondEnquiry2.InquiryCustomers, 0) *
                                                                  1.5) AS InquiryCustomersSecond, /*距今2个月询价客户数*/
             ISNULL(_ThirdEnquiry1.InquiryCustomers, 0)                AS InquiryCustomersThird1, /*贸易商类型客户距今3个月询价客户数*/
             ISNULL(_ThirdEnquiry2.InquiryCustomers, 0)                AS InquiryCustomersThird2, /*终端类型客户距今3个月询价客户数*/
             (ISNULL(_ThirdEnquiry1.InquiryCustomers, 0) * 0.7 + ISNULL(_ThirdEnquiry2.InquiryCustomers, 0) *
                                                                 1.5)  AS InquiryCustomersThird, /*距今3个月询价客户数*/
             ISNULL(_ForthEnquiry1.InquiryCustomers, 0)                AS InquiryCustomersForth1, /*贸易商类型客户距今4个月询价客户数*/
             ISNULL(_ForthEnquiry2.InquiryCustomers, 0)                AS InquiryCustomersForth2, /*终端类型客户距今4个月询价客户数*/
             (ISNULL(_ForthEnquiry1.InquiryCustomers, 0) * 0.7 + ISNULL(_ForthEnquiry2.InquiryCustomers, 0) *
                                                                 1.5)  AS InquiryCustomersForth, /*距今4个月询价客户数*/
             (
                         (ISNULL(_ForthEnquiry1.InquiryCustomers, 0) * 0.7 +
                          ISNULL(_ForthEnquiry2.InquiryCustomers, 0) * 1.5) * 0.0622 +
                         (ISNULL(_ThirdEnquiry1.InquiryCustomers, 0) * 0.7 +
                          ISNULL(_ThirdEnquiry2.InquiryCustomers, 0) * 1.5) * 0.1217 +
                         (ISNULL(_SecondEnquiry1.InquiryCustomers, 0) * 0.7 +
                          ISNULL(_SecondEnquiry2.InquiryCustomers, 0) * 1.5) * 0.1217 +
                         (ISNULL(_FirstEnquiry1.InquiryCustomers, 0) * 0.7 +
                          ISNULL(_FirstEnquiry2.InquiryCustomers, 0) * 1.5) * 0.1968
                 )                                                     AS InquiryCustomers, /*近1年加权询价客户数*/

          /*03.订单客户数量*/
             ISNULL(_FirstSaleOrder.OrderCustomers, 0)                 AS OrderCustomersFirst, /*距今1个月订单客户数量*/
             ISNULL(_SecondSaleOrder.OrderCustomers, 0)                AS OrderCustomersSecond, /*距今2个月订单客户数量*/
             ISNULL(_ThirdSaleOrder.OrderCustomers, 0)                 AS OrderCustomersThird, /*距今3个月订单客户数量*/
             ISNULL(_ForthSaleOrder.OrderCustomers, 0)                 AS OrderCustomersForth, /*距今4-12个月订单客户数量*/
             (
                         ISNULL(_FirstSaleOrder.OrderCustomers, 0) * 0.1968 +
                         ISNULL(_SecondSaleOrder.OrderCustomers, 0) * 0.1217 +
                         ISNULL(_ThirdSaleOrder.OrderCustomers, 0) * 0.1217 +
                         ISNULL(_ForthSaleOrder.OrderCustomers, 0) * 0.0622
                 )                                                     AS OrderCustomers, /*近1年加权订单客户数量*/

          /*04.销售订单频次*/
             ISNULL(_FirstSaleOrder.DeliveryFrequency, 0)              AS DeliveryFrequencyFirst, /*距今1个月销售订单频次*/
             ISNULL(_SecondSaleOrder.DeliveryFrequency, 0)             AS DeliveryFrequencySecond, /*距今2个月销售订单频次*/
             ISNULL(_ThirdSaleOrder.DeliveryFrequency, 0)              AS DeliveryFrequencyThird, /*距今3个月销售订单频次*/
             ISNULL(_ForthSaleOrder.DeliveryFrequency, 0)              AS DeliveryFrequencyForth, /*距今4-12个月销售订单频次*/
             (
                         ISNULL(_FirstSaleOrder.DeliveryFrequency, 0) * 0.1968 +
                         ISNULL(_SecondSaleOrder.DeliveryFrequency, 0) * 0.1217 +
                         ISNULL(_ThirdSaleOrder.DeliveryFrequency, 0) * 0.1217 +
                         ISNULL(_ForthSaleOrder.DeliveryFrequency, 0) * 0.0622
                 )                                                     AS DeliveryFrequency, /*近1年加权订单总数*/

          /*05.销售数量*/
             ISNULL(_FirstSaleOrder.SumSaleQuantity, 0)                AS DeliveryQuantityFirst, /*距今1个月销售数量*/
             ISNULL(_SecondSaleOrder.SumSaleQuantity, 0)               AS DeliveryQuantitySecond, /*距今2个月销售数量*/
             ISNULL(_ThirdSaleOrder.SumSaleQuantity, 0)                AS DeliveryQuantityThird, /*距今3个月销售数量*/
             ISNULL(_ForthSaleOrder.SumSaleQuantity, 0)                AS DeliveryQuantityForth, /*距今4-12个月销售数量*/
             (
                         ISNULL(_FirstSaleOrder.SumSaleQuantity, 0) * 0.1968 +
                         ISNULL(_SecondSaleOrder.SumSaleQuantity, 0) * 0.1217 +
                         ISNULL(_ThirdSaleOrder.SumSaleQuantity, 0) * 0.1217 +
                         ISNULL(_ForthSaleOrder.SumSaleQuantity, 0) * 0.0622
                 )                                                     AS DeliveryQuantity, /*近1年加权销售总数*/

          /*06.平均利润率*/
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
                 )                                                     AS AverageProfit /*近1年平均利润率*/,

          /*07.采购价格*/
             ISNULL(PurchaseOrder.AveragePPriceAFVAT, 0)               AS AveragePPriceAFVAT, /*近1年平均采购价格*/

          /*08.采购数量*/
             ISNULL(PurchaseOrder.SumPurchaseQuantity, 0)              AS SumPurchaseQuantity, /*近1年采购总数*/

          /*09.采购频次*/
             ISNULL(PurchaseOrder.PurchaseFrequency, 0)                AS PurchaseFrequency, /*近1年采购频次总数*/

          /*10.销售额*/
             ISNULL(_FirstSaleOrder.SumSaleMoney, 0)                   AS SumSaleMoneyFirst, /*距今1个月销售总额*/
             ISNULL(_SecondSaleOrder.SumSaleMoney, 0)                  AS SumSaleMoneySecond, /*距今2个月销售总额*/
             ISNULL(_ThirdSaleOrder.SumSaleMoney, 0)                   AS SumSaleMoneyThird, /*距今3个月销售总额*/
             ISNULL(_ForthSaleOrder.SumSaleMoney, 0)                   AS SumSaleMoneyForth, /*距今4-12个销售总额*/
             (
                         ISNULL(_FirstSaleOrder.SumSaleMoney, 0) * 0.0622 +
                         ISNULL(_SecondSaleOrder.SumSaleMoney, 0) * 0.1217 +
                         ISNULL(_ThirdSaleOrder.SumSaleMoney, 0) * 0.1217 +
                         ISNULL(_ForthSaleOrder.SumSaleMoney, 0) * 0.1968
                 )                                                     AS SumSaleMoney, /*近1年加权销售总额*/

          /*11.采购总额*/
             ISNULL(PurchaseOrder.SumPurchaseMoney, 0)                 AS SumPurchaseMoney, /*近1年采购总额*/

          /*12.品牌得分*/
             ISNULL(BrandPurchase.BrandSumPurchaseMoney, 0)            AS BrandSumPurchaseMoney, /*品牌总采购额*/
             ISNULL(BrandPurchase.BrandSumPurchaseQuantity, 0)         AS BrandSumPurchaseQuantity, /*品牌总采购数量*/
             ISNULL(BrandPurchase.BrandSuppliers, 0)                   AS BrandSumPurchaseSuppliers, /*品牌供应商数量*/
             ISNULL(BrandSale.BrandCustomers, 0)                       AS BrandSumSaleCustomers, /*销售客户数量*/
             ISNULL(BrandModle.BrandModleCount, 0)                     AS BrandModleCount /*所属型号数量*//*取采购订单已成单的品牌和对应型号*/

      FROM (
               /*近1年询报价业务所涉及的品牌、型号*/
               SELECT U_ICIN1.Modle,
                      U_ICIN1.Brand
               FROM U_ICIN1
                        LEFT JOIN T_ICIN ON U_ICIN1.DocEntry = T_ICIN.DocEntry
               WHERE DATEDIFF(MONTH, T_ICIN.InquiryDate, GETDATE()) < 12
               GROUP BY U_ICIN1.Modle,
                        U_ICIN1.Brand) T

               /*贸易商类型客户距今1个月询价频次、询价客户数、询价数量*/
               LEFT JOIN (SELECT U_ICIN1.Brand,
                                 U_ICIN1.Modle,
                                 SUM(U_ICIN1.DemandQty)          AS InquiryDemandQty, /*询价数量*/
                                 COUNT(*)                        AS InquiryFrequency, /*询价频次*/
                                 COUNT(DISTINCT T_ICIN.CardCode) AS InquiryCustomers /*询价客户数*/
                          FROM U_ICIN1
                                   LEFT JOIN T_ICIN ON T_ICIN.DocEntry = U_ICIN1.DocEntry
                          WHERE DATEDIFF(MONTH, T_ICIN.InquiryDate, GETDATE()) = 0
                            AND T_ICIN.U_CusGroupCode IN (N'关系型贸易商', N'一般贸易商', N'其它')
                          GROUP BY U_ICIN1.Brand,
                                   U_ICIN1.Modle) _FirstEnquiry1
                         ON _FirstEnquiry1.Modle = T.Modle AND _FirstEnquiry1.Brand = T.Brand
          /*终端类型客户距今1个月询价频次、询价客户数、询价数量*/
               LEFT JOIN (SELECT U_ICIN1.Brand,
                                 U_ICIN1.Modle,
                                 SUM(U_ICIN1.DemandQty)          AS InquiryDemandQty, /*询价数量*/
                                 COUNT(*)                        AS InquiryFrequency, /*询价频次*/
                                 COUNT(DISTINCT T_ICIN.CardCode) AS InquiryCustomers /*询价客户数*/
                          FROM U_ICIN1
                                   LEFT JOIN T_ICIN ON T_ICIN.DocEntry = U_ICIN1.DocEntry
                          WHERE DATEDIFF(MONTH, T_ICIN.InquiryDate, GETDATE()) = 0
                            AND T_ICIN.U_CusGroupCode IN ('OEM/EMS', N'终端用户')
                          GROUP BY U_ICIN1.Brand,
                                   U_ICIN1.Modle) _FirstEnquiry2
                         ON _FirstEnquiry2.Modle = T.Modle AND _FirstEnquiry2.Brand = T.Brand


          /*贸易商类型客户距今2个月询价频次、询价客户数、询价数量*/
               LEFT JOIN (SELECT U_ICIN1.Brand,
                                 U_ICIN1.Modle,
                                 SUM(U_ICIN1.DemandQty)          AS InquiryDemandQty, /*询价数量*/
                                 COUNT(*)                        AS InquiryFrequency, /*询价频次*/
                                 COUNT(DISTINCT T_ICIN.CardCode) AS InquiryCustomers /*询价客户数*/
                          FROM U_ICIN1
                                   LEFT JOIN T_ICIN ON T_ICIN.DocEntry = U_ICIN1.DocEntry
                          WHERE DATEDIFF(MONTH, T_ICIN.InquiryDate, GETDATE()) = 1
                            AND T_ICIN.U_CusGroupCode IN (N'关系型贸易商', N'一般贸易商', N'其它')
                          GROUP BY U_ICIN1.Brand,
                                   U_ICIN1.Modle) _SecondEnquiry1
                         ON _SecondEnquiry1.Modle = T.Modle AND _SecondEnquiry1.Brand = T.Brand
          /*终端类型客户距今2个月询价频次、询价客户数、询价数量*/
               LEFT JOIN (SELECT U_ICIN1.Brand,
                                 U_ICIN1.Modle,
                                 SUM(U_ICIN1.DemandQty)          AS InquiryDemandQty, /*询价数量*/
                                 COUNT(*)                        AS InquiryFrequency, /*询价频次*/
                                 COUNT(DISTINCT T_ICIN.CardCode) AS InquiryCustomers /*询价客户数*/
                          FROM U_ICIN1
                                   LEFT JOIN T_ICIN ON T_ICIN.DocEntry = U_ICIN1.DocEntry
                          WHERE DATEDIFF(MONTH, T_ICIN.InquiryDate, GETDATE()) = 1
                            AND T_ICIN.U_CusGroupCode IN ('OEM/EMS', N'终端用户')
                          GROUP BY U_ICIN1.Brand,
                                   U_ICIN1.Modle) _SecondEnquiry2
                         ON _SecondEnquiry2.Modle = T.Modle AND _SecondEnquiry2.Brand = T.Brand

          /*贸易商类型客户距今3个月询价频次、询价客户数、询价数量*/
               LEFT JOIN (SELECT U_ICIN1.Brand,
                                 U_ICIN1.Modle,
                                 SUM(U_ICIN1.DemandQty)          AS InquiryDemandQty, /*询价数量*/
                                 COUNT(*)                        AS InquiryFrequency, /*询价频次*/
                                 COUNT(DISTINCT T_ICIN.CardCode) AS InquiryCustomers /*询价客户数*/
                          FROM U_ICIN1
                                   LEFT JOIN T_ICIN ON T_ICIN.DocEntry = U_ICIN1.DocEntry
                          WHERE DATEDIFF(MONTH, T_ICIN.InquiryDate, GETDATE()) = 2
                            AND T_ICIN.U_CusGroupCode IN (N'关系型贸易商', N'一般贸易商', N'其它')
                          GROUP BY U_ICIN1.Brand,
                                   U_ICIN1.Modle) _ThirdEnquiry1
                         ON _ThirdEnquiry1.Modle = T.Modle AND _ThirdEnquiry1.Brand = T.Brand
          /*终端类型客户距今3个月询价频次、询价客户数、询价数量*/
               LEFT JOIN (SELECT U_ICIN1.Brand,
                                 U_ICIN1.Modle,
                                 SUM(U_ICIN1.DemandQty)          AS InquiryDemandQty, /*询价数量*/
                                 COUNT(*)                        AS InquiryFrequency, /*询价频次*/
                                 COUNT(DISTINCT T_ICIN.CardCode) AS InquiryCustomers /*询价客户数*/
                          FROM U_ICIN1
                                   LEFT JOIN T_ICIN ON T_ICIN.DocEntry = U_ICIN1.DocEntry
                          WHERE DATEDIFF(MONTH, T_ICIN.InquiryDate, GETDATE()) = 2
                            AND T_ICIN.U_CusGroupCode IN ('OEM/EMS', N'终端用户')
                          GROUP BY U_ICIN1.Brand,
                                   U_ICIN1.Modle) _ThirdEnquiry2
                         ON _ThirdEnquiry2.Modle = T.Modle AND _ThirdEnquiry2.Brand = T.Brand

          /*贸易商类型客户距今4-12个月询价频次、询价客户数、询价数量*/
               LEFT JOIN (SELECT U_ICIN1.Brand,
                                 U_ICIN1.Modle,
                                 SUM(U_ICIN1.DemandQty)          AS InquiryDemandQty, /*询价数量*/
                                 COUNT(*)                        AS InquiryFrequency, /*询价频次*/
                                 COUNT(DISTINCT T_ICIN.CardCode) AS InquiryCustomers /*询价客户数*/
                          FROM U_ICIN1
                                   LEFT JOIN T_ICIN ON T_ICIN.DocEntry = U_ICIN1.DocEntry
                          WHERE DATEDIFF(MONTH, T_ICIN.InquiryDate, GETDATE()) > 2
                            AND DATEDIFF(MONTH, T_ICIN.InquiryDate, GETDATE()) < 12
                            AND T_ICIN.U_CusGroupCode IN (N'关系型贸易商', N'一般贸易商', N'其它')
                          GROUP BY U_ICIN1.Brand,
                                   U_ICIN1.Modle) _ForthEnquiry1
                         ON _ForthEnquiry1.Modle = T.Modle AND _ForthEnquiry1.Brand = T.Brand
          /*终端类型客户距今4-12个月询价频次、询价客户数、询价数量*/
               LEFT JOIN (SELECT U_ICIN1.Brand,
                                 U_ICIN1.Modle,
                                 SUM(U_ICIN1.DemandQty)          AS InquiryDemandQty, /*询价数量*/
                                 COUNT(*)                        AS InquiryFrequency, /*询价频次*/
                                 COUNT(DISTINCT T_ICIN.CardCode) AS InquiryCustomers /*询价客户数*/
                          FROM U_ICIN1
                                   LEFT JOIN T_ICIN ON T_ICIN.DocEntry = U_ICIN1.DocEntry
                          WHERE DATEDIFF(MONTH, T_ICIN.InquiryDate, GETDATE()) > 2
                            AND DATEDIFF(MONTH, T_ICIN.InquiryDate, GETDATE()) < 12
                            AND T_ICIN.U_CusGroupCode IN ('OEM/EMS', N'终端用户')
                          GROUP BY U_ICIN1.Brand,
                                   U_ICIN1.Modle) _ForthEnquiry2
                         ON _ForthEnquiry2.Modle = T.Modle AND _ForthEnquiry2.Brand = T.Brand

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
                          GROUP BY U_Brand) BrandModle ON BrandModle.U_Brand = T.Brand) InitRank