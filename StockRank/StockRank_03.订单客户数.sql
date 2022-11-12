SELECT
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
        SELECT COUNT(*) AS OrderCustomers, ItemName AS Modle, Brand
        FROM U_OIVL
        WHERE BaseName IN (N'采购入库', N'交货单')
        AND DATEDIFF( MONTH, DocDate, GETDATE( ) ) = 0
        GROUP BY
        U_OIVL.Brand,
        U_OIVL.ItemName
    ) _FirstOrderCustomers ON _FirstOrderCustomers.Brand = T.Brand AND _FirstOrderCustomers.Modle = T.Modle
    /*距今2个月订单客户数量*/
    LEFT JOIN (
        SELECT COUNT(*) AS OrderCustomers, ItemName AS Modle, Brand
        FROM U_OIVL
        WHERE BaseName IN (N'采购入库', N'交货单')
        AND DATEDIFF( MONTH, DocDate, GETDATE( ) ) = 1
        GROUP BY
        U_OIVL.Brand,
        U_OIVL.ItemName
    ) _SecondOrderCustomers ON _SecondOrderCustomers.Brand = T.Brand AND _SecondOrderCustomers.Modle = T.Modle
    /*距今3个月订单客户数量*/
    LEFT JOIN (
        SELECT COUNT(*) AS OrderCustomers, ItemName AS Modle, Brand
        FROM U_OIVL
        WHERE BaseName IN (N'采购入库', N'交货单')
        AND DATEDIFF( MONTH, DocDate, GETDATE( ) ) = 2
        GROUP BY
        U_OIVL.Brand,
        U_OIVL.ItemName
    ) _ThirdOrderCustomers ON _ThirdOrderCustomers.Brand = T.Brand AND _ThirdOrderCustomers.Modle = T.Modle
    /*距今3个月订单客户数量*/
    LEFT JOIN (
        SELECT COUNT(*) AS OrderCustomers, ItemName AS Modle, Brand
        FROM U_OIVL
        WHERE BaseName IN (N'采购入库', N'交货单')
        AND DATEDIFF( MONTH, DocDate, GETDATE( ) ) > 2
        AND DATEDIFF( MONTH, DocDate, GETDATE( ) ) < 12
        GROUP BY
        U_OIVL.Brand,
        U_OIVL.ItemName
    ) _ForthOrderCustomers ON _ForthOrderCustomers.Brand = T.Brand AND _ForthOrderCustomers.Modle = T.Modle
