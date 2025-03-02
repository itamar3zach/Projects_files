--EXERSICE 1
WITH cte
AS
(SELECT YEAR(O.OrderDate) AS YEAR
,SUM(OL.UnitPrice * OL.Quantity) AS IncomePerYear
,COUNT(DISTINCT MONTH(O.OrderDate)) AS NumberOfDistinctMonths
,FORMAT(ROUND(SUM(OL.UnitPrice * OL.Quantity) / COUNT(DISTINCT MONTH(O.OrderDate)) * 12, 2), '.00') AS YearlyLinearIncome
FROM Sales.Orders O JOIN Sales.OrderLines OL
ON O.OrderID = OL.OrderID
JOIN Sales.Invoices I
ON I.OrderID = O.OrderID
GROUP BY YEAR(O.OrderDate))
SELECT * ,ROUND((CAST(YearlyLinearIncome AS float) - CAST(LAG(YearlyLinearIncome,1)OVER(ORDER BY YEAR) AS float)) / CAST(LAG(YearlyLinearIncome,1)OVER(ORDER BY YEAR) AS float) *100, 2) AS GrowthRate
FROM cte



--EXERSICE 2
WITH cte1
AS 
(SELECT C.CustomerID AS CustomerID
,YEAR(O.OrderDate) AS TheYear
,DATEPART(Q, O.OrderDate) AS TheQuarter
,C.CustomerName AS CustomerName
,SUM(IL.UnitPrice * IL.Quantity) AS IncomePerYear
FROM Sales.Customers C JOIN Sales.Orders O
ON C.CustomerID = O.CustomerID
JOIN Sales.Invoices I
ON O.OrderID = I.OrderID
JOIN Sales.InvoiceLines IL
ON I.InvoiceID = IL.InvoiceID
GROUP BY C.CustomerID, YEAR(O.OrderDate), DATEPART(Q, O.OrderDate), C.CustomerName
),
cte2 AS 
(SELECT *
,DENSE_RANK() OVER (PARTITION BY TheYear, TheQuarter ORDER BY IncomePerYear DESC) AS DNR
FROM cte1)

SELECT TheYear, TheQuarter, CustomerName, IncomePerYear, DNR
FROM cte2
WHERE DNR <= 5



--EXERSICE 3
WITH cte
AS
(SELECT S.StockItemID, S.StockItemName, SUM((I.ExtendedPrice - I.TaxAmount)) AS TotalProfit
FROM Warehouse.StockItems S JOIN Sales.InvoiceLines I
ON S.StockItemID = I.StockItemID
GROUP BY S.StockItemID, S.StockItemName)
SELECT TOP 10 *
FROM cte
ORDER BY TotalProfit DESC



--EXERSICE 4
SELECT ROW_NUMBER()OVER(ORDER BY (RecommendedRetailPrice - UnitPrice) DESC) AS Rn
,StockItemID, StockItemName, UnitPrice, RecommendedRetailPrice
,(RecommendedRetailPrice - UnitPrice) AS NominalProductProfit
,DENSE_RANK()OVER(ORDER BY (RecommendedRetailPrice - UnitPrice) DESC) AS DNR
FROM Warehouse.StockItems
WHERE ValidTo > GETDATE()



--EXERSICE 5
SELECT CAST(P.SupplierID AS varchar) + ' - ' + P.SupplierName AS SupplierDetails
,STRING_AGG(CAST(S.StockItemID AS varchar) + ' ' + S.StockItemName, '/, ') AS ProductDetails 
FROM Warehouse.StockItems S JOIN Purchasing.Suppliers P
ON S.SupplierID = P.SupplierID
GROUP BY P.SupplierID, P.SupplierName
ORDER BY P.SupplierID



--EXERSICE 6
SELECT TOP 5 C.CustomerID, CI.CityName, CO.CountryName, CO.Continent, CO.Region
,FORMAT(SUM(IL.ExtendedPrice), '#,#.00') AS TotalExtendedPrice
FROM Sales.InvoiceLines IL JOIN Sales.Invoices I
ON IL.InvoiceID = I.InvoiceID
JOIN Sales.Customers C
ON I.CustomerID = C.CustomerID
JOIN Application.Cities CI
ON CI.CityID = C.PostalCityID
JOIN Application.StateProvinces SP
ON SP.StateProvinceID = CI.StateProvinceID
JOIN Application.Countries CO
ON CO.CountryID = SP.CountryID
GROUP BY C.CustomerID, CI.CityName, CO.CountryName, CO.Continent, CO.Region
ORDER BY SUM(IL.ExtendedPrice) DESC



