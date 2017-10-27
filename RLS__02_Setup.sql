CREATE DATABASE RLS
GO
USE RLS
GO
CREATE USER bsmith WITHOUT LOGIN
CREATE USER sjones WITHOUT LOGIN
GO
CREATE TABLE SalesPerson
  (
    SalesPersonID INT IDENTITY(1, 1)
                      PRIMARY KEY
  , SalesFirstName VARCHAR(200)
  , SalesLastName VARCHAR(200)
  , username VARCHAR(100)
  , IsManager BIT
  );
GO
INSERT dbo.SalesPerson
  VALUES
    ( 'Bob', 'Smith', 'bsmith', 0 )
,   ( 'Sally', 'Jones', 'sjones', 0 )
,   ( 'Kathy', 'Johnson', 'kjohnson', 1 ); 
GO
CREATE TABLE OrderHeader
  (
    OrderID INT IDENTITY(1, 1)
                PRIMARY KEY
  , Orderdate DATETIME2(3)
  , CustomerID INT
  , OrderTotal NUMERIC(12, 4)
  , OrderComplete TINYINT
  , SalesPersonID INT
  , CONSTRAINT OrderHeader_SalesPerson_SalesPersonID FOREIGN KEY (SalesPersonID) REFERENCES dbo.SalesPerson (SalesPersonID)
  );
GO
SET IDENTITY_INSERT dbo.OrderHeader ON;
INSERT dbo.OrderHeader
    ( OrderID, Orderdate, CustomerID, OrderTotal, OrderComplete, SalesPersonID )
  VALUES
    ( 1001, '2016/01/12', 1, 5000.00, 1, 1 )
,   ( 1002, '2016/01/23', 2, 1250.25, 1, 2 )
,   ( 1003, '2016/01/23', 1, 922.50, 1, 2 )
,   ( 1004, '2016/01/24', 3, 125.00, 0, 1 )
,   ( 1005, '2016/02/03', 3, 4200.99, 0, 3 )
,   ( 1006, '2016/02/13', 2, 1652.89, 1, 2 );
SET IDENTITY_INSERT dbo.OrderHeader OFF;
GO
GRANT SELECT ON dbo.SalesPerson TO sjones, bsmith
GRANT SELECT ON dbo.OrderHeader TO sjones, bsmith
GO

CREATE FUNCTION dbo.RLS_SalesPerson_OrderCheck ( @salespersonid INT )
RETURNS TABLE
    WITH SCHEMABINDING
AS
RETURN
    SELECT
            1 AS [RLS_SalesPerson_OrderCheck_Result]
        FROM
            dbo.SalesPerson sp
        WHERE
            (
              @salespersonid = sp.SalesPersonID
              OR sp.IsManager = 1
            )
            AND USER_NAME() = sp.username;
go


/*
The security policy maps the function to a particular table. 

Note that the parameter used here must exist in our table (OrderHeader)
CREATE SECURITY POLICY - https://msdn.microsoft.com/en-us/library/dn765135.aspx

*/
CREATE SECURITY POLICY dbo.RLS_SalesPeople_Orders_Policy
  ADD FILTER PREDICATE dbo.RLS_SalesPerson_OrderCheck(salespersonid)
  ON dbo.OrderHeader;

