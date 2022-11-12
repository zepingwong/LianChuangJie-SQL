/*01.询价频次*/
SELECT T.Modle,
       T.Brand,
       ISNULL(_FirstEnquiry1.InquiryFrequency, 0)                                                              AS InquiryFrequencyFirst1, /*贸易商类型客户距今1个月询价频次*/
       ISNULL(_FirstEnquiry2.InquiryFrequency, 0)                                                              AS InquiryFrequencyFirst2, /*终端类型客户距今1个月询价频次*/
       (ISNULL(_FirstEnquiry1.InquiryFrequency, 0) * 0.7 + ISNULL(_FirstEnquiry2.InquiryFrequency, 0) *
                                                           1.5)                                                AS InquiryFrequencyFirst, /*距今1个月询价频次*/
       ISNULL(_SecondEnquiry1.InquiryFrequency, 0)                                                             AS InquiryFrequencySecond1, /*贸易商类型客户距今2个月询价频次*/
       ISNULL(_SecondEnquiry2.InquiryFrequency, 0)                                                             AS InquiryFrequencySecond2, /*终端类型客户距今2个月询价频次*/
       (ISNULL(_SecondEnquiry1.InquiryFrequency, 0) * 0.7 + ISNULL(_SecondEnquiry2.InquiryFrequency, 0) *
                                                            1.5)                                               AS InquiryFrequencySecond, /*距今2个月询价频次*/
       ISNULL(_ThirdEnquiry1.InquiryFrequency, 0)                                                              AS InquiryFrequencyThird1, /*贸易商类型客户距今3个月询价频次*/
       ISNULL(_ThirdEnquiry2.InquiryFrequency, 0)                                                              AS InquiryFrequencyThird2, /*终端类型客户距今3个月询价频次*/
       (ISNULL(_ThirdEnquiry1.InquiryFrequency, 0) * 0.7 + ISNULL(_ThirdEnquiry2.InquiryFrequency, 0) *
                                                           1.5)                                                AS InquiryFrequencyThird, /*距今3个月询价频次*/
       ISNULL(_ForthEnquiry1.InquiryFrequency, 0)                                                              AS InquiryFrequencyForth1, /*贸易商类型客户距今4-12个月询价频次*/
       ISNULL(_ForthEnquiry2.InquiryFrequency, 0)                                                              AS InquiryFrequencyForth2, /*终端类型客户距今4-12个月询价频次*/
       (ISNULL(_ForthEnquiry1.InquiryFrequency, 0) * 0.7 + ISNULL(_ForthEnquiry2.InquiryFrequency, 0) *
                                                           1.5)                                                AS InquiryFrequencyForth, /*距今4-12个月询价频次*/
       (
                   (ISNULL(_ForthEnquiry1.InquiryFrequency, 0) * 0.7 +
                    ISNULL(_ForthEnquiry2.InquiryFrequency, 0) * 1.5) * 0.0622 +
                   (ISNULL(_ThirdEnquiry1.InquiryFrequency, 0) * 0.7 +
                    ISNULL(_ThirdEnquiry2.InquiryFrequency, 0) * 1.5) * 0.1217 +
                   (ISNULL(_SecondEnquiry1.InquiryFrequency, 0) * 0.7 +
                    ISNULL(_SecondEnquiry2.InquiryFrequency, 0) * 1.5) * 0.1217 +
                   (ISNULL(_FirstEnquiry1.InquiryFrequency, 0) * 0.7 +
                    ISNULL(_FirstEnquiry2.InquiryFrequency, 0) * 1.5) * 0.1968
           )                                                                                                   AS InquiryFrequency /*近一年加权询价频次*/
