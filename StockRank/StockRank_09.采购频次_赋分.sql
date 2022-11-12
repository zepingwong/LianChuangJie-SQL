DECLARE @Total INT
DECLARE @MIN_PurchaseFrequency INT
DECLARE @MAX_PurchaseFrequency INT
SELECT @Total = COUNT(*) FROM U_StockRank;

/*排名前0.1%*/
SELECT
    @MIN_PurchaseFrequency = MIN(PurchaseFrequency),
    @MAX_PurchaseFrequency = MAX(PurchaseFrequency)
FROM U_StockRank
WHERE PurchaseFrequencyRank <= @Total * 0.001

UPDATE U_StockRank
SET PurchaseFrequencyScore = IIF(
    @MAX_PurchaseFrequency != @MIN_PurchaseFrequency,
    (PurchaseFrequency - @MIN_PurchaseFrequency) / (@MAX_PurchaseFrequency - @MIN_PurchaseFrequency) * 8 + 2,
    0
)
WHERE PurchaseFrequencyRank <= @Total * 0.001

/*其余*/
SELECT
    @MIN_PurchaseFrequency = MIN(PurchaseFrequency),
    @MAX_PurchaseFrequency = MAX(PurchaseFrequency)
FROM U_StockRank
WHERE PurchaseFrequencyRank > @Total * (1- 0.001)

UPDATE U_StockRank
SET PurchaseFrequencyScore = IIF(
    @MAX_PurchaseFrequency != @MIN_PurchaseFrequency,
    (PurchaseFrequency - @MIN_PurchaseFrequency) / (@MAX_PurchaseFrequency - @MIN_PurchaseFrequency) * 7 + 1,
    0
)
WHERE PurchaseFrequencyRank > @Total * (1- 0.001)