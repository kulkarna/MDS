-- =============================================
-- Author:		Rick Deigsler
-- Create date: 2/2/2009
-- Description:	Zero out usage to allow re-pricing
-- =============================================
CREATE PROCEDURE [dbo].[usp_account_zero_out_usage]

@p_account_number		varchar(50)

AS

UPDATE	OE_ACCOUNT
SET		ANNUAL_USAGE	= 0
--		ICAP			= 0,
--		TCAP			= 0
WHERE	ACCOUNT_NUMBER	= @p_account_number

