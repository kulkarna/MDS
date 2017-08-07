USE [lp_transactions]
GO
/****** Object:  StoredProcedure [dbo].[usp_BgeAccountGet]    Script Date: 04/25/2013 15:05:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*******************************************************************************
 * usp_CmpAccountGet
 * Selects a cenhund account
 *
 * History
 * 4/25/2013: Get the latest account information by ID and not by Date Created
 *******************************************************************************
 * ? - ?
 * Created by: Cathy Ghazal
 *******************************************************************************
 */

Create PROCEDURE [dbo].[usp_CmpAccountGet]
(@accountNumber as varchar(50))

AS

BEGIN

	SET NOCOUNT ON;

	DECLARE @ID as INT

	--The CmpAccount table can hold more than one record per account/utility. 
	--We need to select the last one that was updated/inserted
	SELECT	@ID = MAX(ID)
	FROM	CmpAccount (NOLOCK)
	WHERE	AccountNumber = @accountNumber

	SELECT	ID, AccountNumber, BillGroup
	FROM	CmpAccount (NOLOCK)
	WHERE	AccountNumber = @accountNumber
	AND		ID = @ID

	SET NOCOUNT OFF;
END

