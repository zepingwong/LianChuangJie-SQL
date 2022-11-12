DECLARE @Total INT
SELECT @Total = COUNT(*) FROM U_StockRank;

/*询价频次赋分*/
DECLARE @MIN_InquiryFrequency INT
DECLARE @MAX_InquiryFrequency INT
/*排名前9.1799%*/
SELECT
    @MIN_InquiryFrequency = MIN(InquiryFrequency),
    @MAX_InquiryFrequency = MAX(InquiryFrequency)
FROM U_StockRank
WHERE InquiryFrequencyRank <= @Total * 0.091799

UPDATE U_StockRank
SET InquiryFrequencyScore = IIF (
    @MIN_InquiryFrequency != @MAX_InquiryFrequency,
    (InquiryFrequency - @MIN_InquiryFrequency) / (@MAX_InquiryFrequency - @MIN_InquiryFrequency) * 8 + 2,
    0
)
WHERE InquiryFrequencyRank <= @Total * 0.091799

/*其余*/
SELECT
    @MIN_InquiryFrequency = MIN(InquiryFrequency),
    @MAX_InquiryFrequency = MAX(InquiryFrequency)
FROM U_StockRank
WHERE InquiryFrequencyRank > @Total * (1- 0.091799)

UPDATE U_StockRank
SET InquiryFrequencyScore = IIF (
    @MIN_InquiryFrequency != @MAX_InquiryFrequency,
    (InquiryFrequency - @MIN_InquiryFrequency) / (@MAX_InquiryFrequency - @MIN_InquiryFrequency) * 0.99 + 1,
    0
)
WHERE InquiryFrequencyRank > @Total * (1- 0.091799)


/*询价客户数赋分*/
DECLARE @MIN_InquiryCustomers INT
DECLARE @MAX_InquiryCustomers INT

SELECT
    @MIN_InquiryCustomers = MIN(InquiryCustomers),
    @MAX_InquiryCustomers = MAX(InquiryCustomers)
FROM U_StockRank

UPDATE U_StockRank
SET InquiryCustomersScore = IIF(
    @MAX_InquiryCustomers != @MIN_InquiryCustomers,
    (InquiryCustomers - @MIN_InquiryCustomers) / (@MAX_InquiryCustomers - @MIN_InquiryCustomers) * 9 + 1,
    0
)


/*订单客户数赋分*/
DECLARE @MIN_OrderCustomers INT
DECLARE @MAX_OrderCustomers INT

SELECT
    @MIN_OrderCustomers = MIN(OrderCustomers),
    @MAX_OrderCustomers = MAX(OrderCustomers)
FROM U_StockRank

UPDATE U_StockRank
SET OrderCustomersScore = IIF(
    @MAX_OrderCustomers != @MIN_OrderCustomers,
    (OrderCustomers - @MIN_OrderCustomers) / (@MAX_OrderCustomers - @MIN_OrderCustomers) * 9 + 1,
    0
)

/*交货单频次赋分*/
DECLARE @MIN_DeliveryFrequency INT
DECLARE @MAX_DeliveryFrequency INT
/*排名前0.1%*/
SELECT
    @MIN_DeliveryFrequency = MIN(DeliveryFrequency),
    @MAX_DeliveryFrequency = MAX(DeliveryFrequency)
FROM U_StockRank
WHERE DeliveryFrequencyRank <= @Total * 0.001

UPDATE U_StockRank
SET DeliveryFrequencyScore = IIF(
    @MAX_DeliveryFrequency != @MIN_DeliveryFrequency,
    (DeliveryFrequency - @MIN_DeliveryFrequency) / (@MAX_DeliveryFrequency - @MIN_DeliveryFrequency) * 2 + 8,
    0
)
WHERE DeliveryFrequencyRank <= @Total * 0.001

/*其余*/
SELECT
    @MIN_DeliveryFrequency = MIN(DeliveryFrequency),
    @MAX_DeliveryFrequency = MAX(DeliveryFrequency)
FROM U_StockRank
WHERE DeliveryFrequencyRank > @Total * (1- 0.001)

UPDATE U_StockRank
SET DeliveryFrequencyScore = IIF(
    @MAX_DeliveryFrequency != @MIN_DeliveryFrequency,
    (DeliveryFrequency - @MIN_DeliveryFrequency) / (@MAX_DeliveryFrequency - @MIN_DeliveryFrequency) * 7 + 1,
    0
)
WHERE DeliveryFrequencyRank > @Total * (1- 0.001)


/*销售数量赋分*/
DECLARE @MIN_DeliveryQuantity INT
DECLARE @MAX_DeliveryQuantity INT
/*排名前0.1%*/
SELECT
    @MIN_DeliveryQuantity = MIN(DeliveryQuantity),
    @MAX_DeliveryQuantity = MAX(DeliveryQuantity)
FROM U_StockRank
WHERE DeliveryQuantityRank <= @Total * 0.007