FROM (SELECT 1                                            AS DocEntry,
             ROW_NUMBER() OVER ( ORDER BY U_ICIN1.Modle ) AS LineNum,
             U_ICIN1.Modle,
             U_ICIN1.Brand
      FROM U_ICIN1
      GROUP BY U_ICIN1.Modle,
               U_ICIN1.Brand) T
         /*贸易商类型客户距今一个月询价频次，询价客户数*/
         LEFT JOIN (SELECT U_ICIN1.Brand,
                           U_ICIN1.Modle,
                           COUNT(*)               AS InquiryFrequency, /*询价频次*/
                           COUNT(DISTINCT T_ICIN.CardName) AS InquiryCustomers /*询价客户数*/
                    FROM U_ICIN1
                             LEFT JOIN T_ICIN ON T_ICIN.DocEntry = U_ICIN1.DocEntry
                    WHERE DATEDIFF(MONTH, T_ICIN.InquiryDate, GETDATE()) = 0
                      AND T_ICIN.U_CusGroupCode IN (N'关系型贸易商', N'一般贸易商', N'其它')
                    GROUP BY U_ICIN1.Brand,
                             U_ICIN1.Modle) _FirstEnquiry1
                   ON _FirstEnquiry1.Modle = T.Modle AND _FirstEnquiry1.Brand = T.Brand
    /*终端类型客户距今一个月询价频次，询价客户数*/
         LEFT JOIN (SELECT U_ICIN1.Brand,
                           U_ICIN1.Modle,
                           COUNT(*)               AS InquiryFrequency, /*询价频次*/
                           COUNT(DISTINCT T_ICIN.CardName) AS InquiryCustomers /*询价客户数*/
                    FROM U_ICIN1
                             LEFT JOIN T_ICIN ON T_ICIN.DocEntry = U_ICIN1.DocEntry
                    WHERE DATEDIFF(MONTH, T_ICIN.InquiryDate, GETDATE()) = 0
                      AND T_ICIN.U_CusGroupCode IN ('OEM/EMS', N'终端用户')
                    GROUP BY U_ICIN1.Brand,
                             U_ICIN1.Modle) _FirstEnquiry2
                   ON _FirstEnquiry2.Modle = T.Modle AND _FirstEnquiry2.Brand = T.Brand


    /*贸易商类型客户距今两个月询价频次，询价客户数*/
         LEFT JOIN (SELECT U_ICIN1.Brand,
                           U_ICIN1.Modle,
                           COUNT(*)               AS InquiryFrequency, /*询价频次*/
                           COUNT(DISTINCT T_ICIN.CardName) AS InquiryCustomers /*询价客户数*/
                    FROM U_ICIN1
                             LEFT JOIN T_ICIN ON T_ICIN.DocEntry = U_ICIN1.DocEntry
                    WHERE DATEDIFF(MONTH, T_ICIN.InquiryDate, GETDATE()) = 1
                      AND T_ICIN.U_CusGroupCode IN (N'关系型贸易商', N'一般贸易商', N'其它')
                    GROUP BY U_ICIN1.Brand,
                             U_ICIN1.Modle) _SecondEnquiry1
                   ON _SecondEnquiry1.Modle = T.Modle AND _SecondEnquiry1.Brand = T.Brand
    /*终端类型客户距今两个月询价频次，询价客户数*/
         LEFT JOIN (SELECT U_ICIN1.Brand,
                           U_ICIN1.Modle,
                           COUNT(*)               AS InquiryFrequency, /*询价频次*/
                           COUNT(DISTINCT T_ICIN.CardName) AS InquiryCustomers /*询价客户数*/
                    FROM U_ICIN1
                             LEFT JOIN T_ICIN ON T_ICIN.DocEntry = U_ICIN1.DocEntry
                    WHERE DATEDIFF(MONTH, T_ICIN.InquiryDate, GETDATE()) = 1
                      AND T_ICIN.U_CusGroupCode IN ('OEM/EMS', N'终端用户')
                    GROUP BY U_ICIN1.Brand,
                             U_ICIN1.Modle) _SecondEnquiry2
                   ON _SecondEnquiry2.Modle = T.Modle AND _SecondEnquiry2.Brand = T.Brand

    /*贸易商类型客户距今三个月询价频次，询价客户数*/
         LEFT JOIN (SELECT U_ICIN1.Brand,
                           U_ICIN1.Modle,
                           COUNT(*)               AS InquiryFrequency, /*询价频次*/
                           COUNT(DISTINCT T_ICIN.CardName) AS InquiryCustomers /*询价客户数*/
                    FROM U_ICIN1
                             LEFT JOIN T_ICIN ON T_ICIN.DocEntry = U_ICIN1.DocEntry
                    WHERE DATEDIFF(MONTH, T_ICIN.InquiryDate, GETDATE()) = 2
                      AND T_ICIN.U_CusGroupCode IN (N'关系型贸易商', N'一般贸易商', N'其它')
                    GROUP BY U_ICIN1.Brand,
                             U_ICIN1.Modle) _ThirdEnquiry1
                   ON _ThirdEnquiry1.Modle = T.Modle AND _ThirdEnquiry1.Brand = T.Brand
    /*终端类型客户距今三个月询价频次，询价客户数*/
         LEFT JOIN (SELECT U_ICIN1.Brand,
                           U_ICIN1.Modle,
                           COUNT(*)               AS InquiryFrequency, /*询价频次*/
                           COUNT(DISTINCT T_ICIN.CardName) AS InquiryCustomers /*询价客户数*/
                    FROM U_ICIN1
                             LEFT JOIN T_ICIN ON T_ICIN.DocEntry = U_ICIN1.DocEntry
                    WHERE DATEDIFF(MONTH, T_ICIN.InquiryDate, GETDATE()) = 2
                      AND T_ICIN.U_CusGroupCode IN ('OEM/EMS', N'终端用户')
                    GROUP BY U_ICIN1.Brand,
                             U_ICIN1.Modle) _ThirdEnquiry2
                   ON _ThirdEnquiry2.Modle = T.Modle AND _ThirdEnquiry2.Brand = T.Brand

    /*贸易商类型客户距今4-12个月询价频次，询价客户数*/
         LEFT JOIN (SELECT U_ICIN1.Brand,
                           U_ICIN1.Modle,
                           COUNT(*)               AS InquiryFrequency, /*询价频次*/
                           COUNT(DISTINCT T_ICIN.CardName) AS InquiryCustomers /*询价客户数*/
                    FROM U_ICIN1
                             LEFT JOIN T_ICIN ON T_ICIN.DocEntry = U_ICIN1.DocEntry
                    WHERE DATEDIFF(MONTH, T_ICIN.InquiryDate, GETDATE()) > 2
                      AND DATEDIFF(MONTH, T_ICIN.InquiryDate, GETDATE()) < 12
                      AND T_ICIN.U_CusGroupCode IN (N'关系型贸易商', N'一般贸易商', N'其它')
                    GROUP BY U_ICIN1.Brand,
                             U_ICIN1.Modle) _ForthEnquiry1
                   ON _ForthEnquiry1.Modle = T.Modle AND _ForthEnquiry1.Brand = T.Brand
    /*终端类型客户距今4-12个月询价频次，询价客户数*/
         LEFT JOIN (SELECT U_ICIN1.Brand,
                           U_ICIN1.Modle,
                           COUNT(*)               AS InquiryFrequency, /*询价频次*/
                           COUNT(DISTINCT T_ICIN.CardName) AS InquiryCustomers /*询价客户数*/
                    FROM U_ICIN1
                             LEFT JOIN T_ICIN ON T_ICIN.DocEntry = U_ICIN1.DocEntry
                    WHERE DATEDIFF(MONTH, T_ICIN.InquiryDate, GETDATE()) > 2
                      AND DATEDIFF(MONTH, T_ICIN.InquiryDate, GETDATE()) < 12
                      AND T_ICIN.U_CusGroupCode IN ('OEM/EMS', N'终端用户')
                    GROUP BY U_ICIN1.Brand,
                             U_ICIN1.Modle) _ForthEnquiry2
                   ON _ForthEnquiry2.Modle = T.Modle AND _ForthEnquiry2.Brand = T.Brand