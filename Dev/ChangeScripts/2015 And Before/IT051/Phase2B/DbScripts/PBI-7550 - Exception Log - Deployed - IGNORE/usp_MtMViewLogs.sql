USE [lp_mtm]
GO
/****** Object:  StoredProcedure [dbo].[usp_MtMViewLogs]    Script Date: 10/15/2013 17:50:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* **********************************************************************************************
 *	Author:		Cghazal																			*
 *	Created:	10/10/2011																		*
 *	Descp:		view logs for a batch/quote number												*
 *	Modified:																					*
 ********************************************************************************************** */
ALTER PROCEDURE [dbo].[usp_MtMViewLogs] (
		@BatchNumber AS VARCHAR(50),
		@QuoteNumber AS VARCHAR(50)
)

AS

BEGIN

	SELECT	DISTINCT
			ID, Description, Type, DateCreated
	FROM	MtMTracking (nolock)
	WHERE	(QuoteNumber = @QuoteNumber
	AND		BatchNumber = @BatchNumber)
	OR		(Description like '%' + @BatchNumber + '%' + @QuoteNumber + '%')

	UNION 
	
	SELECT	DISTINCT
			ID = ExceptionId
			, Description = ExceptionDescription
			--Severity:: None = 0, Warning = 1, Error = 2, Information = 3
			, Type = case when Severity = 2 then 'F' when Severity = 4 then 'S' else 'I' end 
			, DateCreated
			
	FROM	MtMExceptionLog (nolock)
	WHERE	BatchNumber = @BatchNumber
	OR		(ExceptionDescription like '%' + @BatchNumber + '%' + @QuoteNumber + '%')
	OR		(AdditionalInfo like '%' + @BatchNumber + '%' + @QuoteNumber + '%')


	ORDER	BY ID

		
END
