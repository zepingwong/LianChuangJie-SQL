DECLARE @Total INT
DECLARE @MIN_InquiryFrequency INT
DECLARE @MAX_InquiryFrequency INT
SELECT @Total = COUNT(*) FROM U_StockRank;

SELECT
    @MIN_InquiryFrequency = MIN(InquiryFrequency),
    @MAX_InquiryFrequency = MAX(InquiryFrequency)
FROM U_StockRank
WHERE InquiryFrequencyRank < @Total * 0.091799

UPDATE U_StockRank
SET InquiryFrequencyScore = (InquiryFrequency - @MIN_InquiryFrequency) / (@MAX_InquiryFrequency - @MIN_InquiryFrequency) * 8 + 2
WHERE InquiryFrequencyRank < @Total * 0.091799