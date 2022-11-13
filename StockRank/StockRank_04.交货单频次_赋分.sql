DECLARE @Total INT
SELECT @Total = COUNT(*) FROM U_StockRank;
/*交货单频次赋分*/
DECLARE @MIN_DeliveryFrequency INT
DECLARE @MAX_DeliveryFrequency INT
/*排名前0.1%*/
SELECT
    @MIN_DeliveryFrequency = MIN(DeliveryFrequency),
    @MAX_DeliveryFrequency = MAX(DeliveryFrequency)
FROM U_StockRank
WHERE DeliveryFrequencyRank <= @Total * 0.001

UPDATE U_StockRank
SET DeliveryFrequencyScore = IIF(
    @MAX_DeliveryFrequency != @MIN_DeliveryFrequency,
    (DeliveryFrequency - @MIN_DeliveryFrequency) / (@MAX_DeliveryFrequency - @MIN_DeliveryFrequency) * 2 + 8,
    1
)
WHERE DeliveryFrequencyRank <= @Total * 0.001

/*其余*/
SELECT
    @MIN_DeliveryFrequency = MIN(DeliveryFrequency),
    @MAX_DeliveryFrequency = MAX(DeliveryFrequency)
FROM U_StockRank
WHERE DeliveryFrequencyRank > @Total * (1- 0.001)

UPDATE U_StockRank
SET DeliveryFrequencyScore = IIF(
    @MAX_DeliveryFrequency != @MIN_DeliveryFrequency,
    (DeliveryFrequency - @MIN_DeliveryFrequency) / (@MAX_DeliveryFrequency - @MIN_DeliveryFrequency) * 7 + 1,
    1
)
WHERE DeliveryFrequencyRank > @Total * (1- 0.001)