UPDATE U_StockRank
SET DeliveryQuantityScore = IIF(
    @MAX_DeliveryQuantity != @MIN_DeliveryQuantity,
    (DeliveryQuantity - @MIN_DeliveryQuantity) / (@MAX_DeliveryQuantity - @MIN_DeliveryQuantity) * 8 + 2,
    0
)
WHERE DeliveryQuantityRank <= @Total * 0.007

/*其余*/
SELECT
    @MIN_DeliveryQuantity = MIN(DeliveryQuantity),
    @MAX_DeliveryQuantity = MAX(DeliveryQuantity)
FROM U_StockRank
WHERE DeliveryQuantityRank > @Total * (1- 0.007)

UPDATE U_StockRank
SET DeliveryQuantityScore = IIF(
    @MAX_DeliveryQuantity != @MIN_DeliveryQuantity,
    (DeliveryQuantity - @MIN_DeliveryQuantity) / (@MAX_DeliveryQuantity - @MIN_DeliveryQuantity) * 7 + 1,
    0
)
WHERE DeliveryQuantityRank > @Total * (1- 0.007)

/*平均利润率赋分*/
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
    (AverageProfit - @MIN_AverageProfit) / (@MAX_AverageProfit-@MIN_AverageProfit) *3 + 7,
    0
)
WHERE AverageProfit > 1

/*利润率小于等于1大于等于0*/

SELECT @MIN_AverageProfit = MIN(AverageProfit),
       @MAX_AverageProfit = MAX(AverageProfit)
FROM U_StockRank
WHERE AverageProfit <= 1
AND AverageProfit >= 0

UPDATE U_StockRank
SET AverageProfitScore =  IIF(
    @MAX_AverageProfit != @MIN_AverageProfit,
    (AverageProfit - @MIN_AverageProfit) / (@MAX_AverageProfit - @MIN_AverageProfit) * 5 + 2,
    0
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
        (AverageProfit - @MIN_AverageProfit) / (@MAX_AverageProfit - @MIN_AverageProfit) + 1,
        0
)
WHERE AverageProfit < 0

/*采购价格赋分*/
/*采购价格>17000, 赋1分*/
UPDATE U_StockRank
SET AveragePPriceAFVATScore = 1
WHERE AveragePPriceAFVAT > 17000

/*13000<采购价格<=17000, 赋6分*/
UPDATE U_StockRank
SET AveragePPriceAFVATScore = 6
WHERE AveragePPriceAFVAT <= 17000
AND AveragePPriceAFVAT > 13000

/*8000<采购价格<=13000, 赋6分*/
UPDATE U_StockRank
SET AveragePPriceAFVATScore = 8
WHERE AveragePPriceAFVAT <= 13000
AND AveragePPriceAFVAT > 8000

/*采购价格<=8000, 赋10分*/
UPDATE U_StockRank
SET AveragePPriceAFVATScore = 10
WHERE AveragePPriceAFVAT <= 8000

/*采购数量赋分*/
DECLARE @MIN_SumPurchaseQuantity INT
DECLARE @MAX_SumPurchaseQuantity INT
/*前0.781%*/

SELECT
    @MIN_SumPurchaseQuantity = MIN(SumPurchaseQuantity),
    @MAX_SumPurchaseQuantity = MAX(SumPurchaseQuantity)
FROM U_StockRank
WHERE SumPurchaseQuantityRank <= @Total * 0.00781

UPDATE U_StockRank
SET SumPurchaseQuantity = IIF(
    @MAX_SumPurchaseQuantity != @MIN_SumPurchaseQuantity,
    (SumPurchaseQuantity - @MIN_SumPurchaseQuantity) / (@MAX_SumPurchaseQuantity - @MIN_SumPurchaseQuantity) *2 + 8,
    0
)
WHERE SumPurchaseQuantityRank <= @Total * 0.00781

/*其余*/

SELECT
    @MIN_SumPurchaseQuantity = MIN(SumPurchaseQuantity),
    @MAX_SumPurchaseQuantity = MAX(SumPurchaseQuantity)
FROM U_StockRank
WHERE SumPurchaseQuantityRank > @Total * 0.00781

UPDATE U_StockRank
SET SumPurchaseQuantity = IIF(
    @MAX_SumPurchaseQuantity != @MIN_SumPurchaseQuantity,
    (SumPurchaseQuantity - @MIN_SumPurchaseQuantity) / (@MAX_SumPurchaseQuantity - @MIN_SumPurchaseQuantity) * 7 + 1,
    0
)
WHERE SumPurchaseQuantityRank > @Total * 0.00781

/*采购频次赋分*/
DECLARE @MIN_PurchaseFrequency INT
DECLARE @MAX_PurchaseFrequency INT
/*排名前0.1%*/
SELECT
    @MIN_PurchaseFrequency = MIN(PurchaseFrequency),
    @MAX_PurchaseFrequency = MAX(PurchaseFrequency)
