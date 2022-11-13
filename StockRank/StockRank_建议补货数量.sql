SELECT
    /*（最近三个月贸易商询价数量-最近三个月贸易商成单数量）*0.7+（最近三个月终端客户询价数量-最近三个月终端客户成单数量）*/
    (InquiryDemandQty1 - OIVL1.Quantity) * 0.7 + (InquiryDemandQty2 - OIVL2.Quantity) +
    /*近三个月成单数量*/
    (OIVL2.Quantity + OIVL1.Quantity)
FROM U_StockRank
LEFT JOIN (
    SELECT
        U_OIVL.ItemName, U_OIVL.Brand,
        SUM(U_OIVL.Quantity) AS Quantity /*成交数量*/
    FROM U_OIVL
    LEFT JOIN T_OCRD ON T_OCRD.CardCode = U_OIVL.CardCode
    WHERE BaseName = N'交货单'
    AND U_OIVL.CardCode IN (N'关系型贸易商', N'一般贸易商', N'其它')
    AND DATEDIFF(MONTH , U_OIVL.DocDate, GETDATE()) <= 2
    GROUP BY U_OIVL.ItemName, U_OIVL.Brand
) OIVL1 ON OIVL1.Brand = U_StockRank.Brand AND  OIVL1.ItemName = U_StockRank.Modle /*贸易商成交数量*/
LEFT JOIN (
    SELECT
        U_OIVL.ItemName, U_OIVL.Brand,
        SUM(U_OIVL.Quantity) AS Quantity /*成交数量*/
    FROM U_OIVL
    LEFT JOIN T_OCRD ON T_OCRD.CardCode = U_OIVL.CardCode
    WHERE BaseName = N'交货单'
    AND U_OIVL.CardCode IN ('OEM/EMS', N'终端用户')
    AND DATEDIFF(MONTH , U_OIVL.DocDate, GETDATE()) <= 2
    GROUP BY U_OIVL.ItemName, U_OIVL.Brand
) OIVL2 ON OIVL2.Brand = U_StockRank.Brand AND  OIVL2.ItemName = U_StockRank.Modle /*终端客户成交数量*/
LEFT JOIN (
            SELECT
                T_OBTN.ItemName,
                SUM(T.Quantity - T_OBTN.U_LockQty) AS Quantity
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
        T_OPOR1.U_ItemName,
        T_OPOR1.U_Brand,
        SUM(T_OPOR1.OpenQty) AS OpenQty
    FROM T_OPOR1
    GROUP BY T_OPOR1.U_ItemName, U_Brand
) OpenQuantity ON OpenQuantity.U_ItemName = U_StockRank.Modle AND OpenQuantity.U_Brand = U_StockRank.Brand /*在途库存*/
