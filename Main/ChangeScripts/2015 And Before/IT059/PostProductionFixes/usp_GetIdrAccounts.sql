USE Libertypower
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ==================================================================
-- Author:		Abhijeet Kulkarni
-- Create date: 12/17/2013
-- Description:	Procedure to obtain data from the IdrAccounts table
-- ==================================================================

CREATE PROCEDURE [dbo].usp_GetIdrAccounts
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT UtilityID, AccountNumber, IDRStartDate, SiteUploadDate FROM dbo.IDRAccounts (NOLOCK)
END
GO

