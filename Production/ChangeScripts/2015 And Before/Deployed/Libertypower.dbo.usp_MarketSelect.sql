USE [LibertyPower]
GO

BEGIN TRANSACTION CONSTRUCTION
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO


-- EXEC LibertyPower..usp_MarketSelect 'SSCOTT', @MarketID = 13, @retail_mkt_id = 'IL'
-- EXEC LibertyPower..usp_MarketSelect 'SSCOTT', @retail_mkt_id = 'IL'
-- EXEC LibertyPower..usp_MarketSelect 'SSCOTT', @MarketID = 13
-- EXEC LibertyPower..usp_MarketSelect 'SSCOTT'

IF OBJECT_ID ( '[dbo].[usp_MarketSelect]', 'P' ) IS NOT NULL 
    DROP PROCEDURE [dbo].[usp_MarketSelect]
GO

CREATE PROCEDURE [dbo].[usp_MarketSelect] 
(@p_username		nchar(100)
,@p_current_page	int			= 1
,@p_page_size		int			= 100
,@retail_mkt_id		char(02)	= NULL
,@MarketID			INT			= NUll)
AS

-- =============================================
-- Author:		Sheri Scott
-- Create date: 05/10/2012
-- Description:	Returns Retail Market information for an input Retail Market ID.
-- =============================================

BEGIN
	SET NOCOUNT ON;
	
	DECLARE @recordCount	INT
	DECLARE @startRowIndex	INT
	
	SET @startRowIndex = ((@p_current_page * @p_page_size) - @p_page_size) + 1
	SET @recordCount = (SELECT COUNT(*) FROM Market WHERE InactiveInd = 0);

    SELECT a.ID
      ,a.MarketCode
      ,a.RetailMktDescp
      ,b.WholesaleMktId
      ,a.PucCertification_number
      ,a.DateCreated
      ,a.Username
      ,a.InactiveInd
      ,a.ActiveDate
      ,a.Chgstamp
      ,@recordCount RecordCount
      ,CEILING(CAST(@recordCount AS FLOAT) / CAST(@p_page_size AS FLOAT)) PageCount
	FROM Market a WITH (NOLOCK)
	LEFT OUTER JOIN WholesaleMarket b WITH (NOLOCK) ON a.WholesaleMktId = b.ID 
    WHERE 1=1
    AND (@retail_mkt_id IS NULL OR MarketCode = @retail_mkt_id)
    AND (@MarketID IS NULL OR a.ID = @MarketID)
    AND a.InactiveInd = 0
    ORDER BY a.MarketCode
    
END
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO

IF @@TRANCOUNT>0
	COMMIT TRANSACTION CONSTRUCTION
GO

SET NOEXEC OFF
GO
