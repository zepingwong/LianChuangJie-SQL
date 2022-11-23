DECLARE @Total INT
SELECT @Total = COUNT(*)
FROM U_StockRank;

/*01.询价频次_赋分*/
DECLARE @MIN_InquiryFrequency INT
DECLARE @MAX_InquiryFrequency INT
/*排名前9.1799%*/
SELECT @MIN_InquiryFrequency = MIN(InquiryFrequency),
       @MAX_InquiryFrequency = MAX(InquiryFrequency)
FROM U_StockRank
WHERE InquiryFrequencyRank <= @Total * 0.091799

UPDATE U_StockRank
SET InquiryFrequencyScore = IIF(
            @MIN_InquiryFrequency != @MAX_InquiryFrequency,
            (InquiryFrequency - @MIN_InquiryFrequency) / (@MAX_InquiryFrequency - @MIN_InquiryFrequency) * 8 +
            2, /*排名前9.1799% 2-10分*/
            1 /*特殊情况赋最低分1分*/
    )
WHERE InquiryFrequencyRank <= @Total * 0.091799

/*其余*/
SELECT @MIN_InquiryFrequency = MIN(InquiryFrequency),
       @MAX_InquiryFrequency = MAX(InquiryFrequency)
FROM U_StockRank
WHERE InquiryFrequencyRank > @Total * 0.091799

UPDATE U_StockRank
SET InquiryFrequencyScore = IIF(
            @MIN_InquiryFrequency != @MAX_InquiryFrequency,
            (InquiryFrequency - @MIN_InquiryFrequency) / (@MAX_InquiryFrequency - @MIN_InquiryFrequency) * 0.99 +
            1, /*其余 1-1.99分*/
            1 /*特殊情况赋最低分1分*/
    )
WHERE InquiryFrequencyRank > @Total * 0.091799

/*02.询价客户数_赋分*/
DECLARE @MIN_InquiryCustomers INT
DECLARE @MAX_InquiryCustomers INT

SELECT @MIN_InquiryCustomers = MIN(InquiryCustomers),
       @MAX_InquiryCustomers = MAX(InquiryCustomers)
FROM U_StockRank

UPDATE U_StockRank
SET InquiryCustomersScore = IIF(
            @MAX_InquiryCustomers != @MIN_InquiryCustomers,
            (InquiryCustomers - @MIN_InquiryCustomers) / (@MAX_InquiryCustomers - @MIN_InquiryCustomers) * 9 +
            1, /*询价客户数赋分 1-10*/
            1 /*特殊情况赋最低分1分*/
    )
WHERE Modle IS NOT NULL

/*03.销售订单客户数_赋分*/
DECLARE @MIN_OrderCustomers INT
DECLARE @MAX_OrderCustomers INT

SELECT @MIN_OrderCustomers = MIN(OrderCustomers),
       @MAX_OrderCustomers = MAX(OrderCustomers)
FROM U_StockRank

UPDATE U_StockRank
SET OrderCustomersScore = IIF(
            @MAX_OrderCustomers != @MIN_OrderCustomers,
            (OrderCustomers - @MIN_OrderCustomers) / (@MAX_OrderCustomers - @MIN_OrderCustomers) * 9 +
            1, /*订单客户数赋分 1-10*/
            1 /*特殊情况赋最低分1分*/
    )
WHERE Modle IS NOT NULL

/*04.销售订单频次_赋分*/
DECLARE @MIN_DeliveryFrequency INT
DECLARE @MAX_DeliveryFrequency INT
/*排名前0.1%*/
SELECT @MIN_DeliveryFrequency = MIN(DeliveryFrequency),
       @MAX_DeliveryFrequency = MAX(DeliveryFrequency)
FROM U_StockRank
WHERE DeliveryFrequencyRank <= @Total * 0.001

UPDATE U_StockRank
SET DeliveryFrequencyScore = IIF(
            @MAX_DeliveryFrequency != @MIN_DeliveryFrequency,
            (DeliveryFrequency - @MIN_DeliveryFrequency) / (@MAX_DeliveryFrequency - @MIN_DeliveryFrequency) * 2 +
            8, /*排名前0.1% 赋分8-10分*/
            1 /*特殊情况赋最低分1分*/
    )
WHERE DeliveryFrequencyRank <= @Total * 0.001

