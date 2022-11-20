DECLARE @Total INT
SELECT @Total = COUNT(*) FROM U_StockRank;

/*品牌所属型号赋分*/
DECLARE @MIN_BrandModleCount INT
DECLARE @MAX_BrandModleCount INT
/*排名前1.2587%*/
SELECT
    @MIN_BrandModleCount = MIN(BrandModleCount),
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
SELECT
    @MIN_BrandModleCount = MIN(BrandModleCount),
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


