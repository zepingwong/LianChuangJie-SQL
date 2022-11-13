DECLARE @Total INT
SELECT @Total = COUNT(*) FROM U_StockRank;

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
    1
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
    1
)
WHERE SumPurchaseQuantityRank > @Total * 0.00781




