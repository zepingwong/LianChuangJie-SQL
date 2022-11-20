DECLARE @Total INT
SELECT @Total = COUNT(*) FROM U_StockRank;

/*品牌供应商数量赋分*/
DECLARE @MIN_BrandSumPurchaseSuppliers INT
DECLARE @MAX_BrandSumPurchaseSuppliers INT
/*排名前3.2168%*/
SELECT
    @MIN_BrandSumPurchaseSuppliers = MIN(BrandSumPurchaseSuppliers),
    @MAX_BrandSumPurchaseSuppliers = MAX(BrandSumPurchaseSuppliers)
FROM U_StockRank
WHERE SumPurchaseMoneyRank <= @Total * 0.032168

UPDATE U_StockRank
SET BrandSumPurchaseSuppliersScore = IIF(
    @MAX_BrandSumPurchaseSuppliers != @MIN_BrandSumPurchaseSuppliers,
    (BrandSumPurchaseSuppliers - @MIN_BrandSumPurchaseSuppliers) / (@MAX_BrandSumPurchaseSuppliers - @MIN_BrandSumPurchaseSuppliers) * 2 + 8,
    1
)
WHERE SumPurchaseMoneyRank <= @Total * 0.032168

/*其余*/
SELECT
    @MIN_BrandSumPurchaseSuppliers = MIN(BrandSumPurchaseSuppliers),
    @MAX_BrandSumPurchaseSuppliers = MAX(BrandSumPurchaseSuppliers)
FROM U_StockRank
WHERE SumPurchaseMoneyRank > @Total * 0.032168

UPDATE U_StockRank
SET BrandSumPurchaseSuppliersScore = IIF(
    @MAX_BrandSumPurchaseSuppliers != @MIN_BrandSumPurchaseSuppliers,
    (BrandSumPurchaseSuppliers - @MIN_BrandSumPurchaseSuppliers) / (@MAX_BrandSumPurchaseSuppliers - @MIN_BrandSumPurchaseSuppliers) * 7 + 1,
    1
)
WHERE SumPurchaseMoneyRank > @Total * 0.032168


