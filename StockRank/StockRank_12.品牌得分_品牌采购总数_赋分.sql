DECLARE @Total INT
SELECT @Total = COUNT(*) FROM U_StockRank;

/*品牌采购总数赋分*/
DECLARE @MIN_BrandSumPurchaseQuantity INT
DECLARE @MAX_BrandSumPurchaseQuantity INT
/*排名前3.4965%*/
SELECT
    @MIN_BrandSumPurchaseQuantity = MIN(BrandSumPurchaseQuantity),
    @MAX_BrandSumPurchaseQuantity = MAX(BrandSumPurchaseQuantity)
FROM U_StockRank
WHERE SumPurchaseMoneyRank <= @Total * 0.034965

UPDATE U_StockRank
SET BrandSumPurchaseQuantityScore = IIF(
    @MAX_BrandSumPurchaseQuantity != @MIN_BrandSumPurchaseQuantity,
    (BrandSumPurchaseQuantity - @MIN_BrandSumPurchaseQuantity) / (@MAX_BrandSumPurchaseQuantity - @MIN_BrandSumPurchaseQuantity) * 2 + 8,
    1
)
WHERE SumPurchaseMoneyRank <= @Total * 0.034965

/*其余*/
SELECT
    @MIN_BrandSumPurchaseQuantity = MIN(BrandSumPurchaseQuantity),
    @MAX_BrandSumPurchaseQuantity = MAX(BrandSumPurchaseQuantity)
FROM U_StockRank
WHERE SumPurchaseMoneyRank > @Total * 0.034965

UPDATE U_StockRank
SET BrandSumPurchaseQuantityScore = IIF(
    @MAX_BrandSumPurchaseQuantity != @MIN_BrandSumPurchaseQuantity,
    (BrandSumPurchaseQuantity - @MIN_BrandSumPurchaseQuantity) / (@MAX_BrandSumPurchaseQuantity - @MIN_BrandSumPurchaseQuantity) * 7 + 1,
    1
)
WHERE SumPurchaseMoneyRank > @Total * 0.034965


