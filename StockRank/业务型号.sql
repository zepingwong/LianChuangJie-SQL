/*询报价业务涉及到的型号及对应品牌*/
SELECT
    ROW_NUMBER() OVER ( ORDER BY U_ICIN1.Modle ) AS LineNum,
    U_ICIN1.Modle,
    U_ICIN1.Brand
FROM U_ICIN1
GROUP BY
    U_ICIN1.Modle,
    U_ICIN1.Brand

/*询报价所涉及的品牌和型号数量*/
SELECT COUNT(*) FROM (
SELECT
    U_ICIN1.Modle,
    U_ICIN1.Brand
FROM U_ICIN1
GROUP BY
    U_ICIN1.Modle,
    U_ICIN1.Brand
) T