USE [Lp_documents]
GO

/****** Object:  StoredProcedure [dbo].[usp_Contract_GetMappingInfo]    Script Date: 10/03/2013 10:07:29 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_Contract_GetMappingInfo]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_Contract_GetMappingInfo]
GO

USE [Lp_documents]
GO

/****** Object:  StoredProcedure [dbo].[usp_Contract_GetMappingInfo]    Script Date: 10/03/2013 10:07:29 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =====================================================================
-- Author:		Guy G
-- Create date: 10/2013
-- Description:	Get mapping details that would be used to find templates.
--				This is to be used in get more details when the application
--				fails to locate a document based on the information available.		 
-- ======================================================================
Create PROCEDURE [dbo].[usp_Contract_GetMappingInfo]
(
	@contract_nbr		varchar(30)
)
AS
BEGIN
	-- exec usp_Contract_GetMappingInfo '20120516521'
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	


select distinct MappingDetailMessage = 
	CASE WHEN pb.[Name] IS NOT NULL THEN 'Product : ' + LTRIM(RTRIM(pb.[Name])) + CHAR(13)+CHAR(10) ELSE '' END
	+ CASE WHEN m.MarketCode IS NOT NULL THEN 'MarketCode : '  + LTRIM(RTRIM(m.MarketCode)) + CHAR(13)+CHAR(10) ELSE '' END
	+ CASE WHEN A.utility_id IS NOT NULL THEN 'Utility : '  + LTRIM(RTRIM(a.utility_id)) + CHAR(13)+CHAR(10) ELSE '' END
	+ CASE WHEN l.[Description] IS NOT NULL THEN 'Language : ' +  LTRIM(RTRIM(l.[Description])) + CHAR(13)+CHAR(10) ELSE '' END
	+ CASE WHEN at.[Description] IS NOT NULL THEN 'Account Type: ' +  LTRIM(RTRIM(at.[Description])) + CHAR(13)+CHAR(10) ELSE '' END
from vw_ConsolidatedAccountInfo a 
join libertypower..market m with(nolock) on a.MarketId =m.id
join libertypower..ProductBrand pb with(nolock) on a.ProductBrandID = pb.ProductBrandID
join libertypower..Language l with(nolock) on a.LanguageId = l.LanguageID
join libertypower..AccountType at with(nolock) on a.AccountTypeId = at.ID
where a.contract_nbr=@contract_nbr

	
	set nocount off;
END

GO


