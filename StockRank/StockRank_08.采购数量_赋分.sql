DECLARE @Total INT
SELECT @Total = COUNT(*)
FROM U_StockRank;

/*08.采购数量_赋分*/
DECLARE @MIN_SumPurchaseQuantity INT
DECLARE @MAX_SumPurchaseQuantity INT
/*前0.781%*/

SELECT @MIN_SumPurchaseQuantity = MIN(SumPurchaseQuantity),
       @MAX_SumPurchaseQuantity = MAX(SumPurchaseQuantity)
FROM U_StockRank
WHERE SumPurchaseQuantityRank <= @Total * 0.00781

UPDATE U_StockRank
SET SumPurchaseQuantity = IIF(
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
SET SumPurchaseQuantity = IIF(
            @MAX_SumPurchaseQuantity != @MIN_SumPurchaseQuantity,
            (SumPurchaseQuantity - @MIN_SumPurchaseQuantity) / (@MAX_SumPurchaseQuantity - @MIN_SumPurchaseQuantity) *
            7 + 1, /*其余赋分1-8分*/
            1 /*特殊情况赋最低分1分*/
    )
WHERE SumPurchaseQuantityRank > @Total * 0.00781




