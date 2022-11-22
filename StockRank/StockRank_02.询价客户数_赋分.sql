/*02.询价客户数_赋分*/
DECLARE @MIN_InquiryCustomers INT
DECLARE @MAX_InquiryCustomers INT

SELECT @MIN_InquiryCustomers = MIN(InquiryCustomers),
       @MAX_InquiryCustomers = MAX(InquiryCustomers)
FROM U_StockRank

UPDATE U_StockRank
SET InquiryCustomersScore = IIF(
            @MAX_InquiryCustomers != @MIN_InquiryCustomers,
            (InquiryCustomers - @MIN_InquiryCustomers) / (@MAX_InquiryCustomers - @MIN_InquiryCustomers) * 9 + 1, /*询价客户数赋分 1-10*/
            1 /*特殊情况赋最低分1分*/
    )
WHERE Modle IS NOT NULL