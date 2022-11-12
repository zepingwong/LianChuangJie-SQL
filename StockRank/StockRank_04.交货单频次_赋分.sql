DECLARE @Total INT
DECLARE @MIN_DeliveryFrequency INT
DECLARE @MAX_DeliveryFrequency INT
SELECT @Total = COUNT(*) FROM U_StockRank;

/*排名前0.1%*/
SELECT
    @MIN_DeliveryFrequency = MIN(DeliveryFrequency),
    @MAX_DeliveryFrequency = MAX(DeliveryFrequency)
FROM U_StockRank
WHERE DeliveryFrequencyRank <= @Total * 0.001

UPDATE U_StockRank
SET DeliveryFrequencyScore = (DeliveryFrequency - @MIN_DeliveryFrequency) / (@MAX_DeliveryFrequency - @MIN_DeliveryFrequency) * 8 + 2
WHERE DeliveryFrequencyRank <= @Total * 0.001

/*其余*/
SELECT
    @MIN_DeliveryFrequency = MIN(DeliveryFrequency),
    @MAX_DeliveryFrequency = MAX(DeliveryFrequency)
FROM U_StockRank
WHERE DeliveryFrequencyRank > @Total * (1- 0.001)

UPDATE U_StockRank
SET DeliveryFrequencyScore = (DeliveryFrequency - @MIN_DeliveryFrequency) / (@MAX_DeliveryFrequency - @MIN_DeliveryFrequency) * 0.99 + 1
WHERE DeliveryFrequencyRank > @Total * (1- 0.001)