/*其余*/
SELECT @MIN_DeliveryFrequency = MIN(DeliveryFrequency),
       @MAX_DeliveryFrequency = MAX(DeliveryFrequency)
FROM U_StockRank
WHERE DeliveryFrequencyRank > @Total * 0.001

UPDATE U_StockRank
SET DeliveryFrequencyScore = IIF(
            @MAX_DeliveryFrequency != @MIN_DeliveryFrequency,
            (DeliveryFrequency - @MIN_DeliveryFrequency) / (@MAX_DeliveryFrequency - @MIN_DeliveryFrequency) * 7 +
            1, /*其余赋分 1-8分*/
            1 /*特殊情况赋最低分1分*/
    )
WHERE DeliveryFrequencyRank > @Total * 0.001

/*05.销售数量_赋分*/
DECLARE @MIN_DeliveryQuantity INT
DECLARE @MAX_DeliveryQuantity INT
/*排名前0.7%*/
SELECT @MIN_DeliveryQuantity = MIN(DeliveryQuantity),
       @MAX_DeliveryQuantity = MAX(DeliveryQuantity)
FROM U_StockRank
WHERE DeliveryQuantityRank <= @Total * 0.007

UPDATE U_StockRank
SET DeliveryQuantityScore = IIF(
            @MAX_DeliveryQuantity != @MIN_DeliveryQuantity,
            (DeliveryQuantity - @MIN_DeliveryQuantity) / (@MAX_DeliveryQuantity - @MIN_DeliveryQuantity) * 8 +
            2, /*排名前0.7% 赋分2-10分 */
            1 /*特殊情况赋最低分1分*/
    )
WHERE DeliveryQuantityRank <= @Total * 0.007

/*其余*/
SELECT @MIN_DeliveryQuantity = MIN(DeliveryQuantity),
       @MAX_DeliveryQuantity = MAX(DeliveryQuantity)
FROM U_StockRank
WHERE DeliveryQuantityRank > @Total * 0.007

UPDATE U_StockRank
SET DeliveryQuantityScore = IIF(
            @MAX_DeliveryQuantity != @MIN_DeliveryQuantity,
            (DeliveryQuantity - @MIN_DeliveryQuantity) / (@MAX_DeliveryQuantity - @MIN_DeliveryQuantity) * 7 +
            1, /*其余 赋分1-8分 */
            1 /*特殊情况赋最低分1分*/
    )
WHERE DeliveryQuantityRank > @Total * 0.007

/*06.平均利润率_赋分*/
DECLARE @MAX_AverageProfit DECIMAL
DECLARE @MIN_AverageProfit DECIMAL

/*利润率大于1*/
SELECT @MIN_AverageProfit = MIN(AverageProfit),
       @MAX_AverageProfit = MAX(AverageProfit)
FROM U_StockRank
WHERE AverageProfit > 1

UPDATE U_StockRank
SET AverageProfitScore = IIF(
            @MAX_AverageProfit != @MIN_AverageProfit,
            (AverageProfit - @MIN_AverageProfit) / (@MAX_AverageProfit - @MIN_AverageProfit) * 3 +
            7, /*利润率大于1 赋分7-10分*/
            1 /*特殊情况赋最低分1分*/
    )
WHERE AverageProfit > 1

/*利润率小于等于1大于等于0*/

SELECT @MIN_AverageProfit = MIN(AverageProfit),
       @MAX_AverageProfit = MAX(AverageProfit)
FROM U_StockRank
WHERE AverageProfit <= 1
  AND AverageProfit >= 0

UPDATE U_StockRank
SET AverageProfitScore = IIF(
            @MAX_AverageProfit != @MIN_AverageProfit,
            (AverageProfit - @MIN_AverageProfit) / (@MAX_AverageProfit - @MIN_AverageProfit) * 5 +
            2, /*利润率大于0小于1 赋分2-7分*/
            1 /*特殊情况赋最低分1分*/
    )
WHERE AverageProfit <= 1
  AND AverageProfit >= 0

/*利润率小于零*/
SELECT @MIN_AverageProfit = MIN(AverageProfit),
       @MAX_AverageProfit = MAX(AverageProfit)
FROM U_StockRank
WHERE AverageProfit < 0

UPDATE U_StockRank
SET AverageProfitScore = IIF(
            @MAX_AverageProfit != @MIN_AverageProfit,
            (AverageProfit - @MIN_AverageProfit) / (@MAX_AverageProfit - @MIN_AverageProfit) + 1, /*利润率小于0 赋分1-2分*/
            1 /*特殊情况赋最低分1分*/
    )
