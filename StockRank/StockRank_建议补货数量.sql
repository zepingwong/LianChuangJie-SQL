SELECT
    /*（最近三个月贸易商询价数量-最近三个月贸易商成单数量）*0.7+（最近三个月终端客户询价数量-最近三个月终端客户成单数量）*/
    (ISNULL(InquiryDemandQty1, 0) - ISNULL(ORDR1.SumQuantity, 0)) * 0.7 + (ISNULL(InquiryDemandQty2, 0) - ISNULL(ORDR2.SumQuantity, 0)) +
    /*近三个月成单数量*/
    ISNULL(ORDR2.SumQuantity + ORDR1.SumQuantity, 0)
FROM U_StockRank
LEFT JOIN (
    SELECT
        SUM(T_ORDR1.Quantity) AS SumQuantity, /*销售数量*/
        T_ORDR1.U_Brand,
        T_ORDR1.Dscription
    FROM T_ORDR1
    LEFT JOIN T_ORDR ON T_ORDR.DocEntry = T_ORDR1.DocEntry
    WHERE T_ORDR.U_GroupName IN (N'其它', N'一般贸易商', N'关系型贸易商')
    AND DATEDIFF(MONTH , T_ORDR.DocDate, GETDATE()) <= 2
    GROUP BY
        T_ORDR1.U_Brand,
        T_ORDR1.Dscription
) ORDR1 ON ORDR1.U_Brand = U_StockRank.Brand AND  ORDR1.Dscription = U_StockRank.Modle /*贸易商成交数量*/
LEFT JOIN (
    SELECT
        SUM(T_ORDR1.Quantity) AS SumQuantity, /*销售数量*/
        T_ORDR1.U_Brand,
        T_ORDR1.Dscription
    FROM T_ORDR1
    LEFT JOIN T_ORDR ON T_ORDR.DocEntry = T_ORDR1.DocEntry
    WHERE T_ORDR.U_GroupName IN (N'其它', N'一般贸易商', N'关系型贸易商')
    AND DATEDIFF(MONTH , T_ORDR.DocDate, GETDATE()) <= 2
    GROUP BY
        T_ORDR1.U_Brand,
        T_ORDR1.Dscription
) ORDR2 ON ORDR2.U_Brand = U_StockRank.Brand AND  ORDR2.Dscription = U_StockRank.Modle /*终端客户成交数量*/
LEFT JOIN (
    SELECT
        T_OBTN.ItemName,
        SUM(
            CASE
                WHEN T.Quantity = 0 THEN 0
                WHEN T.Quantity < T_OBTN.U_LockQty THEN T.Quantity
                ELSE T_OBTN.U_LockQty
            END
        ) AS Quantity
    FROM (
        SELECT
            MdAbsEntry,
            SUM(Quantity) AS Quantity
        FROM T_OBTQ
        GROUP BY MdAbsEntry
    ) T
    INNER JOIN T_OBTN ON T.MdAbsEntry = T_OBTN.AbsEntry
    GROUP BY ItemName
) StockQuantity ON StockQuantity.ItemName = U_StockRank.Modle /*现有库存*/
LEFT JOIN (
    SELECT
        T_OPOR1.Dscription,
        T_OPOR1.U_Brand,
        SUM(T_OPOR1.OpenQty) AS OpenQty
    FROM T_OPOR1
    WHERE U_AreaType = 2 AND LineStatus ='O'
    GROUP BY T_OPOR1.Dscription, T_OPOR1.U_Brand
) OpenQuantity ON OpenQuantity.Dscription = U_StockRank.Modle AND OpenQuantity.U_Brand = U_StockRank.Brand /*在途库存*/
