USE rls
GO
CREATE TABLE dbo.Customer
( CustomerID INT
, CustomerName VARCHAR(200)
, CreditLimit money
)
GO
GRANT SELECT, INSERT, UPDATE, DELETE ON Customer TO bsmith, sjones
GO
INSERT dbo.Customer
(
    CustomerID,
    CustomerName,
    CreditLimit
)
VALUES
  (1, 'Acme', 1000)
, (2, 'AA Plumbing', 500)
, (3, 'Super Electrical Service', 2000)
GO
CREATE TABLE dbo.SalesCustomer
( SalesName VARCHAR(20)
, CustomerID int    
)
GO
GRANT SELECT, INSERT, UPDATE, DELETE ON dbo.Salesman TO bsmith, sjones
GO
INSERT SalesCustomer
GO
CREATE VIEW vCustomers
AS
