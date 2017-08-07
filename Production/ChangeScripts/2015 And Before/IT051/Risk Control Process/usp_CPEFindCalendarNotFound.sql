USE [lp_MtM]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Felipe Medeiros
-- Create date: 11/04/2013
-- Description:	Find if the problem was calendar not found
-- =============================================
CREATE PROCEDURE usp_CPEFindCalendarNotFound 

	@AccountID as int, 
	@BatchNumber as varchar(100),
	@QuoteNumber as varchar(100)
AS
BEGIN
	SET NOCOUNT ON;

	select * from MtMExceptionLog with (nolock)
	where ExceptionTypeId = 4
	and [Source] = @QuoteNumber
	and BatchNumber = @QuoteNumber
	and AccountId = @AccountID

	SET NOCOUNT OFF;
END
GO
