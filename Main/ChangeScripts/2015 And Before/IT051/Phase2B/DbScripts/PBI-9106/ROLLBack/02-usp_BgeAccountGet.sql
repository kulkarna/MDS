USE [lp_transactions]
GO
/****** Object:  StoredProcedure [dbo].[usp_BgeAccountGet]    Script Date: 12/09/2013 16:05:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*******************************************************************************
 * usp_BgeAccountGet
 * Selects a bge account
 *
 * History
 *******************************************************************************
 * ? - ?
 * Created.
 *******************************************************************************
 */

ALTER PROCEDURE [dbo].[usp_BgeAccountGet]
(@accountNumber as varchar(50))

AS

BEGIN

	DECLARE @dateInsert as DateTime

	--The BgeAccount table can hold more than one record per account/utility. 
	--We need to select the last one that was updated/inserted
	SELECT	@dateInsert = MAX(Created)
	FROM	BgeAccount
	WHERE	AccountNumber = @accountNumber

	SELECT	ID, AccountName, ServiceAddressStreet, ServiceAddressCityName, ServiceAddressStateCode,
			ServiceAddressZipCode, BillingAddressStreet, BillingAddressCityName, BillingAddressStateCode,
			BillingAddressZipCode, BillGroup
	FROM	BgeAccount
	WHERE	AccountNumber = @accountNumber
	AND		Created = @dateInsert

END