WHERE AverageProfit < 0

/*0.7采购价格_赋分*/
UPDATE U_StockRank
SET AveragePPriceAFVATScore = 1 /*采购价格大于17000, 赋1分*/
WHERE AveragePPriceAFVAT > 17000

UPDATE U_StockRank
SET AveragePPriceAFVATScore = 6 /*13000大于采购价格小于等于17000, 赋6分*/
WHERE AveragePPriceAFVAT <= 17000
  AND AveragePPriceAFVAT > 13000

UPDATE U_StockRank
SET AveragePPriceAFVATScore = 8 /*8000大于采购价格小于等于13000, 赋6分*/
WHERE AveragePPriceAFVAT <= 13000
  AND AveragePPriceAFVAT > 8000

UPDATE U_StockRank
SET AveragePPriceAFVATScore = 10 /*采购价格小于等于8000, 赋10分*/
WHERE AveragePPriceAFVAT <= 8000

/*08.采购数量_赋分*/
DECLARE @MIN_SumPurchaseQuantity INT
DECLARE @MAX_SumPurchaseQuantity INT
/*前0.781%*/

SELECT @MIN_SumPurchaseQuantity = MIN(SumPurchaseQuantity),
       @MAX_SumPurchaseQuantity = MAX(SumPurchaseQuantity)
FROM U_StockRank
WHERE SumPurchaseQuantityRank <= @Total * 0.00781

UPDATE U_StockRank
SET SumPurchaseQuantityScore = IIF(
            @MAX_SumPurchaseQuantity != @MIN_SumPurchaseQuantity,
            (SumPurchaseQuantity - @MIN_SumPurchaseQuantity) / (@MAX_SumPurchaseQuantity - @MIN_SumPurchaseQuantity) *
            2 + 8, /*排名前0.781% 赋分8-10分*/
            1 /*特殊情况赋最低分1分*/
    )
WHERE SumPurchaseQuantityRank <= @Total * 0.00781

/*其余*/

SELECT @MIN_SumPurchaseQuantity = MIN(SumPurchaseQuantity),
       @MAX_SumPurchaseQuantity = MAX(SumPurchaseQuantity)
FROM U_StockRank
WHERE SumPurchaseQuantityRank > @Total * 0.00781

UPDATE U_StockRank
SET SumPurchaseQuantityScore = IIF(
            @MAX_SumPurchaseQuantity != @MIN_SumPurchaseQuantity,
            (SumPurchaseQuantity - @MIN_SumPurchaseQuantity) / (@MAX_SumPurchaseQuantity - @MIN_SumPurchaseQuantity) *
            7 + 1, /*其余赋分1-8分*/
            1 /*特殊情况赋最低分1分*/
    )
WHERE SumPurchaseQuantityRank > @Total * 0.00781

/*09.采购频次_赋分*/
DECLARE @MIN_PurchaseFrequency INT
DECLARE @MAX_PurchaseFrequency INT
/*排名前0.1%*/
SELECT @MIN_PurchaseFrequency = MIN(PurchaseFrequency),
       @MAX_PurchaseFrequency = MAX(PurchaseFrequency)
FROM U_StockRank
WHERE PurchaseFrequencyRank <= @Total * 0.001

UPDATE U_StockRank
SET PurchaseFrequencyScore = IIF(
            @MAX_PurchaseFrequency != @MIN_PurchaseFrequency,
            (PurchaseFrequency - @MIN_PurchaseFrequency) / (@MAX_PurchaseFrequency - @MIN_PurchaseFrequency) * 2 +
            8, /*排名前0.1% 赋分8-10*/
            1 /*特殊情况赋最低分1分*/
    )
WHERE PurchaseFrequencyRank <= @Total * 0.001

/*其余*/
SELECT @MIN_PurchaseFrequency = MIN(PurchaseFrequency),
       @MAX_PurchaseFrequency = MAX(PurchaseFrequency)
FROM U_StockRank
WHERE PurchaseFrequencyRank > @Total * 0.001

UPDATE U_StockRank
SET PurchaseFrequencyScore = IIF(
            @MAX_PurchaseFrequency != @MIN_PurchaseFrequency,
            (PurchaseFrequency - @MIN_PurchaseFrequency) / (@MAX_PurchaseFrequency - @MIN_PurchaseFrequency) * 7 +
            1, /*其余 赋分1-8*/
            1 /*特殊情况赋最低分1分*/
    )
