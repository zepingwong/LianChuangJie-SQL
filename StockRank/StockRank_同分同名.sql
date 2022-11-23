SELECT a.*,
       排名= (SELECT COUNT(*) FROM U_StockRank WHERE U_StockRank.TotalScore > a.TotalScore) + 1
FROM U_StockRank a
ORDER BY 排名