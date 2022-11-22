UPDATE U_StockRank
SET ToTalScore =
                InquiryFrequencyScore * 0.369 +
                InquiryCustomersScore * 0.0528 +
                OrderCustomersScore * 0.0648 +
                DeliveryFrequencyScore * 0.1943 +
                DeliveryQuantityScore * 0.0569 +
                AverageProfitScore * 0.0576 +
                AveragePPriceAFVATScore * 0.0550 +
                SumPurchaseQuantity * 0.0124 +
                PurchaseFrequencyScore * 0.0326 +
                SumSaleMoneyScore * 0.0303 +
                SumPurchaseMoneyScore * 0.0167
WHERE Modle IS NOT NULL