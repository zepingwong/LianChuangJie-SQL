DECLARE @Total INT
SELECT @Total = COUNT(*) FROM U_StockRank;

/*采购频次赋分*/
DECLARE @MIN_PurchaseFrequency INT
DECLARE @MAX_PurchaseFrequency INT
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
    1
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
    1
)
WHERE PurchaseFrequencyRank > @Total * (1- 0.001)