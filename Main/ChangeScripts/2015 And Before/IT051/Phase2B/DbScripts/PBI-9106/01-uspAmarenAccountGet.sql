USE [lp_transactions]
GO
/****** Object:  StoredProcedure [dbo].[usp_AmerenAccountGet]    Script Date: 04/25/2013 15:00:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*******************************************************************************
 * usp_AmerenAccountGet
 * Selects an Ameren account
 *
 * History
 * 4/25/2013: Get the latest account information by ID and not by Date Created
 *******************************************************************************
 * ? - ?
 * Created.
 Modified by: Cathy Ghazal
 *******************************************************************************
 */

ALTER PROCEDURE [dbo].[usp_AmerenAccountGet]
(@accountNumber as varchar(50))

AS

BEGIN
	SET NOCOUNT ON;

	DECLARE @ID as INT

	--The AmerenAccount table can hold more than one record per account/utility. 
	--We need to select the last one that was updated/inserted
	SELECT	@ID = MAX(ID)
	FROM	AmerenAccount (NOLOCK)
	WHERE	AccountNumber = @accountNumber

	SELECT	ID, CustomerName, MeterNumber, BillGroup, ProfileClass, ServiceClass, EffectivePLC
	FROM	AmerenAccount (NOLOCK)
	WHERE	AccountNumber	= @accountNumber
	AND		ID = @ID

	SET NOCOUNT OFF;
END