/*各型号品牌在途库存数量*/
SELECT T_OPOR1.Dscription,
       T_OPOR1.U_Brand,
       SUM(T_OPOR1.OpenQty) AS OpenQty
FROM T_OPOR1
WHERE U_AreaType = 2
  AND LineStatus = 'O'
GROUP BY T_OPOR1.Dscription, T_OPOR1.U_Brand