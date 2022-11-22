DECLARE @Total INT
SELECT @Total = COUNT(*)
FROM U_StockRank;

/*01.询价频次_赋分*/
DECLARE @MIN_InquiryFrequency INT
DECLARE @MAX_InquiryFrequency INT
/*排名前9.1799%*/
SELECT @MIN_InquiryFrequency = MIN(InquiryFrequency),
       @MAX_InquiryFrequency = MAX(InquiryFrequency)
FROM U_StockRank
WHERE InquiryFrequencyRank <= @Total * 0.091799

UPDATE U_StockRank
SET InquiryFrequencyScore = IIF(
            @MIN_InquiryFrequency != @MAX_InquiryFrequency,
            (InquiryFrequency - @MIN_InquiryFrequency) / (@MAX_InquiryFrequency - @MIN_InquiryFrequency) * 8 +
            2, /*排名前9.1799% 2-10分*/
            1 /*特殊情况赋最低分1分*/
    )
WHERE InquiryFrequencyRank <= @Total * 0.091799

/*其余*/
SELECT @MIN_InquiryFrequency = MIN(InquiryFrequency),
       @MAX_InquiryFrequency = MAX(InquiryFrequency)
FROM U_StockRank
WHERE InquiryFrequencyRank > @Total * 0.091799

UPDATE U_StockRank
SET InquiryFrequencyScore = IIF(
            @MIN_InquiryFrequency != @MAX_InquiryFrequency,
            (InquiryFrequency - @MIN_InquiryFrequency) / (@MAX_InquiryFrequency - @MIN_InquiryFrequency) * 0.99 +
            1, /*其余 1-1.99分*/
            1 /*特殊情况赋最低分1分*/
    )
WHERE InquiryFrequencyRank > @Total * 0.091799