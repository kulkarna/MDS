USE [lp_transactions]
GO
/****** Object:  StoredProcedure [dbo].[usp_AmerenAccountGet]    Script Date: 12/09/2013 16:05:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*******************************************************************************
 * usp_AmerenAccountGet
 * Selects an Ameren account
 *
 * History
 *******************************************************************************
 * ? - ?
 * Created.
 *******************************************************************************
 */

ALTER PROCEDURE [dbo].[usp_AmerenAccountGet]
(@accountNumber as varchar(50))

AS

BEGIN

	DECLARE @dateInsert as DateTime

	--The AmerenAccount table can hold more than one record per account/utility. 
	--We need to select the last one that was updated/inserted
	SELECT	@dateInsert = MAX(Created)
	FROM	AmerenAccount
	WHERE	AccountNumber = @accountNumber

	SELECT	ID, CustomerName, MeterNumber, BillGroup, ProfileClass
	FROM	AmerenAccount
	WHERE	AccountNumber	= @accountNumber
	AND		Created = @dateInsert

END