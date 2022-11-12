/*采购价格赋分*/
/*采购价格>17000, 赋1分*/
UPDATE U_StockRank
SET AveragePPriceAFVATScore = 1
WHERE AveragePPriceAFVAT > 17000

/*13000<采购价格<=17000, 赋6分*/
UPDATE U_StockRank
SET AveragePPriceAFVATScore = 6
WHERE AveragePPriceAFVAT <= 17000
AND AveragePPriceAFVAT > 13000

/*8000<采购价格<=13000, 赋6分*/
UPDATE U_StockRank
SET AveragePPriceAFVATScore = 8
WHERE AveragePPriceAFVAT <= 13000
AND AveragePPriceAFVAT > 8000

/*采购价格<=8000, 赋10分*/
UPDATE U_StockRank
SET AveragePPriceAFVATScore = 10
WHERE AveragePPriceAFVAT <= 8000