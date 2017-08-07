USE [lp_transactions]
GO

/****** Object:  StoredProcedure [dbo].[usp_AmerenAccountGetLatestReads]    Script Date: 04/06/2016 13:41:47 ******/
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
 * 04/07/2016 - Modified By Vikas Sharma
 * Descrition : Ameren Load profile Issue PBI- 113131
*******************************************************************************

exec usp_AmerenAccountGetLatestReads '1404544024'

*/
ALTER PROCEDURE [dbo].[usp_AmerenAccountGetLatestReads] (@Accountnumber VARCHAR(50))
AS
BEGIN
	SET NOCOUNT ON;

	--DECLARE @Accountnumber varchar(50)
	--select @AccountNumber='9795164179'
	SELECT MAX(ID) AS ID
		,CustomerName
		,MeterNumber
		,BillGroup
		,ProfileClass
		,ServiceClass
		,EffectivePLC
		
	INTO #AmerenAccountDetails
	FROM lp_transactions.dbo.AmerenAccount(NOLOCK)
	WHERE AccountNumber = @AccountNumber
		AND cast(created AS DATE) = (
			SELECT MAX(cast(created AS DATE))
			FROM lp_transactions.dbo.AmerenAccount
			WHERE Accountnumber = @Accountnumber
			)
	GROUP BY CustomerName
		,MeterNumber
		,BillGroup
		,ProfileClass
		,ServiceClass
		,EffectivePLC
	ORDER BY ID

	DECLARE @MinId BIGINT = 0

	SELECT @MinId = MIN(id)
	FROM #AmerenAccountDetails
	WHERE ProfileClass <> 'LITE'

	IF (@MinId > 0)
	BEGIN
		UPDATE #AmerenAccountDetails
		SET ProfileClass = (
				SELECT ProfileClass
				FROM #AmerenAccountDetails
				WHERE ID = @MinId
				)
		WHERE ProfileClass = 'LITE'
	END

	SELECT ID
		,CustomerName
		,MeterNumber
		,BillGroup
		,ProfileClass
		,ServiceClass
		,EffectivePLC
	FROM #AmerenAccountDetails

	SET NOCOUNT OFF;
END
	
