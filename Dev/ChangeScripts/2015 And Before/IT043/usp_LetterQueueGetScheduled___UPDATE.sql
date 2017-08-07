USE [lp_documents]
GO

/****** Object:  StoredProcedure [dbo].[usp_LetterQueueGetScheduled]    Script Date: 05/31/2012 10:42:43 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



-- ============================================
-- Created By: Ryan Russon
-- ============================================
-- Purpose:		Get all Letter Queue documents that are scheduled to print
--				Used in place of [usp_LetterQueueSelect] to get only documents currently scheduled to print
-- Date:		2011-05-11
-- Usage:		exec lp_documents.dbo.usp_LetterQueueGetScheduled 28
-- =============================================
-- Modified: 05/31/2012 Ryan Russon
-- Added AccountType to data for use in specifying subfolder for 3rd-party print jobs and refactored slightly
-- =============================================

ALTER PROCEDURE [dbo].[usp_LetterQueueGetScheduled] (
	@documentTypeId  int = 0
)

AS

BEGIN
	SET NOCOUNT ON

	SELECT
		lq.LetterQueueID
		, lq.[Status]
		, lq.ContractNumber
		, lq.AccountID
		, lq.DocumentTypeID
		, CONVERT(varchar(10), lq.DateCreated, 110)		AS DateCreated
		, CONVERT(varchar(10), lq.ScheduledDate, 110)	AS ScheduledDate
		, CONVERT(varchar(10), lq.PrintDate, 110)		AS PrintDate
		, lq.Username
		, dt.document_type_name
		, a.account_number								AS AccountNumber
		, a.account_id
		, a.account_type								AS AccountType
		, an.full_name									AS CustomerName
		--Add some stupid columns that DocumentRepository Service needs so that filters hidden in various places don't remove all the data or blow up
		, ' '											AS Reason_Code
		, 0												AS by_contract
	FROM [LibertyPower]..[LetterQueue]		lq WITH (NOLOCK)
	JOIN [lp_documents]..[document_type]	dt WITH (NOLOCK)	ON dt.document_type_id = lq.DocumentTypeId
	JOIN [lp_Account]..[account]			a WITH (NOLOCK)		ON a.accountId = lq.accountId
	JOIN [lp_account]..[account_name]		an WITH (NOLOCK)	ON (an.name_link = a.customer_name_link and an.account_id = a.account_id)
	WHERE lq.DocumentTypeId = @documentTypeId
	AND UPPER(lq.[Status]) = 'SCHEDULED'						--Current SQL instance is not case sensitive, but put UPPER() here just in case
	AND IsNull(lq.ScheduledDate, '12/31/2500') < GETDATE()	--TODO: update this condition before the 26th century
	AND NOT (	a.account_type = 'LCI'						--Ticket 1-4979161 Not to pull LCI accounts
				and (	dt.document_type_id = 31
						or dt.document_type_id = 33
						or dt.document_type_id = 40
						or dt.document_type_id = 41	)
	)
	ORDER BY lq.LetterQueueID

END



GO


