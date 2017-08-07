
USE lp_transactions
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/*******************************************************************************
* dbo.[usp_AmerenAccountGetLatestReads]
 * <For Getting latest set of records for each Distinct MaterNumber from AmerenAccount>
*
* History

*******************************************************************************
* 10/12/2015 - Srikanth Bachina 
 * Created.
*******************************************************************************

*/
	CREATE PROCEDURE dbo.[usp_AmerenAccountGetLatestReads]
	( @Accountnumber varchar(50))

	AS
	BEGIN

	SET NOCOUNT ON;

	--DECLARE @Accountnumber varchar(50)
	--select @AccountNumber='9795164179'
	
	
	SELECT	MAX(ID) as ID, CustomerName, MeterNumber, BillGroup, ProfileClass, ServiceClass, EffectivePLC

	FROM	lp_transactions.dbo.AmerenAccount (NOLOCK)

	WHERE	AccountNumber	= @AccountNumber

	AND		cast(created as date) =( select MAX(cast(created as date)) from lp_transactions.dbo.AmerenAccount where Accountnumber=@Accountnumber)
	
	GROUP BY CustomerName, MeterNumber, BillGroup, ProfileClass, ServiceClass, EffectivePLC
	
	ORDER BY ID

	SET NOCOUNT OFF;

	END

	/*GO
	
	DECLARE       @return_value int

	EXEC   @return_value = [dbo].[usp_AmerenAccountGetLatestReads]
							@Accountnumber ='9795164179'
             
	SELECT 'Return Value' = @return_value

	GO
	*/



