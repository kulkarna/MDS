CREATE TABLE [dbo].[deal_contract_account] (
    [contract_nbr]              CHAR (12)      NOT NULL,
    [contract_type]             VARCHAR (25)   NOT NULL,
    [account_number]            VARCHAR (30)   NOT NULL,
    [status]                    VARCHAR (15)   NOT NULL,
    [account_id]                CHAR (12)      NOT NULL,
    [retail_mkt_id]             CHAR (2)       NOT NULL,
    [utility_id]                CHAR (15)      NOT NULL,
    [account_type]              INT            NULL,
    [product_id]                CHAR (20)      NOT NULL,
    [rate_id]                   INT            NOT NULL,
    [rate]                      FLOAT (53)     NOT NULL,
    [account_name_link]         INT            NOT NULL,
    [customer_name_link]        INT            NOT NULL,
    [customer_address_link]     INT            NOT NULL,
    [customer_contact_link]     INT            NOT NULL,
    [billing_address_link]      INT            NOT NULL,
    [billing_contact_link]      INT            NOT NULL,
    [owner_name_link]           INT            NOT NULL,
    [service_address_link]      INT            NOT NULL,
    [business_type]             VARCHAR (35)   NOT NULL,
    [business_activity]         VARCHAR (35)   NOT NULL,
    [additional_id_nbr_type]    VARCHAR (10)   NOT NULL,
    [additional_id_nbr]         VARCHAR (30)   NOT NULL,
    [contract_eff_start_date]   DATETIME       NOT NULL,
    [enrollment_type]           INT            NULL,
    [term_months]               INT            NOT NULL,
    [date_end]                  DATETIME       NOT NULL,
    [date_deal]                 DATETIME       NOT NULL,
    [date_created]              DATETIME       NOT NULL,
    [date_submit]               DATETIME       NOT NULL,
    [sales_channel_role]        NVARCHAR (50)  NOT NULL,
    [username]                  NCHAR (100)    NOT NULL,
    [sales_rep]                 VARCHAR (100)  NOT NULL,
    [origin]                    VARCHAR (50)   NOT NULL,
    [grace_period]              INT            NOT NULL,
    [chgstamp]                  SMALLINT       NOT NULL,
    [requested_flow_start_date] DATETIME       NULL,
    [deal_type]                 CHAR (20)      NULL,
    [customer_code]             CHAR (5)       NULL,
    [customer_group]            CHAR (100)     NULL,
    [SSNClear]                  NVARCHAR (100) NULL,
    [SSNEncrypted]              NVARCHAR (512) NULL,
    [CreditScoreEncrypted]      NVARCHAR (512) NULL,
    [HeatIndexSourceID]         INT            NULL,
    [HeatRate]                  DECIMAL (9, 2) NULL,
    [evergreen_option_id]       INT            NULL,
    [evergreen_commission_end]  DATETIME       NULL,
    [residual_option_id]        INT            NULL,
    [residual_commission_end]   DATETIME       NULL,
    [initial_pymt_option_id]    INT            NULL,
    [evergreen_commission_rate] FLOAT (53)     NULL,
    [zone]                      VARCHAR (20)   NULL,
    [TaxStatus]                 INT            NULL,
    [PriceID]                   BIGINT         NULL,
    [RatesString]               VARCHAR (200)  NULL
);


GO
CREATE UNIQUE CLUSTERED INDEX [deal_contract_account_idx]
    ON [dbo].[deal_contract_account]([contract_nbr] ASC, [account_number] ASC);


GO
CREATE NONCLUSTERED INDEX [deal_contract_account_idx1]
    ON [dbo].[deal_contract_account]([account_number] ASC, [contract_nbr] ASC) WITH (ALLOW_PAGE_LOCKS = OFF);


GO
CREATE NONCLUSTERED INDEX [deal_contract_account_idx2]
    ON [dbo].[deal_contract_account]([account_id] ASC, [account_number] ASC) WITH (ALLOW_PAGE_LOCKS = OFF);


GO
CREATE NONCLUSTERED INDEX [deal_contract_account_idx3]
    ON [dbo].[deal_contract_account]([sales_channel_role] ASC) WITH (ALLOW_PAGE_LOCKS = OFF);


GO
-- =============================================
-- Author		: Jose Munoz - SWCS
-- Create date	: 08/19/2010
-- Ticket		:
-- Description	: Validate account number with the utility number definition
-- =============================================
CREATE TRIGGER [dbo].[trg_deal_contract_account_ins]
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
