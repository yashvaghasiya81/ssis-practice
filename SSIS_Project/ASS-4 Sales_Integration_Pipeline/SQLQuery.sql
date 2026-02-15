-- This should return all sales with product names
SELECT 
    f.OrderId,
    f.ProductId,
    p.ProductCode,
    p.Category,
    f.CustomerId,
    c.CustomerName,
    f.Quantity,
    f.Amount
FROM Fact_Sales_Clean f
LEFT JOIN Dim_Product_master_table p ON f.ProductId = p.ProductId
LEFT JOIN Dim_Customer_master_table c ON f.CustomerId = c.CustomerId
ORDER BY f.OrderId;