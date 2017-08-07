-- ================================================
-- Template generated from Template Explorer using:
-- Create Procedure (New Menu).SQL
--
-- Use the Specify Values for Template Parameters 
-- command (Ctrl-Shift-M) to fill in the parameter 
-- values below.
--
-- This block of comments will not be included in
-- the definition of the procedure.
-- ================================================
use LibertyPower
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
IF OBJECT_ID ( 'usp_GetZipCodeDataByZipCode', 'P' ) IS NOT NULL 
    DROP PROCEDURE usp_GetZipCodeDataByZipCode;
GO

CREATE PROCEDURE usp_GetZipCodeDataByZipCode
    @ZipCode varchar(5)
AS 

    SET NOCOUNT ON;
	SELECT Zip.id, Zip.ZipCode, Zip.Latitude, Zip.Longitude, Zip.State, Zip.City, Zip.MarketID, Zip.UtilityID, Zip.ZoneID, County, Market.RetailMktDescp, Utility.FullName, Utility.UtilityCode, Zone.ZoneCode
	FROM Zip
	JOIN Utility on Zip.UtilityID = Utility.ID
	JOIN Zone on Zip.ZoneID = Zone.ID
	JOIN Market on Zip.MarketID = Market.ID
	WHERE Zip.ZipCode = @ZipCode
GO


