USE [lp_deal_capture]
GO
/****** Object:  Trigger [dbo].[trg_deal_contract_account_ins]    Script Date: 04/27/2012 17:32:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author		: Jose Munoz - SWCS
-- Create date	: 08/19/2010
-- Ticket		:
-- Description	: Validate account number with the utility number definition
-- =============================================
ALTER TRIGGER [dbo].[trg_deal_contract_account_ins]
   ON  [lp_deal_capture].[dbo].[deal_contract_account]
   AFTER INSERT
AS 
BEGIN
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @AccountNumber			varchar(30)
		,@UtilityCode				varchar(15)
		,@message					varchar(200)
		,@FlagErrorLenAccount		bit
		,@FlagErrorLenPrefix		bit
		
	SELECT 	@AccountNumber			= ltrim(rtrim(ins.account_number))
		,@UtilityCode				= ltrim(rtrim(ins.utility_id))
		,@FlagErrorLenAccount		= case when ((LEN(ins.account_number)	<> uti.AccountLength) AND (uti.AccountLength <> 0)) then 1 else 0 end
		,@FlagErrorLenPrefix		= case when ((LEFT(ins.account_number, LEN(uti.AccountNumberPrefix)) <> uti.AccountNumberPrefix)
												AND (LTRIM(RTRIM(uti.AccountNumberPrefix)) <> '')) then 1 else 0 end
	FROM inserted ins
	INNER JOIN Libertypower..Utility uti WITH(NOLOCK)
	ON uti.UtilityCode				= ins.utility_id
	WHERE ((LEN(ins.account_number)	<> uti.AccountLength) AND (uti.AccountLength <> 0))
	OR  ((LEFT(ins.account_number, LEN(uti.AccountNumberPrefix)) <> uti.AccountNumberPrefix)
		AND (LTRIM(RTRIM(uti.AccountNumberPrefix)) <> ''))
	
	IF @@ROWCOUNT > 0
	begin
	
		set @message = 'The account number ' + @AccountNumber + '(' + @UtilityCode + ') does not meet the utility number definition. ' 
					+ case	when	(@FlagErrorLenAccount = 1 and @FlagErrorLenPrefix = 1) then '(The Account Length and the Account Number Prefix are not valid)'
							when	(@FlagErrorLenAccount = 1 and @FlagErrorLenPrefix = 0) then '(The Account Length is invalid)'
							when	(@FlagErrorLenAccount = 0 and @FlagErrorLenPrefix = 1) then '(The Account Number Prefix is invalid)' end
		rollback
		raiserror 26001 @message
	end

	SET NOCOUNT OFF;
    -- Insert statements for trigger here
END
