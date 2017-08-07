
-- =============================================
-- Author:		<Sofia Melo>
-- Create date: <06/22/2010>
-- Description:	<Returns the tax details of an account if existes or the template that applies>
-- =============================================
-- Author:		Jaime Forero
-- Create date: 01/25/2012
-- Description:	refactored for project IT079
-- =============================================
CREATE PROCEDURE [dbo].[usp_AccountTaxDetailSelect]
	
	(@p_tax_status										varchar(12),
	@p_utility_id   									varchar(12),
	@p_account_id										varchar(20))
AS

BEGIN

SET NOCOUNT ON;
	/** IT79 Refactored code:
	IF EXISTS (	SELECT a.account_id
				FROM AccountTaxDetail atd
				JOIN lp_account..account a ON a.account_id = atd.AccountID
				WHERE  atd.AccountID = @p_account_id AND a.tax_status = @p_tax_status	)
	BEGIN
		SELECT t.TaxTypeID, b.PercentTaxable, t.TypeOfTax
		FROM TaxType t
		LEFT JOIN
			(
				SELECT PercentTaxable, atd.TaxTypeID
				FROM AccountTaxDetail atd
				JOIN lp_account..account a ON a.account_id = atd.AccountID
				WHERE  atd.AccountID = @p_account_id AND a.tax_status = @p_tax_status
			)b ON t.TaxTypeID = b.TaxTypeID
		ORDER BY t.TaxTypeID
	END
	ELSE
	BEGIN
		SELECT t.TaxTypeID, PercentTaxable, t.TypeOfTax
		FROM TaxType t
		LEFT JOIN
			(
				SELECT PercentTaxable, tt.TaxTypeID
				FROM TaxTemplate tt
				JOIN Utility u ON tt.utilityID = u.ID
				WHERE tt.template = @p_tax_status AND u.UtilityCode = @p_utility_id
			)b ON t.TaxTypeID = b.TaxTypeID
		ORDER BY t.TaxTypeID
	END	
	
	**/
	-- If the account has TaxDetail records, we return those records.
	-- Otherwise we return the defaults for that utility.
	-- =========================================================================================
	-- IT79 New Code Start 
	DECLARE @w_TaxStatusID INT;
	SELECT @w_TaxStatusID = TaxStatusID FROM LibertyPower..TaxStatus WHERE UPPER([Status]) = UPPER(LTRIM(RTRIM(@p_tax_status)));
	
	
	IF EXISTS (	SELECT A.AccountID
				FROM AccountTaxDetail atd (NOLOCK)
				JOIN LibertyPower..Account  A (NOLOCK)	 ON A.AccountIDLegacy = atd.AccountID
				WHERE  atd.AccountID = @p_account_id AND A.TaxStatusID = @w_TaxStatusID
			   )
	BEGIN
		SELECT t.TaxTypeID, b.PercentTaxable, t.TypeOfTax
		FROM TaxType t
		LEFT JOIN
			(
				SELECT PercentTaxable, atd.TaxTypeID
				FROM AccountTaxDetail atd (NOLOCK)
				JOIN LibertyPower..Account  A (NOLOCK) ON A.AccountIDLegacy = atd.AccountID
				WHERE  atd.AccountID = @p_account_id AND A.TaxStatusID = @w_TaxStatusID
			)b ON t.TaxTypeID = b.TaxTypeID
		ORDER BY t.TaxTypeID
	END
	ELSE
	BEGIN
		SELECT t.TaxTypeID, PercentTaxable, t.TypeOfTax
		FROM TaxType t
		LEFT JOIN
			(
				SELECT PercentTaxable, tt.TaxTypeID
				FROM TaxTemplate tt (NOLOCK)
				JOIN Utility u (NOLOCK) ON tt.utilityID = u.ID
				WHERE tt.template = @p_tax_status AND u.UtilityCode = @p_utility_id
			)b ON t.TaxTypeID = b.TaxTypeID
		ORDER BY t.TaxTypeID
	END	
	
	-- IT79 New Code End
	-- =========================================================================================
	
END
