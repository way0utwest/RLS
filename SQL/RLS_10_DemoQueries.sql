USE RLS
GO
EXECUTE AS USER = 'sjones'
SELECT OrderID, CustomerID, OrderTotal, SalesPersonID FROM dbo.OrderHeader AS oh 
GO
REVERT
GO
EXECUTE AS USER = 'bsmith'
SELECT OrderID, CustomerID, OrderTotal, SalesPersonID FROM dbo.OrderHeader AS oh 
GO
REVERT
GO
/*
ALTER SECURITY POLICY dbo.RLS_SalesPeople_Orders_Policy
  WITH (STATE = ON)
GO
SELECT top 10
 *
 FROM dbo.OrderHeader AS oh
SELECT top 10
 *
 FROM dbo.SalesPeople AS sp 
 
*/