--EXERSICE 7
WITH cte
AS
(
SELECT X.OrderYear
,CAST(X.OrderMonth AS varchar) AS "OrderMonth" 
,FORMAT(X.MonthlyTotal, '##,##.00') AS "MonthlyTotal"
,FORMAT(X.CumulativeTotal, '##,##.00') AS "CumulativeTotal"
,X.OrderMonth AS MMM
FROM
(SELECT YEAR(O.OrderDate) AS OrderYear
,MONTH(O.OrderDate) AS OrderMonth
,SUM(OL.PickedQuantity * OL.UnitPrice) AS MonthlyTotal
,SUM(SUM(OL.PickedQuantity * OL.UnitPrice))OVER(PARTITION BY YEAR(O.OrderDate) ORDER BY YEAR(O.OrderDate), MONTH(O.OrderDate)) AS CumulativeTotal
FROM Sales.Orders O JOIN Sales.OrderLines OL
ON O.OrderID = OL.OrderID
GROUP BY YEAR(O.OrderDate), MONTH(O.OrderDate)) X

UNION ALL

SELECT YEAR(O.OrderDate) AS OrderYear
,'Grand Total' AS OrderMonth
,FORMAT(SUM(OL.PickedQuantity * OL.UnitPrice), '##,##.00') AS "MonthlyTotal"
,FORMAT(SUM(OL.PickedQuantity * OL.UnitPrice), '##,##.00') AS "CumulativeTotal"
,13 AS MMM
FROM Sales.Orders O JOIN Sales.OrderLines OL
ON O.OrderID = OL.OrderID
GROUP BY YEAR(O.OrderDate)
)
SELECT OrderYear, OrderMonth, MonthlyTotal, CumulativeTotal
FROM cte
ORDER BY OrderYear, MMM



--EXERSICE 8
SELECT OrderMonth, [2013],[2014],[2015],[2016]
FROM (SELECT OrderID, YEAR(OrderDate) AS YY, MONTH(OrderDate) AS OrderMonth
      FROM Sales.Orders) X
PIVOT (COUNT(OrderID) FOR YY IN ([2013],[2014],[2015],[2016])) pvt
ORDER BY OrderMonth



--EXERSICE 9
WITH cte
AS
(SELECT C.CustomerID, C.CustomerName, O.OrderDate
,LAG(O.OrderDate, 1)OVER(PARTITION BY C.CustomerID ORDER BY O.OrderDate) AS PreviousOrderDate
,DATEDIFF(DD, MAX(O.OrderDate)OVER(PARTITION BY C.CustomerID), (SELECT MAX(OrderDate) FROM Sales.Orders)) AS DaysSinceLastOrder
,(DATEDIFF(DD, MIN(O.OrderDate)OVER(PARTITION BY C.CustomerID), MAX(O.OrderDate)OVER(PARTITION BY C.CustomerID))) / COUNT(O.OrderDate)OVER(PARTITION BY C.CustomerID) AS AvgDaysBetweenOrders
FROM Sales.Orders O JOIN Sales.Customers C
ON O.CustomerID = C.CustomerID)
SELECT *
,CASE WHEN DaysSinceLastOrder > AvgDaysBetweenOrders * 2 THEN 'Potential Churn'
      ELSE 'Active'
END AS CustomerStatus
FROM cte



--EXERSICE 10
WITH cte1
AS
(SELECT CC.CustomerCategoryName AS CustomerCategoryName
           ,CASE WHEN C.CustomerName LIKE '%Tailspin%' THEN REPLACE(C.CustomerName, C.CustomerName, 'Tailspin')
            WHEN C.CustomerName LIKE '%Wingtip%' THEN REPLACE(C.CustomerName, C.CustomerName, 'Wingtip')
			ELSE C.CustomerName
	   END AS CustomerName
FROM Sales.CustomerCategories CC JOIN Sales.Customers C
ON CC.CustomerCategoryID = C.CustomerCategoryID
GROUP BY CC.CustomerCategoryName, C.CustomerID, C.CustomerName),
cte2 AS
(SELECT CustomerCategoryName 
,COUNT(DISTINCT CustomerName) AS CustomerCOUNT
FROM cte1
GROUP BY CustomerCategoryName)

SELECT *
,(SELECT SUM(CustomerCOUNT) FROM cte2) AS TotalCustCount
,CONCAT((CAST(CustomerCOUNT AS money)) / (SELECT SUM(CustomerCOUNT) FROM cte2) * 100, '%') AS DistributaionFactor
FROM cte2
