DECLARE @MIN_InquiryFrequency INT
DECLARE @MAX_InquiryFrequency INT

SELECT
    @MIN_InquiryFrequency = MIN(InquiryCustomers),
    @MAX_InquiryFrequency = MAX(InquiryCustomers)
FROM U_StockRank

UPDATE U_StockRank
SET InquiryCustomersScore = (InquiryCustomers - @MIN_InquiryFrequency) / (@MAX_InquiryFrequency - @MIN_InquiryFrequency) * 9 + 1
WHERE 1=1