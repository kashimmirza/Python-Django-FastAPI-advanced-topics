CREATE TABLE dbo.RelationalTable (
    RelationalTableID INT PRIMARY KEY IDENTITY,
    UniqueId INT,
    CompanyID INT,
    CONSTRAINT FK_RelationalTable_Employee FOREIGN KEY (UniqueId) REFERENCES Employee(UniqueId),
    CONSTRAINT FK_RelationalTable_Company FOREIGN KEY (CompanyID) REFERENCES CompanyTable(CompanyID)
);