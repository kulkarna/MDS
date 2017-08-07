USE Workspace
GO

IF OBJECT_ID('workspace..TFS_190200_DuplicatedUsage') IS NOT NULL
	DROP TABLE TFS_190200_DuplicatedUsage

SELECT 
DISTINCT A.AccountNumber, a.UtilityCode
INTO workspace..TFS_190200_DuplicatedUsage
FROM Libertypower..UsageConsolidated a with (nolock)
join lp_transactions..EdiAccount e with (nolock) on e.AccountNumber=a.accountnumber
join lp_transactions..EdiUsage u with (nolock) on e.id = u.EdiAccountID
JOIN Libertypower..Account AA with (nolock) ON AA.ACCOUNTnumber = e.accountnumber
INNER JOIN Libertypower.dbo.Utility UT WITH (NOLOCK)
ON UT.ID     = AA.UtilityID
INNER JOIN Libertypower..AccountContract AC WITH (NOLOCK)
ON AC.AccountID    = AA.AccountID
AND AC.ContractID   = AA.CurrentContractID
INNER JOIN Libertypower..AccountStatus ACS WITH (NOLOCK)
ON ACS.AccountContractID = AC.AccountContractID
INNER JOIN Libertypower.dbo.Contract CC WITH(NOLOCK)
ON CC.ContractID   = AC.ContractID
WHERE 1=1
and a.UsageType = 1
and a.UsageSource = 0
and a.Active = 1
and a.MeterNumber > '0' 
and a.TotalKwh <> u.Quantity
--and a.ToDate = u.EndDate
and a.FromDate = u.BeginDate
and u.UnitOfMeasurement = 'KH'
and a.ToDate > '2015-05-01'
and acs.Status NOT IN ('999998','999999')


DECLARE @UtilityCode		VARCHAR(15)

SET @UtilityCode = 'COMED'

IF OBJECT_ID('WorkSpace..TFS_190200_UsageConsolidated_BK_20170620') IS NOT NULL
	DROP TABLE TFS_190200_UsageConsolidated_BK_20170620

SELECT UC.* 
INTO WorkSpace..TFS_190200_UsageConsolidated_BK_20170620
FROM libertypower..UsageConsolidated UC WITH (NOLOCK)
INNER JOIN workspace..TFS_190200_DuplicatedUsage AA WITH (NOLOCK)
ON AA.UtilityCode			= UC.UtilityCode
AND AA.AccountNumber		= UC.AccountNumber
WHERE AA.UtilityCode		= @UtilityCode
AND UC.ToDate > '2015-05-01'
AND EXISTS (SELECT NULL FROM libertypower..UsageConsolidated UCA WITH (NOLOCK)
			WHERE UCA.UtilityCode		= UC.UtilityCode
			AND UCA.AccountNumber		= UC.AccountNumber
			AND UCA.FromDate			= UC.FromDate
			AND UCA.MeterNumber			<> UC.MeterNumber
			AND UCA.ID					<> UC.ID)


SELECT DISTINCT A.UtilityCode
	,A.AccountNumber
	,AA.AccountID
	,CAST(0 AS BIT) AS ProcessFlag 
INTO WorkSpace..TFS_190200_AccountToReprocess
FROM WorkSpace..TFS_190200_UsageConsolidated_BK_20170620 A WITH (NOLOCK) 
LEFT JOIN Libertypower..Utility UT WITH (NOLOCK)
ON UT.UtilityCode		= A.UtilityCode
LEFT JOIN Libertypower..Account AA WITH (NOLOCK)
ON AA.UtilityID			= UT.ID
AND AA.AccountNumber	= A.AccountNumber
ORDER BY AccountNumber

BEGIN TRY
	BEGIN TRAN
	DELETE libertypower..UsageConsolidated
	FROM libertypower..UsageConsolidated A
	INNER JOIN WorkSpace..TFS_190200_UsageConsolidated_BK_20170620 B WITH (NOLOCK)
	ON B.ID				= A.ID

	COMMIT TRAN
	PRINT ('COMMIT')
END TRY
BEGIN CATCH
	SELECT  ERROR_NUMBER()	AS ErrorNumber  
		,ERROR_SEVERITY()	AS ErrorSeverity  
		,ERROR_STATE()		AS ErrorState  
		,ERROR_PROCEDURE()	AS ErrorProcedure  
		,ERROR_LINE()		AS ErrorLine  
		,ERROR_MESSAGE()	AS ErrorMessage; 
	ROLLBACK TRAN
	PRINT ('ROLLBACK')
END CATCH
