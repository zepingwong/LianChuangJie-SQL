DECLARE @Total INT
SELECT @Total = COUNT(*) FROM U_StockRank;

/*销售总额赋分*/
DECLARE @MIN_SumSaleMoney INT
DECLARE @MAX_SumSaleMoney INT
/*排名前0.1%*/
SELECT
    @MIN_SumSaleMoney = MIN(SumSaleMoney),
    @MAX_SumSaleMoney = MAX(SumSaleMoney)
FROM U_StockRank
WHERE SumSaleMoneyRank <= @Total * 0.004

UPDATE U_StockRank
SET SumSaleMoneyScore = IIF(
    @MAX_SumSaleMoney != @MIN_SumSaleMoney,
    (SumSaleMoney - @MIN_SumSaleMoney) / (@MAX_SumSaleMoney - @MIN_SumSaleMoney) * 2 + 8,
    1
)
WHERE SumSaleMoneyRank <= @Total * 0.004

/*其余*/
SELECT
    @MIN_SumSaleMoney = MIN(SumSaleMoney),
    @MAX_SumSaleMoney = MAX(SumSaleMoney)
FROM U_StockRank
WHERE SumSaleMoneyRank > @Total * (1- 0.004)

UPDATE U_StockRank
SET SumSaleMoneyScore = IIF(
    @MAX_SumSaleMoney != @MIN_SumSaleMoney,
    (SumSaleMoney - @MIN_SumSaleMoney) / (@MAX_SumSaleMoney - @MIN_SumSaleMoney) * 7 + 1,
    1
)
WHERE SumSaleMoneyRank > @Total * (1- 0.004)