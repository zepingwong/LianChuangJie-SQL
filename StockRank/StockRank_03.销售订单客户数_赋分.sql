/*03.销售订单客户数_赋分*/
DECLARE @MIN_OrderCustomers INT
DECLARE @MAX_OrderCustomers INT

SELECT @MIN_OrderCustomers = MIN(OrderCustomers),
       @MAX_OrderCustomers = MAX(OrderCustomers)
FROM U_StockRank

UPDATE U_StockRank
SET OrderCustomersScore = IIF(
            @MAX_OrderCustomers != @MIN_OrderCustomers,
            (OrderCustomers - @MIN_OrderCustomers) / (@MAX_OrderCustomers - @MIN_OrderCustomers) * 9 +
            1, /*订单客户数赋分 1-10*/
            1 /*特殊情况赋最低分1分*/
    )
WHERE Modle IS NOT NULL