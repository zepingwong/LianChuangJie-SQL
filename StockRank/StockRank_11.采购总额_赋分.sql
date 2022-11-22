DECLARE @Total INT
SELECT @Total = COUNT(*)
FROM U_StockRank;

/*11.采购总额_赋分*/
DECLARE @MIN_SumPurchaseMoney INT
DECLARE @MAX_SumPurchaseMoney INT
/*排名前0.254%*/
SELECT @MIN_SumPurchaseMoney = MIN(SumPurchaseMoney),
       @MAX_SumPurchaseMoney = MAX(SumPurchaseMoney)
FROM U_StockRank
WHERE SumPurchaseMoneyRank <= @Total * 0.00254

UPDATE U_StockRank
SET SumPurchaseMoneyScore = IIF(
            @MAX_SumPurchaseMoney != @MIN_SumPurchaseMoney,
            (SumPurchaseMoney - @MIN_SumPurchaseMoney) / (@MAX_SumPurchaseMoney - @MIN_SumPurchaseMoney) * 2 +
            8, /*排名前0.254% 赋分8-10分*/
            1 /*特殊情况赋最低分1分*/
    )
WHERE SumPurchaseMoneyRank <= @Total * 0.00254

/*其余*/
SELECT @MIN_SumPurchaseMoney = MIN(SumPurchaseMoney),
       @MAX_SumPurchaseMoney = MAX(SumPurchaseMoney)
FROM U_StockRank
WHERE SumPurchaseMoneyRank > @Total * 0.00254

UPDATE U_StockRank
SET SumPurchaseMoneyScore = IIF(
            @MAX_SumPurchaseMoney != @MIN_SumPurchaseMoney,
            (SumPurchaseMoney - @MIN_SumPurchaseMoney) / (@MAX_SumPurchaseMoney - @MIN_SumPurchaseMoney) * 7 +
            1, /*排名前0.254% 赋分1-8分*/
            1 /*特殊情况赋最低分1分*/
    )
WHERE SumPurchaseMoneyRank > @Total * 0.00254