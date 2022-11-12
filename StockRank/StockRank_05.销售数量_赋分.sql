DECLARE @Total INT
DECLARE @MIN_DeliveryQuantity INT
DECLARE @MAX_DeliveryQuantity INT
SELECT @Total = COUNT(*) FROM U_StockRank;

/*排名前0.1%*/
SELECT
    @MIN_DeliveryQuantity = MIN(DeliveryQuantity),
    @MAX_DeliveryQuantity = MAX(DeliveryQuantity)
FROM U_StockRank
WHERE DeliveryQuantityRank <= @Total * 0.001

UPDATE U_StockRank
SET DeliveryQuantityScore = (DeliveryQuantity - @MIN_DeliveryQuantity) / (@MAX_DeliveryQuantity - @MIN_DeliveryQuantity) * 8 + 2
WHERE DeliveryQuantityRank <= @Total * 0.001

/*其余*/
SELECT
    @MIN_DeliveryQuantity = MIN(DeliveryQuantity),
    @MAX_DeliveryQuantity = MAX(DeliveryQuantity)
FROM U_StockRank
WHERE DeliveryQuantityRank > @Total * (1- 0.001)

UPDATE U_StockRank
SET DeliveryQuantityScore = (DeliveryQuantity - @MIN_DeliveryQuantity) / (@MAX_DeliveryQuantity - @MIN_DeliveryQuantity) * 0.99 + 1
WHERE DeliveryQuantityRank > @Total * (1- 0.001)