WHERE PurchaseFrequencyRank > @Total * 0.001

/*10.销售总额_赋分*/
DECLARE @MIN_SumSaleMoney INT
DECLARE @MAX_SumSaleMoney INT
/*排名前0.4%*/
SELECT @MIN_SumSaleMoney = MIN(SumSaleMoney),
       @MAX_SumSaleMoney = MAX(SumSaleMoney)
FROM U_StockRank
WHERE SumSaleMoneyRank <= @Total * 0.004

UPDATE U_StockRank
SET SumSaleMoneyScore = IIF(
            @MAX_SumSaleMoney != @MIN_SumSaleMoney,
            (SumSaleMoney - @MIN_SumSaleMoney) / (@MAX_SumSaleMoney - @MIN_SumSaleMoney) * 2 + 8, /*排名前0.4% 赋分8-10分*/
            1 /*特殊情况赋最低分1分*/
    )
WHERE SumSaleMoneyRank <= @Total * 0.004

/*其余*/
SELECT @MIN_SumSaleMoney = MIN(SumSaleMoney),
       @MAX_SumSaleMoney = MAX(SumSaleMoney)
FROM U_StockRank
WHERE SumSaleMoneyRank > @Total * 0.004

UPDATE U_StockRank
SET SumSaleMoneyScore = IIF(
            @MAX_SumSaleMoney != @MIN_SumSaleMoney,
            (SumSaleMoney - @MIN_SumSaleMoney) / (@MAX_SumSaleMoney - @MIN_SumSaleMoney) * 7 + 1, /*其余 赋分1-8分*/
            1 /*特殊情况赋最低分1分*/
    )
WHERE SumSaleMoneyRank > @Total * 0.004

/*11.采购总额_赋分*/
DECLARE @MIN_SumPurchaseMoney INT
DECLARE @MAX_SumPurchaseMoney INT
/*排名前0.254%*/
SELECT @MIN_SumPurchaseMoney = MIN(SumPurchaseMoney),
       @MAX_SumPurchaseMoney = MAX(SumPurchaseMoney)
FROM U_StockRank
WHERE SumPurchaseMoneyRank <= @Total * 0.00254

UPDATE U_StockRank
SET SumPurchaseMoneyScore = IIF(
            @MAX_SumPurchaseMoney != @MIN_SumPurchaseMoney,
            (SumPurchaseMoney - @MIN_SumPurchaseMoney) / (@MAX_SumPurchaseMoney - @MIN_SumPurchaseMoney) * 2 +
            8, /*排名前0.254% 赋分8-10分*/
            1 /*特殊情况赋最低分1分*/
    )
WHERE SumPurchaseMoneyRank <= @Total * 0.00254

/*其余*/
SELECT @MIN_SumPurchaseMoney = MIN(SumPurchaseMoney),
       @MAX_SumPurchaseMoney = MAX(SumPurchaseMoney)
FROM U_StockRank
WHERE SumPurchaseMoneyRank > @Total * 0.00254

UPDATE U_StockRank
SET SumPurchaseMoneyScore = IIF(
            @MAX_SumPurchaseMoney != @MIN_SumPurchaseMoney,
            (SumPurchaseMoney - @MIN_SumPurchaseMoney) / (@MAX_SumPurchaseMoney - @MIN_SumPurchaseMoney) * 7 +
            1, /*排名前0.254% 赋分1-8分*/
            1 /*特殊情况赋最低分1分*/
    )
WHERE SumPurchaseMoneyRank > @Total * 0.00254

/*品牌供应商数量赋分*/
DECLARE @MIN_BrandSumPurchaseSuppliers INT
DECLARE @MAX_BrandSumPurchaseSuppliers INT
/*排名前3.2168%*/
SELECT @MIN_BrandSumPurchaseSuppliers = MIN(BrandSumPurchaseSuppliers),
       @MAX_BrandSumPurchaseSuppliers = MAX(BrandSumPurchaseSuppliers)
FROM U_StockRank
WHERE SumPurchaseMoneyRank <= @Total * 0.032168

