/*******************************************************************************
 * usp_EflTermsSelect
 * To get terms by account type
 *
 * History
 *******************************************************************************
 * 7/29/2009 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_EflTermsSelect]
	@AccountType	varchar(50),
	@ProductId		varchar(50),
	@Process		varchar(50)	= ''
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE	@ProcessId	int
    
    SELECT	@ProcessId = ID
    FROM	EflProcess
    WHERE	Process = @Process
    
    IF @ProcessId = 3
		BEGIN
			SELECT	DISTINCT r.term_months AS Term
			FROM	lp_common..common_product p WITH (NOLOCK)
					INNER JOIN lp_common..common_product_rate r ON p.product_id = r.product_id
			WHERE	p.product_id = @ProductId
			AND		r.term_months IS NOT NULL    
		END
	ELSE
		BEGIN
			SELECT	DISTINCT AccountTypeID, ISNULL(Term, 0) AS Term
			FROM	EflParameters u WITH (NOLOCK)
					INNER JOIN AccountType a WITH (NOLOCK) ON a.ID = u.AccountTypeID
			WHERE	a.AccountType	= @AccountType
			AND		u.ProductId		= @ProductId
			AND		Term IS NOT NULL
		END
    SET NOCOUNT OFF;
END
-- Copyright 2009 Liberty Power
