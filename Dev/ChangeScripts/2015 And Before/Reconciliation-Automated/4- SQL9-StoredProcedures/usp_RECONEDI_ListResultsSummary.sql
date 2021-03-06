/****** Object:  StoredProcedure [dbo].[usp_RECONEDI_ListResultsSummary]    Script Date: 6/26/2014 4:21:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Felipe Medeiros
-- Create date: 04/25/2014
-- Description: Return Result Summary
-- Exectuion Sample: exec usp_RECONEDI_ListResultsSummary 11
-- =============================================
CREATE PROCEDURE [dbo].[usp_RECONEDI_ListResultsSummary]
    @reconid as int	
AS
	BEGIN
	
	SET NOCOUNT ON;
	
	select * from ufn_RECONEDI_ProcessResults(@reconid)

/*	
	--TABLE: 0
	--No. of Accounts in MTM	
	select NroAccounts = count(distinct a.AccountID), VolumeMwh = sum(a.TotalVolumeMwh),
		CASE WHEN ProcessType = 'CUSTOM' THEN 0 
			 WHEN ProcessType = 'DAILY' THEN 1 END AS Book 
	from RECONEDI_EDIAccountData a with (nolock)
	where a.Reconid   = @reconid
	and   exists(select null
				 from RECONEDI_MtMAccountData b with (nolock)
				 where b.Reconid    = @reconid
						 and   b.AccountID  = a.AccountID
						 and   b.ContractID = a.ContractID)
	group by 
		Processtype


	--TABLE: 1
	select a.Book, NroAccounts = count(distinct a.AccountID), VolumeMwh = sum(a.volume)
	from RECONEDI_MtMAccountData a with (nolock)
	where a.Reconid   = @reconid
	and   exists(select null
				 from RECONEDI_EDIAccountData b with (nolock)
				 where b.Reconid    = @reconid
						 and   b.AccountID  = a.AccountID
						 and   b.ContractID = a.ContractID)
	group by 
		Book
	
	SELECT 
		SUM(Volume) as Volume,
		COUNT(*) as NumberOfAccounts,
		Book
	INTO #MtMVolume
	FROM
		RECONEDI_MtMAccountData (nolock)
	WHERE 
		ReconID = @reconid
	GROUP BY 
		Book		
	
	SELECT 
		SUM(TotalVolumeMwh) as Volume,
		COUNT(*) as NumberOfAccounts,
		CASE WHEN ProcessType = 'CUSTOM' THEN 0 
			 WHEN ProcessType = 'DAILY' THEN 1 END AS Book
	INTO #EnrollmentVolume
	FROM	
		RECONEDI_EDIAccountData (nolock)
	WHERE 
		ReconID = @reconid
	GROUP BY 
		ProcessType

	--TABLE: 2
	--No. of Accounts in MTM	
	SELECT * FROM #MtMVolume (nolock) as MtMVolume

	--TABLE: 3
	--No. of Accounts in Enrollment
	SELECT * FROM #EnrollmentVolume (nolock) as EnrollmentVolume

	--TABLE: 4
	--Variance
	SELECT 
		(ISNULL(a.NumberOfAccounts, 0) - ISNULL(b.NumberOfAccounts, 0)) as AccountsVariance,
		(ISNULL(a.Volume, 0) - ISNULL(b.Volume, 0)) as VolumeVariance,
		b.Book	
	FROM
		#MtMVolume (nolock) a
		RIGHT OUTER JOIN #EnrollmentVolume (nolock) b ON (a.Book = b.Book)

	--TABLE: 5
	SELECT 
		COUNT(*) as NumberOfAccounts,
		Book
	FROM
		RECONEDI_MissingEDI (nolock)
	WHERE 
		ReconID = @reconid
	GROUP BY 
		Book

	--TABLE: 6
	SELECT 
		COUNT(*) as NumberOfAccounts,
		CASE WHEN ProcessType = 'CUSTOM' THEN 0 
			 WHEN ProcessType = 'DAILY' THEN 1 END AS Book
	FROM		
		RECONEDI_MissingMtM (nolock)
	WHERE 
		ReconID = @reconid
	GROUP BY 
		ProcessType

	--TABLE: 7
	SELECT 
		COUNT(*) as NumberOfAccounts,
		SUM(TotalVolumeMwh) as Volume,
		Book
	FROM
		RECONEDI_VolumeMissingEDI (nolock)
	WHERE 
		ReconID = @reconid
	GROUP BY 
		Book

	--TABLE: 8		
	SELECT 
		COUNT(*) as NumberOfAccounts,
		SUM(TotalVolumeMwh) as Volume,
		CASE WHEN ProcessType = 'CUSTOM' THEN 0 
			 WHEN ProcessType = 'DAILY' THEN 1 END AS Book
	FROM
		RECONEDI_VolumeMissingMtM (nolock)
	WHERE 
		ReconID = @reconid
	GROUP BY 
		ProcessType
	

	--TABLE: 9
	SELECT 
		COUNT(*) as NumberOfAccounts,
		Book,
		sum(b.TotalVolumeMwh) as Volume
	FROM
		RECONEDI_SubmittedAfterProcessDate (nolock) a
		JOIN RECONEDI_EDIAccountData (nolock) b on (a.AccountID = b.AccountID and a.ReconID = b.ReconID)
	WHERE 
		a.ReconID = @reconid
	GROUP BY 
		Book
		
	--TABLE: 10
	SELECT 
		COUNT(*) as NumberOfAccounts,
		Book,
		sum(b.TotalVolumeMwh) as Volume
	FROM
		RECONEDI_ContractStatusRejected (nolock) a
		JOIN RECONEDI_EDIAccountData (nolock) b on (a.AccountID = b.AccountID and a.ReconID = b.ReconID)
	WHERE 
		a.ReconID = @reconid
	GROUP BY 
		Book

	--TABLE: 11
	SELECT 
		COUNT(*) as NumberOfAccounts,
		Book,
		sum(b.TotalVolumeMwh) as Volume
	FROM	
		RECONEDI_Overlaps (nolock) a
		JOIN RECONEDI_EDIAccountData (nolock) b on (a.AccountID = b.AccountID and a.ReconID = b.ReconID)
	WHERE 
		a.ReconID = @reconid
	GROUP BY 
		Book

	--TABLE: 12
	SELECT 
		COUNT(*) as NumberOfAccounts,
		Book,
		sum(b.TotalVolumeMwh) as Volume
	FROM
		RECONEDI_ReEnrolledAfterContractEnd (nolock) a
		JOIN RECONEDI_EDIAccountData (nolock) b on (a.AccountID = b.AccountID and a.ReconID = b.ReconID)
	WHERE 
		a.ReconID = @reconid
	GROUP BY 
		Book

	--TABLE: 13
	SELECT 
		COUNT(*) as NumberOfAccounts,
		Book,
		sum(b.TotalVolumeMwh) as Volume
	FROM	
		RECONEDI_DeEnrollLastInvSameDropDate (nolock) a
		JOIN RECONEDI_EDIAccountData (nolock) b on (a.AccountID = b.AccountID and a.ReconID = b.ReconID)
	WHERE 
		a.ReconID = @reconid
	GROUP BY 
		Book
		
	--TABLE: 14
	SELECT 
		COUNT(*) as NumberOfAccounts,
		Book,
		sum(b.TotalVolumeMwh) as Volume
	FROM	
		dbo.RECONEDI_InExcludedList (nolock) a
		JOIN RECONEDI_EDIAccountData (nolock) b on (a.AccountID = b.AccountID and a.ReconID = b.ReconID)
	WHERE 
		a.ReconID = @reconid
	GROUP BY 
		Book
	*/
		
	SET NOCOUNT OFF;
END




GO
