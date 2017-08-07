USE [LibertyPower]
GO

/****** Adds new columns to audit creation and modification of the Zip table ******/

ALTER TABLE Zip ADD CreatedBy INT NULL;
ALTER TABLE Zip ADD CreatedDate DATETIME NULL DEFAULT GETDATE();
ALTER TABLE Zip ADD ModifiedBy INT NULL;
ALTER TABLE Zip ADD ModifiedDate DATETIME NULL DEFAULT GETDATE();
GO

/****** Updates new audit columns with starting default values ******/

UPDATE Zip SET CreatedBy=1029;
UPDATE Zip SET CreatedDate='1/1/2014';
UPDATE Zip SET ModifiedBy=1029;
UPDATE Zip SET ModifiedDate='1/1/2014';
GO
