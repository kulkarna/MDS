USE [Lp_deal_capture]
GO
/****** Object:  StoredProcedure [dbo].[usp_incomplete_deals_and_renewals_del]    Script Date: 09/17/2014 17:55:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET NOCOUNT ON 
GO
SET NOCOUNT OFF
GO
-- =============================================
-- Author:		Rick Deigsler
-- Create date: 5/15/2008
-- Description:	Delete incomplete deals and renewals older than 2 weeks
-- Satchi :	 09/17/2014	
-- Description:	As part of the PBI 47710 We dont want to delete Tablet rejected Deals.
--				Tablet rejected Deals will have ClientSubmitApplicationKeyId populated.
-- =============================================
ALTER PROCEDURE [dbo].[usp_incomplete_deals_and_renewals_del]

AS

DECLARE	@w_delete_date	datetime
SET		@w_delete_date = DATEADD(dd, -1, GETDATE())

BEGIN TRANSACTION;
BEGIN TRY
	SELECT	contract_nbr
	INTO #DELETE_THESE
	FROM	lp_deal_capture..deal_contract with(nolock)
	WHERE	date_created < @w_delete_date
	--Signifies that its not a Tablet rejected Deal.
	AND ClientSubmitApplicationKeyId is null 
	AND contract_nbr NOT IN (SELECT [Contract] FROM OrderManagement.dbo.WorkItemContract with (nolock))

	UNION
	SELECT	contract_nbr
	FROM	lp_contract_renewal..deal_contract with(nolock)
	WHERE	date_created < @w_delete_date
	AND contract_nbr NOT IN (SELECT [Contract] FROM OrderManagement.dbo.WorkItemContract with(nolock))



	-- lp_deal_capture  -------------------------------
	DELETE FROM	lp_deal_capture..deal_address
	WHERE contract_nbr IN (SELECT contract_nbr FROM #DELETE_THESE)

	DELETE FROM	lp_deal_capture..deal_contact
	WHERE contract_nbr IN (SELECT contract_nbr FROM #DELETE_THESE)

	DELETE FROM	lp_deal_capture..deal_name
	WHERE contract_nbr IN (SELECT contract_nbr FROM #DELETE_THESE)

	DELETE FROM	lp_deal_capture..deal_contract_account
	WHERE contract_nbr IN (SELECT contract_nbr FROM #DELETE_THESE)

	DELETE FROM	lp_deal_capture..deal_contract
	WHERE contract_nbr IN (SELECT contract_nbr FROM #DELETE_THESE)


	-- lp_contract_renewal  -----------------------------
	DELETE FROM	lp_contract_renewal..deal_address
	WHERE contract_nbr IN (SELECT contract_nbr FROM #DELETE_THESE)

	DELETE FROM	lp_contract_renewal..deal_contact
	WHERE contract_nbr IN (SELECT contract_nbr FROM #DELETE_THESE)

	DELETE FROM	lp_contract_renewal..deal_name
	WHERE contract_nbr IN (SELECT contract_nbr FROM #DELETE_THESE)

	DELETE FROM	lp_contract_renewal..deal_contract_account
	WHERE contract_nbr IN (SELECT contract_nbr FROM #DELETE_THESE)

	DELETE FROM	lp_contract_renewal..deal_contract
	WHERE contract_nbr IN (SELECT contract_nbr FROM #DELETE_THESE)
END TRY
BEGIN CATCH
    SELECT 
        ERROR_NUMBER() AS ErrorNumber
        ,ERROR_SEVERITY() AS ErrorSeverity
        ,ERROR_STATE() AS ErrorState
        ,ERROR_PROCEDURE() AS ErrorProcedure
        ,ERROR_LINE() AS ErrorLine
        ,ERROR_MESSAGE() AS ErrorMessage;
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;
END CATCH;
IF @@TRANCOUNT > 0
    COMMIT TRANSACTION;

