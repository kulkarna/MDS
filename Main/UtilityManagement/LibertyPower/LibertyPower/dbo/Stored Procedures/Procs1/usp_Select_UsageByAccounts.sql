-- =============================================
-- Author:		Iraj Rahmani
-- Create date: 9/24/2009
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[usp_Select_UsageByAccounts] 
@Accounts varchar(2000) = null

AS
BEGIN

DECLARE @sql varchar(500)
Set @sql ='select accountnumber, FromDate, ToDate, totalKwh, DaysUsed from libertypower..usage (nolock) '

If  (@Accounts is not null )
    Begin
      Set @sql = @sql  + 'Where [accountnumber] In(' + @Accounts + ')'   
	  Exec (@sql)
    End 

END


