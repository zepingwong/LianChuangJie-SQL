DECLARE @Total INT
SELECT @Total = COUNT(*) FROM U_StockRank;

/*品牌客户赋分*/
DECLARE @MIN_BrandSumSaleCustomers INT
DECLARE @MAX_BrandSumSaleCustomers INT
/*排名前1.1189%*/
SELECT
    @MIN_BrandSumSaleCustomers = MIN(BrandSumSaleCustomers),
    @MAX_BrandSumSaleCustomers = MAX(BrandSumSaleCustomers)
FROM U_StockRank
WHERE SumPurchaseMoneyRank <= @Total * 0.011189

UPDATE U_StockRank
SET BrandSumSaleCustomersScore = IIF(
    @MAX_BrandSumSaleCustomers != @MIN_BrandSumSaleCustomers,
    (BrandSumSaleCustomers - @MIN_BrandSumSaleCustomers) / (@MAX_BrandSumSaleCustomers - @MIN_BrandSumSaleCustomers) * 2 + 8,
    1
)
WHERE SumPurchaseMoneyRank <= @Total * 0.011189

/*其余*/
SELECT
    @MIN_BrandSumSaleCustomers = MIN(BrandSumSaleCustomers),
    @MAX_BrandSumSaleCustomers = MAX(BrandSumSaleCustomers)
FROM U_StockRank
WHERE SumPurchaseMoneyRank > @Total * 0.011189

UPDATE U_StockRank
SET BrandSumSaleCustomersScore = IIF(
    @MAX_BrandSumSaleCustomers != @MIN_BrandSumSaleCustomers,
    (BrandSumSaleCustomers - @MIN_BrandSumSaleCustomers) / (@MAX_BrandSumSaleCustomers - @MIN_BrandSumSaleCustomers) * 7 + 1,
    1
)
WHERE SumPurchaseMoneyRank > @Total * 0.011189


