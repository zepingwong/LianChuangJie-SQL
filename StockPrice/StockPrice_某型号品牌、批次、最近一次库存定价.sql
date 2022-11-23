SELECT DISTINCT kc_now.Brand,
                kc_now.ItemName,
                kc_now.Batch,
                kc_now.kc_price_final,
                kc_now.ConfirmDate
FROM (SELECT ItemName,
             Brand,
             Batch,
             MAX(ConfirmDate) AS ConfirmDate
      FROM kc_now
      WHERE Modify = 'Y'
        AND kc_price_final IS NOT NULL
      GROUP BY ItemName,
               Brand,
               Batch) LastDate
         LEFT JOIN kc_now ON kc_now.ItemName = LastDate.ItemName
    AND LastDate.Brand = kc_now.Brand
    AND LastDate.ConfirmDate = kc_now.ConfirmDate