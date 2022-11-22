/*0.7采购价格_赋分*/
UPDATE U_StockRank
SET AveragePPriceAFVATScore = 1 /*采购价格大于17000, 赋1分*/
WHERE AveragePPriceAFVAT > 17000

UPDATE U_StockRank
SET AveragePPriceAFVATScore = 6 /*13000大于采购价格小于等于17000, 赋6分*/
WHERE AveragePPriceAFVAT <= 17000
  AND AveragePPriceAFVAT > 13000

UPDATE U_StockRank
SET AveragePPriceAFVATScore = 8 /*8000大于采购价格小于等于13000, 赋6分*/
WHERE AveragePPriceAFVAT <= 13000
  AND AveragePPriceAFVAT > 8000

UPDATE U_StockRank
SET AveragePPriceAFVATScore = 10 /*采购价格小于等于8000, 赋10分*/
WHERE AveragePPriceAFVAT <= 8000