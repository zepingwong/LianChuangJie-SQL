/*各种货币最近一次汇率*/
SELECT T.* INTO #ExchangeRate
FROM (
    SELECT
        T_ORTT.Currency,
        T_ORTT.Rate
    FROM (
        SELECT
            Currency,
            MAX(RateDate) AS RateDate
        FROM T_ORTT
        GROUP BY Currency
    ) Latest
    LEFT JOIN T_ORTT ON T_ORTT.Currency = Latest.Currency AND T_ORTT.RateDate = Latest.RateDate
    UNION ALL
    SELECT
        'RMB'    AS 'Currency',
        1.000000 AS 'Rate'
) T

SELECT
    T_OPOR1.U_Brand,
    SUM(T_OPOR1.Quantity * T_OPOR1.U_PriceAfVAT * ExchangeRate.Rate) AS SumSale
FROM T_OPOR1
LEFT JOIN #ExchangeRate ExchangeRate ON ExchangeRate.Currency = T_OPOR1.U_Currency
GROUP BY U_Brand