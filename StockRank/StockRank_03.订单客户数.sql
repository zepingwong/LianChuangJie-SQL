SELECT
-- COUNT(*)
    ISNULL(_FirstOrderCustomers.OrderCustomers, 0) AS OrderCustomersFirst, /*距今1个月订单客户数量*/
    ISNULL(_SecondOrderCustomers.OrderCustomers, 0) AS OrderCustomersSecond, /*距今2个月订单客户数量*/
    ISNULL(_ThirdOrderCustomers.OrderCustomers, 0) AS OrderCustomersThird, /*距今3个月订单客户数量*/
    ISNULL(_ForthOrderCustomers.OrderCustomers, 0) AS OrderCustomersForth, /*距今4-12个月订单客户数量*/
    (
        ISNULL(_FirstOrderCustomers.OrderCustomers, 0) * 0.1968 +
        ISNULL(_SecondOrderCustomers.OrderCustomers, 0) * 0.1217 +
        ISNULL(_ThirdOrderCustomers.OrderCustomers, 0) * 0.1217 +
        ISNULL(_ForthOrderCustomers.OrderCustomers, 0) * 0.0622
    ) AS OrderCustomers /*近一年加权订单客户数量*/
FROM (
    /*近一年询报价业务所涉及的品牌、型号*/
    SELECT
        U_ICIN1.Modle,
        U_ICIN1.Brand
    FROM
        U_ICIN1
    LEFT JOIN T_ICIN ON U_ICIN1.DocEntry = T_ICIN.DocEntry
    WHERE DATEDIFF(MONTH ,T_ICIN.InquiryDate, GETDATE( )) < 12
    GROUP BY
        U_ICIN1.Modle,
        U_ICIN1.Brand
) T
    /*距今1个月订单客户数量*/
    LEFT JOIN (
        SELECT COUNT(*) AS OrderCustomers, T_ORDR1.U_Brand, T_ORDR1.U_ItemName
        FROM T_ORDR1
        LEFT JOIN T_ORDR ON T_ORDR.DocEntry = T_ORDR1.DocEntry
        WHERE DATEDIFF( MONTH, T_ORDR.DocDate, GETDATE( ) ) = 0
        GROUP BY
        T_ORDR1.U_Brand,
        T_ORDR1.U_ItemName
    ) _FirstOrderCustomers ON _FirstOrderCustomers.U_Brand = T.Brand AND _FirstOrderCustomers.U_ItemName = T.Modle
    /*距今2个月订单客户数量*/
    LEFT JOIN (
        SELECT COUNT(*) AS OrderCustomers, T_ORDR1.U_Brand, T_ORDR1.U_ItemName
        FROM T_ORDR1
        LEFT JOIN T_ORDR ON T_ORDR.DocEntry = T_ORDR1.DocEntry
        WHERE DATEDIFF( MONTH, T_ORDR.DocDate, GETDATE( ) ) = 1
        GROUP BY
        T_ORDR1.U_Brand,
        T_ORDR1.U_ItemName
    ) _SecondOrderCustomers ON _SecondOrderCustomers.U_Brand = T.Brand AND _SecondOrderCustomers.U_ItemName = T.Modle
    /*距今3个月订单客户数量*/
    LEFT JOIN (
        SELECT COUNT(*) AS OrderCustomers, T_ORDR1.U_Brand, T_ORDR1.U_ItemName
        FROM T_ORDR1
        LEFT JOIN T_ORDR ON T_ORDR.DocEntry = T_ORDR1.DocEntry
        WHERE DATEDIFF( MONTH, T_ORDR.DocDate, GETDATE( ) ) = 2
        GROUP BY
        T_ORDR1.U_Brand,
        T_ORDR1.U_ItemName
    ) _ThirdOrderCustomers ON _ThirdOrderCustomers.U_Brand = T.Brand AND _ThirdOrderCustomers.U_ItemName = T.Modle
    /*距今3个月订单客户数量*/
    LEFT JOIN (
                SELECT COUNT(*) AS OrderCustomers, T_ORDR1.U_Brand, T_ORDR1.U_ItemName
        FROM T_ORDR1
        LEFT JOIN T_ORDR ON T_ORDR.DocEntry = T_ORDR1.DocEntry
        AND DATEDIFF( MONTH, T_ORDR.DocDate, GETDATE( ) ) > 2
        AND DATEDIFF( MONTH, T_ORDR.DocDate, GETDATE( ) ) < 12
        GROUP BY
        T_ORDR1.U_Brand,
        T_ORDR1.U_ItemName
    ) _ForthOrderCustomers ON _ForthOrderCustomers.U_Brand = T.Brand AND _ForthOrderCustomers.U_ItemName = T.Modle
