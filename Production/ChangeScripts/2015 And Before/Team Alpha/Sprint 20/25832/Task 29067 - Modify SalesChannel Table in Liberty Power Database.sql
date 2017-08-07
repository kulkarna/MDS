Use LibertyPower
GO

ALTER TABLE SalesChannel ALTER COLUMN [ChannelDescription] varchar(200) NULL;
GO

ALTER TABLE SalesChannel ADD MarginLimit  decimal(12,5) NOT NULL DEFAULT 0.00000;
GO

ALTER TABLE SalesChannel ADD EnableTemplate bit NOT NULL DEFAULT 0;
GO
