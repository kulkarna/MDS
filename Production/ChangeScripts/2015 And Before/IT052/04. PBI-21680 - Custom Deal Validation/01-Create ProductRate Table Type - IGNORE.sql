USE lp_mtm
GO

/* Create a table type. */
CREATE TYPE ProductRateTableType AS TABLE 
( ProductID VARCHAR(50)
, RateID INT );
GO

