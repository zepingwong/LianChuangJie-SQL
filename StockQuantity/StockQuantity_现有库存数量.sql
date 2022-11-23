/*各型号品牌现有库存数量*/
SELECT T_OBTN.ItemName,
       StockBrand.Brand,
       SUM(
               CASE
                   WHEN T.Quantity = 0 THEN 0
                   WHEN T.Quantity < T_OBTN.U_LockQty THEN T.Quantity
                   ELSE T_OBTN.U_LockQty
                   END
           ) AS Quantity
FROM (SELECT MdAbsEntry,
             SUM(Quantity) AS Quantity
      FROM T_OBTQ
      GROUP BY MdAbsEntry) T
         INNER JOIN T_OBTN ON T.MdAbsEntry = T_OBTN.AbsEntry
         LEFT JOIN (
    /*通过物料编码字段 匹配 T_OITM（物料主数据表）的品牌*/
    SELECT T_OBTN.ItemName,
           IIF(ISNULL(T_OITM.U_QuoBrand, '') = '', T_OITM.U_Brand, T_OITM.U_QuoBrand) AS Brand
    FROM T_OBTN
             INNER JOIN T_OITM ON T_OBTN.ItemCode = T_OITM.ItemCode) StockBrand ON StockBrand.ItemName = T_OBTN.ItemName
GROUP BY T_OBTN.ItemName, StockBrand.Brand