DECLARE @MIN_OrderCustomers INT
DECLARE @MAX_OrderCustomers INT

SELECT
    @MIN_OrderCustomers = MIN(OrderCustomers),
    @MAX_OrderCustomers = MAX(OrderCustomers)
FROM U_StockRank

UPDATE U_StockRank
SET OrderCustomersScore = (OrderCustomers - @MIN_OrderCustomers) / (@MAX_OrderCustomers - @MIN_OrderCustomers) * 9 + 1