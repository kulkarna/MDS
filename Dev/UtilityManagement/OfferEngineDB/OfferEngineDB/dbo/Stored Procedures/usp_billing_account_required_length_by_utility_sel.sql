/*******************************************************************************
 * usp_billing_account_required_length_by_utility_sel
 * Determines what utilities use billing account #'s + what the correct length is
 *
 * History
 *******************************************************************************
 * 05/06/2009 - Eduardo Patino
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_billing_account_required_length_by_utility_sel]
	@p_utility_id		varchar(50)
AS
BEGIN
    SET NOCOUNT ON;

	SELECT	required_length
	FROM	lp_common..utility_required_data WITH (NOLOCK)
	WHERE	utility_id = @p_utility_id AND account_info_field = 'BillingAccount'

    SET NOCOUNT OFF;
END
-- Copyright 2009 Liberty Power

