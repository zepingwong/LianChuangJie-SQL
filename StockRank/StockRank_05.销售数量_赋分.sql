DECLARE @Total INT
SELECT @Total = COUNT(*) FROM U_StockRank;
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
    1
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
    1
)
WHERE DeliveryQuantityRank > @Total * (1- 0.007)