UPDATE U_StockRank
SET BrandSumPurchaseSuppliersScore = IIF(
            @MAX_BrandSumPurchaseSuppliers != @MIN_BrandSumPurchaseSuppliers,
            (BrandSumPurchaseSuppliers - @MIN_BrandSumPurchaseSuppliers) /
            (@MAX_BrandSumPurchaseSuppliers - @MIN_BrandSumPurchaseSuppliers) * 2 + 8,
            1
    )
WHERE SumPurchaseMoneyRank <= @Total * 0.032168

/*其余*/
SELECT @MIN_BrandSumPurchaseSuppliers = MIN(BrandSumPurchaseSuppliers),
       @MAX_BrandSumPurchaseSuppliers = MAX(BrandSumPurchaseSuppliers)
FROM U_StockRank
WHERE SumPurchaseMoneyRank > @Total * 0.032168

UPDATE U_StockRank
SET BrandSumPurchaseSuppliersScore = IIF(
            @MAX_BrandSumPurchaseSuppliers != @MIN_BrandSumPurchaseSuppliers,
            (BrandSumPurchaseSuppliers - @MIN_BrandSumPurchaseSuppliers) /
            (@MAX_BrandSumPurchaseSuppliers - @MIN_BrandSumPurchaseSuppliers) * 7 + 1,
            1
    )
WHERE SumPurchaseMoneyRank > @Total * 0.032168

/*品牌客户赋分*/
DECLARE @MIN_BrandSumSaleCustomers INT
DECLARE @MAX_BrandSumSaleCustomers INT
/*排名前1.1189%*/
SELECT @MIN_BrandSumSaleCustomers = MIN(BrandSumSaleCustomers),
       @MAX_BrandSumSaleCustomers = MAX(BrandSumSaleCustomers)
FROM U_StockRank
WHERE SumPurchaseMoneyRank <= @Total * 0.011189

UPDATE U_StockRank
SET BrandSumSaleCustomersScore = IIF(
            @MAX_BrandSumSaleCustomers != @MIN_BrandSumSaleCustomers,
            (BrandSumSaleCustomers - @MIN_BrandSumSaleCustomers) /
            (@MAX_BrandSumSaleCustomers - @MIN_BrandSumSaleCustomers) * 2 + 8,
            1
    )
WHERE SumPurchaseMoneyRank <= @Total * 0.011189

/*其余*/
SELECT @MIN_BrandSumSaleCustomers = MIN(BrandSumSaleCustomers),
       @MAX_BrandSumSaleCustomers = MAX(BrandSumSaleCustomers)
FROM U_StockRank
WHERE SumPurchaseMoneyRank > @Total * 0.011189

UPDATE U_StockRank
SET BrandSumSaleCustomersScore = IIF(
            @MAX_BrandSumSaleCustomers != @MIN_BrandSumSaleCustomers,
            (BrandSumSaleCustomers - @MIN_BrandSumSaleCustomers) /
            (@MAX_BrandSumSaleCustomers - @MIN_BrandSumSaleCustomers) * 7 + 1,
            1
    )
WHERE SumPurchaseMoneyRank > @Total * 0.011189

/*品牌所属型号赋分*/
DECLARE @MIN_BrandModleCount INT
DECLARE @MAX_BrandModleCount INT
/*排名前1.2587%*/
SELECT @MIN_BrandModleCount = MIN(BrandModleCount),
       @MAX_BrandModleCount = MAX(BrandModleCount)
FROM U_StockRank
WHERE SumPurchaseMoneyRank <= @Total * 0.012587

UPDATE U_StockRank
SET BrandModleCountScore = IIF(
            @MAX_BrandModleCount != @MIN_BrandModleCount,
            (BrandModleCount - @MIN_BrandModleCount) / (@MAX_BrandModleCount - @MIN_BrandModleCount) * 2 + 8,
            1
    )
WHERE SumPurchaseMoneyRank <= @Total * 0.012587

/*其余*/
SELECT @MIN_BrandModleCount = MIN(BrandModleCount),
       @MAX_BrandModleCount = MAX(BrandModleCount)
FROM U_StockRank
WHERE SumPurchaseMoneyRank > @Total * 0.012587

UPDATE U_StockRank
SET BrandModleCountScore = IIF(
            @MAX_BrandModleCount != @MIN_BrandModleCount,
            (BrandModleCount - @MIN_BrandModleCount) / (@MAX_BrandModleCount - @MIN_BrandModleCount) * 7 + 1,
            1
    )
WHERE SumPurchaseMoneyRank > @Total * 0.012587

