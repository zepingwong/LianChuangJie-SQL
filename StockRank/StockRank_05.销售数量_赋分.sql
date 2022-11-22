DECLARE @Total INT
SELECT @Total = COUNT(*)
FROM U_StockRank;
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
            (DeliveryQuantity - @MIN_DeliveryQuantity) / (@MAX_DeliveryQuantity - @MIN_DeliveryQuantity) * 8 + 2, /*排名前0.7% 赋分2-10分 */
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
            (DeliveryQuantity - @MIN_DeliveryQuantity) / (@MAX_DeliveryQuantity - @MIN_DeliveryQuantity) * 7 + 1, /*其余 赋分1-8分 */
            1 /*特殊情况赋最低分1分*/
    )
WHERE DeliveryQuantityRank > @Total * 0.007