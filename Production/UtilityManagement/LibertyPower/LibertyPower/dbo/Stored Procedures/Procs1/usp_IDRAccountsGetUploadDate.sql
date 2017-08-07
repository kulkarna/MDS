/********************************* [dbo].[usp_IDRAccountsGetUploadDate] ********************/
CREATE PROCEDURE [dbo].[usp_IDRAccountsGetUploadDate]
	  @UtilityID varchar(15)
AS
BEGIN
	
	SELECT	MAX(SiteUploadDate) as SiteUploadDate
	FROM	dbo.IDRAccounts 
	WHERE	UtilityID = @UtilityID 
	
END

