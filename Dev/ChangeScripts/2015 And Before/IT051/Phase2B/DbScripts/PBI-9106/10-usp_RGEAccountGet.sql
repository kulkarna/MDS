USE [lp_transactions]
GO
/****** Object:  StoredProcedure [dbo].[usp_RgeAccountGet]    Script Date: 04/25/2013 15:05:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*******************************************************************************
 * usp_RgeAccountGet
 * Selects a Rge account
 *
 * History
 * 5/14/2013: Get the latest account information by ID and not by Date Created
 *******************************************************************************
 * Created by: Cathy Ghazal
 *******************************************************************************
 */

CREATE PROCEDURE [dbo].[usp_RgeAccountGet]
(@accountNumber as varchar(50))

AS

BEGIN

	SET NOCOUNT ON;

	DECLARE @ID as INT

	--The RgeAccount table can hold more than one record per account/utility. 
	--We need to select the last one that was updated/inserted
	SELECT	@ID = MAX(ID)
	FROM	RgeAccount (NOLOCK)
	WHERE	AccountNumber = @accountNumber

	SELECT	ID, AccountNumber,Profile, Icap, Grid, CurrentRateCategory
	FROM	RgeAccount (NOLOCK)
	WHERE	AccountNumber = @accountNumber
	AND		ID = @ID

	SET NOCOUNT OFF;
END


