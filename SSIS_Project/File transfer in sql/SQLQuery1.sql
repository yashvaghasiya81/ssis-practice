create database filetransfer
use filetransfer

CREATE TABLE Customers
(
    CustomerID INT PRIMARY KEY,
    CustomerName VARCHAR(100),
    City VARCHAR(50)
);

CREATE TABLE ProcessedFiles
(
    FileName VARCHAR(200) PRIMARY KEY,
    LoadDate DATETIME,
    Status VARCHAR(20)
);
select * from ProcessedFiles

EXEC sp_rename 'ProcessedFiles.FileName', 'FilePath', 'COLUMN';