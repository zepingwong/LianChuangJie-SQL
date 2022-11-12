/*平均利润率赋分*/
DECLARE @MAX_AverageProfit DECIMAL
DECLARE @MIN_AverageProfit DECIMAL

/*利润率大于1*/
SELECT @MIN_AverageProfit = MIN(AverageProfit),
       @MAX_AverageProfit = MAX(AverageProfit)
FROM U_StockRank
WHERE AverageProfit > 1

UPDATE U_StockRank
SET AverageProfitScore = IIF(
    @MAX_AverageProfit != @MIN_AverageProfit,
    (AverageProfit - @MIN_AverageProfit) / (@MAX_AverageProfit-@MIN_AverageProfit) *3 + 7,
    0
)
WHERE AverageProfit > 1

/*利润率小于等于1大于等于0*/

SELECT @MIN_AverageProfit = MIN(AverageProfit),
       @MAX_AverageProfit = MAX(AverageProfit)
FROM U_StockRank
WHERE AverageProfit <= 1
AND AverageProfit >= 0

UPDATE U_StockRank
SET AverageProfitScore =  IIF(
    @MAX_AverageProfit != @MIN_AverageProfit,
    (AverageProfit - @MIN_AverageProfit) / (@MAX_AverageProfit - @MIN_AverageProfit) * 5 + 2,
    0
)
WHERE AverageProfit <= 1
AND AverageProfit >= 0

/*利润率小于零*/
SELECT @MIN_AverageProfit = MIN(AverageProfit),
       @MAX_AverageProfit = MAX(AverageProfit)
FROM U_StockRank
WHERE AverageProfit < 0

UPDATE U_StockRank
SET AverageProfitScore = IIF(
        @MAX_AverageProfit != @MIN_AverageProfit,
        (AverageProfit - @MIN_AverageProfit) / (@MAX_AverageProfit - @MIN_AverageProfit) + 1,
        0
)
WHERE AverageProfit < 0
