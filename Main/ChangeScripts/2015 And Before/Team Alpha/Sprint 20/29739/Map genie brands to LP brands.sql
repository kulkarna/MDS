USE GENIE
GO
-- To build the update script, run this below.
--SELECT
--	 'UPDATE GENIE..LK_Brand SET LPProductBrandID = ' + CAST(PB.ProductBrandID as nvarchar(4)) + ' WHERE BrandID = ' + CAST(GB.BrandID as nvarchar(4)) [SCRIPT]
--	,GB.BrandID
--	,GB.Brand
--	,PB.ProductBrandID
--FROM GENIE..LK_Brand GB
--INNER JOIN GENIE..LK_Genie_LP_Brand_Mapping M on M.GenieBrandId = GB.BrandID
--INNER JOIN LibertyPower..ProductBrand PB on PB.Name = M.LPBrandDescription
--GO

BEGIN TRANSACTION
SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
COMMIT
BEGIN TRANSACTION
GO
IF COL_LENGTH('dbo.LK_BRAND', 'LPProductBrandID') IS NULL
BEGIN
ALTER TABLE dbo.LK_Brand ADD
	LPProductBrandID int NOT NULL CONSTRAINT DF_LK_Brand_LPProductBrandID DEFAULT -1


ALTER TABLE dbo.LK_Brand SET (LOCK_ESCALATION = TABLE)
END
GO
COMMIT

--UPDATE RECORDS
BEGIN TRANSACTION
	UPDATE GENIE..LK_Brand SET LPProductBrandID = 1 WHERE BrandID = 18;
	UPDATE GENIE..LK_Brand SET LPProductBrandID = 1 WHERE BrandID = 8;
	UPDATE GENIE..LK_Brand SET LPProductBrandID = 1 WHERE BrandID = 22;
	UPDATE GENIE..LK_Brand SET LPProductBrandID = 1 WHERE BrandID = 10;
	UPDATE GENIE..LK_Brand SET LPProductBrandID = 1 WHERE BrandID = 11;
	UPDATE GENIE..LK_Brand SET LPProductBrandID = 1 WHERE BrandID = 12;
	UPDATE GENIE..LK_Brand SET LPProductBrandID = 1 WHERE BrandID = 13;
	UPDATE GENIE..LK_Brand SET LPProductBrandID = 2 WHERE BrandID = 20;
	UPDATE GENIE..LK_Brand SET LPProductBrandID = 2 WHERE BrandID = 19;
	UPDATE GENIE..LK_Brand SET LPProductBrandID = 2 WHERE BrandID = 14;
	UPDATE GENIE..LK_Brand SET LPProductBrandID = 4 WHERE BrandID = 27;
	UPDATE GENIE..LK_Brand SET LPProductBrandID = 4 WHERE BrandID = 15;
	UPDATE GENIE..LK_Brand SET LPProductBrandID = 4 WHERE BrandID = 28;
	UPDATE GENIE..LK_Brand SET LPProductBrandID = 4 WHERE BrandID = 16;
	UPDATE GENIE..LK_Brand SET LPProductBrandID = 8 WHERE BrandID = 2;
	UPDATE GENIE..LK_Brand SET LPProductBrandID = 8 WHERE BrandID = 3;
	UPDATE GENIE..LK_Brand SET LPProductBrandID = 9 WHERE BrandID = 5;
	UPDATE GENIE..LK_Brand SET LPProductBrandID = 10 WHERE BrandID = 1;
	UPDATE GENIE..LK_Brand SET LPProductBrandID = 13 WHERE BrandID = 21;
	UPDATE GENIE..LK_Brand SET LPProductBrandID = 13 WHERE BrandID = 6;
	UPDATE GENIE..LK_Brand SET LPProductBrandID = 13 WHERE BrandID = 7;
	UPDATE GENIE..LK_Brand SET LPProductBrandID = 14 WHERE BrandID = 9;
	UPDATE GENIE..LK_Brand SET LPProductBrandID = 14 WHERE BrandID = 4;
	UPDATE GENIE..LK_Brand SET LPProductBrandID = 18 WHERE BrandID = 24;
	UPDATE GENIE..LK_Brand SET LPProductBrandID = 18 WHERE BrandID = 23;
	UPDATE GENIE..LK_Brand SET LPProductBrandID = 19 WHERE BrandID = 25;
	UPDATE GENIE..LK_Brand SET LPProductBrandID = 19 WHERE BrandID = 26;
	UPDATE GENIE..LK_Brand SET LPProductBrandID = 23 WHERE BrandID = 30;
	UPDATE GENIE..LK_Brand SET LPProductBrandID = 23 WHERE BrandID = 29;
	UPDATE GENIE..LK_Brand SET LPProductBrandID = 22 WHERE BrandID = 31;
	UPDATE GENIE..LK_Brand SET LPProductBrandID = 23 WHERE BrandID = 32;
	UPDATE GENIE..LK_Brand SET LPProductBrandID = 22 WHERE BrandID = 33;
	UPDATE GENIE..LK_Brand SET LPProductBrandID = 22 WHERE BrandID = 34;
	UPDATE GENIE..LK_Brand SET LPProductBrandID = 21 WHERE BrandID = 35;
	UPDATE GENIE..LK_Brand SET LPProductBrandID = 21 WHERE BrandID = 36;
COMMIT
