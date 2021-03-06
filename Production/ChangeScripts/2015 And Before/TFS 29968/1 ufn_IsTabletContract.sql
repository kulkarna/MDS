USE [LibertyPower]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ufn_IsTabletContract]') AND type = 'FN')
	DROP FUNCTION [dbo].[ufn_IsTabletContract]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Isabelle Tamanini
-- Create date: 04/01/2014
-- Description:	Verifies if contract was submitted via Tablet
-- =============================================
CREATE FUNCTION [dbo].[ufn_IsTabletContract] 
(
	@ContractNumber varchar(50)
)
RETURNS BIT
AS
BEGIN

	DECLARE @p_TabletContract BIT
	
	SET  @p_TabletContract = 0
		
	SELECT @p_TabletContract = (CASE 
								WHEN at.ClientApplicationTypeId IS NOT NULL 
								 AND at.ClientApplicationTypeId = 5 THEN 1
								WHEN at.ClientApplicationTypeId IS NULL 
								 AND C.CreatedBy = 1913 THEN 1 
								ELSE 0 END)
	FROM LibertyPower..Contract c (NOLOCK)
	LEFT JOIN LibertyPower..ClientSubmitApplicationKey csak (NOLOCK) ON c.ClientSubmitApplicationKeyId = csak.ClientSubApplicationKeyId
																	AND csak.Active = 1
	LEFT JOIN LibertyPower..ClientApplicationType at        (NOLOCK) ON csak.ClientApplicationTypeId = at.ClientApplicationTypeId
	WHERE C.Number = @ContractNumber

	RETURN @p_TabletContract

END
