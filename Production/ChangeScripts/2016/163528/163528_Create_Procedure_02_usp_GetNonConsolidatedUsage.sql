USE [lp_transactions]
GO
/****** Object:  StoredProcedure [dbo].[usp_GetNonConsolidatedUsage]    Script Date: 03/01/2017 13:28:38 ******/
if OBJECT_ID('usp_GetNonConsolidatedUsage') is not null
DROP PROCEDURE [dbo].[usp_GetNonConsolidatedUsage]
GO
/****** Object:  StoredProcedure [dbo].[usp_GetNonConsolidatedUsage]    Script Date: 03/01/2017 13:28:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*

    Sp Name :-  usp_GetNonConsolidatedUsage
    Created By :- Vikas Sharma
    Purpose: To fetch all the records for the list of accountnumbers
    PBI :163528

*/

CREATE PROCEDURE [dbo].[usp_GetNonConsolidatedUsage] 

@ACCOUNTUSAGELIST
AS      
DBO.AccountUsageList READONLY 

AS

BEGIN
	SET NOCOUNT ON;

	SELECT UC.ID AS ID
		,Acc.ACCOUNTNUMBER AS ACCOUNTNUMBER
		,Acc.UtilityId
		,case when ISNULL(uc.AccountNumber,'')<>'' then UC.FromDate else Acc.FromDate end as FromDate
		,case when ISNULL(uc.AccountNumber,'')<>'' then UC.ToDate else Acc.ToDate end as ToDate
		,case when ISNULL(uc.AccountNumber,'')<>'' then  uc.TOTALKWH else 0  end TotalKwh
		,case when ISNULL(uc.AccountNumber,'')<>'' then uc.DAYSUSED else 0  end DaysUsed
		,case when ISNULL(uc.AccountNumber,'')<>'' then uc.CREATED else GETDATE() end Created
		,UC.CREATEDBY AS CREATEDBY
		,case when ISNULL(uc.AccountNumber,'')<>'' then UC.ACTIVE else 0 end Active
		,case when ISNULL(uc.AccountNumber,'')<>'' then Uc.METERNUMBER else null end MeterNumber
		,case when uc.AccountNumber is null then 'ACCOUNT DOES NOT EXISTS' else '' end as ErrorMessage 
	FROM libertypower..USAGECONSOLIDATED(NOLOCK) UC
	INNER JOIN libertypower..Utility(NOLOCK) UT ON UC.UtilityCode = UT.UtilityCode
    right outer join @ACCOUNTUSAGELIST ACC on Uc.AccountNumber=Acc.Accountnumber	
	and ut.ID=Acc.UtilityId
		AND UC.FROMDATE >= Acc.FromDate
		AND uc.TODATE <=Acc.ToDate
		AND UC.ACTIVE = 1
	
	ORDER BY FROMDATE DESC

	SET NOCOUNT OFF;
END
	
	 
GO
