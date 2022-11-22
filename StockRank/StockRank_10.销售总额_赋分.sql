DECLARE @Total INT
SELECT @Total = COUNT(*)
FROM U_StockRank;

/*10.销售总额_赋分*/
DECLARE @MIN_SumSaleMoney INT
DECLARE @MAX_SumSaleMoney INT
/*排名前0.4%*/
SELECT @MIN_SumSaleMoney = MIN(SumSaleMoney),
       @MAX_SumSaleMoney = MAX(SumSaleMoney)
FROM U_StockRank
WHERE SumSaleMoneyRank <= @Total * 0.004

UPDATE U_StockRank
SET SumSaleMoneyScore = IIF(
            @MAX_SumSaleMoney != @MIN_SumSaleMoney,
            (SumSaleMoney - @MIN_SumSaleMoney) / (@MAX_SumSaleMoney - @MIN_SumSaleMoney) * 2 + 8, /*排名前0.4% 赋分8-10分*/
            1 /*特殊情况赋最低分1分*/
    )
WHERE SumSaleMoneyRank <= @Total * 0.004

/*其余*/
SELECT @MIN_SumSaleMoney = MIN(SumSaleMoney),
       @MAX_SumSaleMoney = MAX(SumSaleMoney)
FROM U_StockRank
WHERE SumSaleMoneyRank > @Total * 0.004

UPDATE U_StockRank
SET SumSaleMoneyScore = IIF(
            @MAX_SumSaleMoney != @MIN_SumSaleMoney,
            (SumSaleMoney - @MIN_SumSaleMoney) / (@MAX_SumSaleMoney - @MIN_SumSaleMoney) * 7 + 1, /*其余 赋分1-8分*/
            1 /*特殊情况赋最低分1分*/
    )
WHERE SumSaleMoneyRank > @Total * 0.004