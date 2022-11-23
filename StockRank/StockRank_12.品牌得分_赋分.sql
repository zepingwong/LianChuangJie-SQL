UPDATE
    U_StockRank
SET BrandScore = ISNULL(BrandSumPurchaseMoneyScore, 0) * 0.340 +
                 ISNULL(BrandSumPurchaseQuantityScore, 0) * 0.340 +
                 ISNULL(BrandSumSaleCustomersScore, 0) * 0.178 +
                 ISNULL(BrandSumPurchaseSuppliers, 0) * 0.099 +
                 ISNULL(BrandModleCountScore, 0) * 0.043
WHERE Modle IS NOT NULL
