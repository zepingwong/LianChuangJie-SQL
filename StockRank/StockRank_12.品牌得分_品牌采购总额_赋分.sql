DECLARE @Total INT
SELECT @Total = COUNT(*)
FROM U_StockRank;

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