FROM U_StockRank
WHERE PurchaseFrequencyRank <= @Total * 0.001

UPDATE U_StockRank
SET PurchaseFrequencyScore = IIF(
    @MAX_PurchaseFrequency != @MIN_PurchaseFrequency,
    (PurchaseFrequency - @MIN_PurchaseFrequency) / (@MAX_PurchaseFrequency - @MIN_PurchaseFrequency) * 8 + 2,
    0
)
WHERE PurchaseFrequencyRank <= @Total * 0.001

/*其余*/
SELECT
    @MIN_PurchaseFrequency = MIN(PurchaseFrequency),
    @MAX_PurchaseFrequency = MAX(PurchaseFrequency)
FROM U_StockRank
WHERE PurchaseFrequencyRank > @Total * (1- 0.001)

UPDATE U_StockRank
SET PurchaseFrequencyScore = IIF(
    @MAX_PurchaseFrequency != @MIN_PurchaseFrequency,
    (PurchaseFrequency - @MIN_PurchaseFrequency) / (@MAX_PurchaseFrequency - @MIN_PurchaseFrequency) * 7 + 1,
    0
)
WHERE PurchaseFrequencyRank > @Total * (1- 0.001)

/*销售总额赋分*/
DECLARE @MIN_SumSaleMoney INT
DECLARE @MAX_SumSaleMoney INT
/*排名前0.1%*/
SELECT
    @MIN_SumSaleMoney = MIN(SumSaleMoney),
    @MAX_SumSaleMoney = MAX(SumSaleMoney)
FROM U_StockRank
WHERE SumSaleMoneyRank <= @Total * 0.004

UPDATE U_StockRank
SET SumSaleMoneyScore = IIF(
    @MAX_SumSaleMoney != @MIN_SumSaleMoney,
    (SumSaleMoney - @MIN_SumSaleMoney) / (@MAX_SumSaleMoney - @MIN_SumSaleMoney) * 2 + 8,
    0
)
WHERE SumSaleMoneyRank <= @Total * 0.004

/*其余*/
SELECT
    @MIN_SumSaleMoney = MIN(SumSaleMoney),
    @MAX_SumSaleMoney = MAX(SumSaleMoney)
FROM U_StockRank
WHERE SumSaleMoneyRank > @Total * (1- 0.004)

UPDATE U_StockRank
SET SumSaleMoneyScore = IIF(
    @MAX_SumSaleMoney != @MIN_SumSaleMoney,
    (SumSaleMoney - @MIN_SumSaleMoney) / (@MAX_SumSaleMoney - @MIN_SumSaleMoney) * 7 + 1,
    0
)
WHERE SumSaleMoneyRank > @Total * (1- 0.004)

/*采购总额赋分*/
DECLARE @MIN_SumPurchaseMoney INT
DECLARE @MAX_SumPurchaseMoney INT
/*排名前0.1%*/
SELECT
    @MIN_SumPurchaseMoney = MIN(SumPurchaseMoney),
    @MAX_SumPurchaseMoney = MAX(SumPurchaseMoney)
FROM U_StockRank
WHERE SumPurchaseMoneyRank <= @Total * 0.00254

UPDATE U_StockRank
SET SumPurchaseMoneyScore = IIF(
    @MAX_SumPurchaseMoney != @MIN_SumPurchaseMoney,
    (SumPurchaseMoney - @MIN_SumPurchaseMoney) / (@MAX_SumPurchaseMoney - @MIN_SumPurchaseMoney) * 2 + 8,
    0
)
WHERE SumPurchaseMoneyRank <= @Total * 0.00254

/*其余*/
SELECT
    @MIN_SumPurchaseMoney = MIN(SumPurchaseMoney),
    @MAX_SumPurchaseMoney = MAX(SumPurchaseMoney)
FROM U_StockRank
WHERE SumPurchaseMoneyRank > @Total * (1- 0.00254)

UPDATE U_StockRank
SET SumPurchaseMoneyScore = IIF(
    @MAX_SumPurchaseMoney != @MIN_SumPurchaseMoney,
    (SumPurchaseMoney - @MIN_SumPurchaseMoney) / (@MAX_SumPurchaseMoney - @MIN_SumPurchaseMoney) * 7 + 1,
    0
)
WHERE SumPurchaseMoneyRank > @Total * (1- 0.00254)

UPDATE U_StockRank
SET ToTalScore =
    InquiryFrequencyScore * 0.369 +
    InquiryCustomersScore  * 0.0528 +
    OrderCustomersScore * 0.0648 +
    DeliveryFrequencyScore * 0.1943 +
    DeliveryQuantityScore * 0.0569 +
    AverageProfitScore * 0.0576 +
    AveragePPriceAFVATScore * 0.0550+
    SumPurchaseQuantity * 0.0124 +
    PurchaseFrequencyScore * 0.0326 +
    SumSaleMoneyScore * 0.0303 +
    SumPurchaseMoneyScore * 0.0167
