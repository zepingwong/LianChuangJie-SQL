DECLARE @Total INT
SELECT @Total = COUNT(*)
FROM U_StockRank;
/*04.销售订单频次_赋分*/
DECLARE @MIN_DeliveryFrequency INT
DECLARE @MAX_DeliveryFrequency INT
/*排名前0.1%*/
SELECT @MIN_DeliveryFrequency = MIN(DeliveryFrequency),
       @MAX_DeliveryFrequency = MAX(DeliveryFrequency)
FROM U_StockRank
WHERE DeliveryFrequencyRank <= @Total * 0.001

UPDATE U_StockRank
SET DeliveryFrequencyScore = IIF(
            @MAX_DeliveryFrequency != @MIN_DeliveryFrequency,
            (DeliveryFrequency - @MIN_DeliveryFrequency) / (@MAX_DeliveryFrequency - @MIN_DeliveryFrequency) * 2 +
            8, /*排名前0.1% 赋分8-10分*/
            1 /*特殊情况赋最低分1分*/
    )
WHERE DeliveryFrequencyRank <= @Total * 0.001

/*其余*/
SELECT @MIN_DeliveryFrequency = MIN(DeliveryFrequency),
       @MAX_DeliveryFrequency = MAX(DeliveryFrequency)
FROM U_StockRank
WHERE DeliveryFrequencyRank > @Total * 0.001

UPDATE U_StockRank
SET DeliveryFrequencyScore = IIF(
            @MAX_DeliveryFrequency != @MIN_DeliveryFrequency,
            (DeliveryFrequency - @MIN_DeliveryFrequency) / (@MAX_DeliveryFrequency - @MIN_DeliveryFrequency) * 7 +
            1, /*其余赋分 1-8分*/
            1 /*特殊情况赋最低分1分*/
    )
WHERE DeliveryFrequencyRank > @Total * 0.001