/*品牌采购总数赋分*/
DECLARE @MIN_BrandSumPurchaseQuantity INT
DECLARE @MAX_BrandSumPurchaseQuantity INT
/*排名前3.4965%*/
SELECT @MIN_BrandSumPurchaseQuantity = MIN(BrandSumPurchaseQuantity),
       @MAX_BrandSumPurchaseQuantity = MAX(BrandSumPurchaseQuantity)
FROM U_StockRank
WHERE SumPurchaseMoneyRank <= @Total * 0.034965

UPDATE U_StockRank
SET BrandSumPurchaseQuantityScore = IIF(
            @MAX_BrandSumPurchaseQuantity != @MIN_BrandSumPurchaseQuantity,
            (BrandSumPurchaseQuantity - @MIN_BrandSumPurchaseQuantity) /
            (@MAX_BrandSumPurchaseQuantity - @MIN_BrandSumPurchaseQuantity) * 2 + 8,
            1
    )
WHERE SumPurchaseMoneyRank <= @Total * 0.034965

/*其余*/
SELECT @MIN_BrandSumPurchaseQuantity = MIN(BrandSumPurchaseQuantity),
       @MAX_BrandSumPurchaseQuantity = MAX(BrandSumPurchaseQuantity)
FROM U_StockRank
WHERE SumPurchaseMoneyRank > @Total * 0.034965

UPDATE U_StockRank
SET BrandSumPurchaseQuantityScore = IIF(
            @MAX_BrandSumPurchaseQuantity != @MIN_BrandSumPurchaseQuantity,
            (BrandSumPurchaseQuantity - @MIN_BrandSumPurchaseQuantity) /
            (@MAX_BrandSumPurchaseQuantity - @MIN_BrandSumPurchaseQuantity) * 7 + 1,
            1
    )
WHERE SumPurchaseMoneyRank > @Total * 0.034965

/*品牌采购总额赋分*/
DECLARE @MIN_BrandSumPurchaseMoney INT
DECLARE @MAX_BrandSumPurchaseMoney INT
/*排名前0.8392%*/
SELECT @MIN_BrandSumPurchaseMoney = MIN(BrandSumPurchaseMoney),
       @MAX_BrandSumPurchaseMoney = MAX(BrandSumPurchaseMoney)
FROM U_StockRank
WHERE SumPurchaseMoneyRank <= @Total * 0.008392

UPDATE U_StockRank
SET BrandSumPurchaseMoneyScore = IIF(
            @MAX_BrandSumPurchaseMoney != @MIN_BrandSumPurchaseMoney,
            (BrandSumPurchaseMoney - @MIN_BrandSumPurchaseMoney) /
            (@MAX_BrandSumPurchaseMoney - @MIN_BrandSumPurchaseMoney) * 2 + 8,
            1
    )
WHERE SumPurchaseMoneyRank <= @Total * 0.008392

/*其余*/
SELECT @MIN_BrandSumPurchaseMoney = MIN(BrandSumPurchaseMoney),
       @MAX_BrandSumPurchaseMoney = MAX(BrandSumPurchaseMoney)
FROM U_StockRank
WHERE SumPurchaseMoneyRank > @Total * 0.008392

UPDATE U_StockRank
SET BrandSumPurchaseMoneyScore = IIF(
            @MAX_BrandSumPurchaseMoney != @MIN_BrandSumPurchaseMoney,
            (BrandSumPurchaseMoney - @MIN_BrandSumPurchaseMoney) /
            (@MAX_BrandSumPurchaseMoney - @MIN_BrandSumPurchaseMoney) * 7 + 1,
            1
    )
WHERE SumPurchaseMoneyRank > @Total * 0.008392

UPDATE U_StockRank
SET ToTalScore =
                InquiryFrequencyScore * 0.369 +
                InquiryCustomersScore * 0.0528 +
                OrderCustomersScore * 0.0648 +
                DeliveryFrequencyScore * 0.1943 +
                DeliveryQuantityScore * 0.0569 +
                AverageProfitScore * 0.0576 +
                AveragePPriceAFVATScore * 0.0550 +
                SumPurchaseQuantityScore * 0.0124 +
                PurchaseFrequencyScore * 0.0326 +
                SumSaleMoneyScore * 0.0303 +
                SumPurchaseMoneyScore * 0.0167
WHERE Modle IS NOT NULL
