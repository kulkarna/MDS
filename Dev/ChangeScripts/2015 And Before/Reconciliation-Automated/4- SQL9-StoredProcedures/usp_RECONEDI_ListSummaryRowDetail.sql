/****** Object:  StoredProcedure [dbo].[usp_RECONEDI_ListSummaryRowDetail]    Script Date: 6/26/2014 4:21:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Felipe Medeiros
-- Create date: 04/25/2014
-- Description: Return Result Summary
-- Execution Sample: exec usp_RECONEDI_ListSummaryRowDetail 11, 0
-- =============================================
CREATE PROCEDURE [dbo].[usp_RECONEDI_ListSummaryRowDetail]
    @reconid as int,
    @tableName as varchar(50)
AS
	BEGIN
	
	SET NOCOUNT ON;
	
	exec usp_RECONEDI_ProcessResultsDetail @reconid, @tableName
	
	/*
	IF @tableNumber = 0
	BEGIN
		--TABLE: 0
		--No. of Accounts in MTM	
		select * 
		from RECONEDI_EDIAccountData a with (nolock)
		where a.Reconid   = @reconid
		and   exists(select null
					 from RECONEDI_MtMAccountData b with (nolock)
					 where b.Reconid    = @reconid
							 and   b.AccountID  = a.AccountID
							 and   b.ContractID = a.ContractID)
	END
	
	IF @tableNumber = 1
	BEGIN
	--TABLE: 1
		select *
		from RECONEDI_MtMAccountData a with (nolock)
		where a.Reconid   = @reconid
		and   exists(select null
					 from RECONEDI_EDIAccountData b with (nolock)
					 where b.Reconid    = @reconid
							 and   b.AccountID  = a.AccountID
							 and   b.ContractID = a.ContractID)
	END
	
	IF @tableNumber = 2
	BEGIN
		--TABLE: 2
		--No. of Accounts in MTM	
		SELECT 
			*
		FROM
			RECONEDI_MtMAccountData (nolock)
		WHERE 
			ReconID = @reconid
	END
	
	IF @tableNumber = 3
	BEGIN
		--TABLE: 3
		--No. of Accounts in Enrollment
		SELECT 
			*
		FROM	
			RECONEDI_EDIAccountData (nolock)
		WHERE 
			ReconID = @reconid
	END
	
	IF @tableNumber = 5
	BEGIN
		--TABLE: 5
		SELECT 
			*
		FROM
			RECONEDI_MissingEDI (nolock)
		WHERE 
			ReconID = @reconid
	END
	
	IF @tableNumber = 6
	BEGIN	
	--TABLE: 6
		SELECT 
			*
		FROM		
			RECONEDI_MissingMtM (nolock)
		WHERE 
			ReconID = @reconid
	END

	IF @tableNumber = 7
	BEGIN
		--TABLE: 7
		SELECT 
			*
		FROM
			RECONEDI_VolumeMissingEDI (nolock)
		WHERE 
			ReconID = @reconid
	END
	
	IF @tableNumber = 8
	BEGIN
		--TABLE: 8		
		SELECT 
			*
		FROM
			RECONEDI_VolumeMissingMtM (nolock)
		WHERE 
			ReconID = @reconid
	END 
	
	IF @tableNumber = 9
	BEGIN
		--TABLE: 9
		SELECT 
			*
		FROM
			RECONEDI_SubmittedAfterProcessDate (nolock) a
			JOIN RECONEDI_EDIAccountData (nolock) b on (a.AccountID = b.AccountID and a.ReconID = b.ReconID)
		WHERE 
			a.ReconID = @reconid
	END
	
	IF @tableNumber = 10
	BEGIN
		--TABLE: 10
		SELECT 
			*
		FROM
			RECONEDI_ContractStatusRejected (nolock) a
			JOIN RECONEDI_EDIAccountData (nolock) b on (a.AccountID = b.AccountID and a.ReconID = b.ReconID)
		WHERE 
			a.ReconID = @reconid
	END
	
	IF @tableNumber = 11
	BEGIN
		--TABLE: 11
		SELECT 
			*
		FROM	
			RECONEDI_Overlaps (nolock) a
			JOIN RECONEDI_EDIAccountData (nolock) b on (a.AccountID = b.AccountID and a.ReconID = b.ReconID)
		WHERE 
			a.ReconID = @reconid
	END
	
	IF @tableNumber = 12
	BEGIN
		--TABLE: 12
		SELECT 
			*
		FROM
			RECONEDI_ReEnrolledAfterContractEnd (nolock) a
			JOIN RECONEDI_EDIAccountData (nolock) b on (a.AccountID = b.AccountID and a.ReconID = b.ReconID)
		WHERE 
			a.ReconID = @reconid
	END
	
	IF @tableNumber = 13
	BEGIN
		--TABLE: 13
		SELECT 
			*
		FROM	
			RECONEDI_DeEnrollLastInvSameDropDate (nolock) a
			JOIN RECONEDI_EDIAccountData (nolock) b on (a.AccountID = b.AccountID and a.ReconID = b.ReconID)
		WHERE 
			a.ReconID = @reconid
	END
	
	IF @tableNumber = 14
	BEGIN	
		--TABLE: 14
		SELECT 
			*
		FROM	
			dbo.RECONEDI_InExcludedList (nolock) a
			JOIN RECONEDI_EDIAccountData (nolock) b on (a.AccountID = b.AccountID and a.ReconID = b.ReconID)
		WHERE 
			a.ReconID = @reconid
	END	
	*/
	
	SET NOCOUNT OFF;
END




GO
