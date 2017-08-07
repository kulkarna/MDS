CREATE TABLE [dbo].[DealScreening] (
    [DealScreeningID]     INT           IDENTITY (1, 1) NOT NULL,
    [DealScreeningPathID] INT           NULL,
    [StepNumber]          INT           NULL,
    [StepType]            VARCHAR (50)  NULL,
    [ContractNumber]      VARCHAR (50)  NULL,
    [Disposition]         VARCHAR (50)  NULL,
    [UserName]            VARCHAR (50)  NULL,
    [DateDispositioned]   DATETIME      NULL,
    [Comments]            VARCHAR (MAX) NULL,
    [DateCreated]         DATETIME      CONSTRAINT [DF_DealScreening_DateCreated] DEFAULT (getdate()) NULL,
    [StepTypeID]          INT           NULL,
    CONSTRAINT [PK_DealScreening] PRIMARY KEY CLUSTERED ([DealScreeningID] ASC) WITH (FILLFACTOR = 90)
);


GO
CREATE NONCLUSTERED INDEX [ndx_ContractNumber]
    ON [dbo].[DealScreening]([ContractNumber] ASC) WITH (FILLFACTOR = 90);


GO
CREATE NONCLUSTERED INDEX [ndx_StepTypeID]
    ON [dbo].[DealScreening]([StepTypeID] ASC) WITH (FILLFACTOR = 90);


GO

-- =============================================
-- Author:		Eric Hernandez
-- Create date: 1-1-2010
-- Description:	
-- =============================================
CREATE TRIGGER [dbo].[tr_DealScreening_ins] 
   ON  [dbo].[DealScreening] 
   AFTER INSERT
AS
BEGIN
	DECLARE @ContractNumber VARCHAR(12)
	DECLARE @StepTypeID INT
	DECLARE @Disposition VARCHAR(50)
	DECLARE @call_request_id CHAR(15)

	DECLARE DealScreening_inserted_cursor CURSOR FOR 
	SELECT ContractNumber, StepTypeID, Disposition FROM inserted

	OPEN DealScreening_inserted_cursor
	FETCH NEXT FROM DealScreening_inserted_cursor INTO @ContractNumber, @StepTypeID, @Disposition

	WHILE @@FETCH_STATUS = 0
	BEGIN
		-- This is a check account step that can be automatically run and does not need user intervention.
		IF @StepTypeID = 5 AND @Disposition='PENDING' 
			EXEC lp_enrollment.dbo.usp_post_usage_credit_check @ContractNumber

		-- Updates usage for renewals automatically.
		IF @StepTypeID = 1 AND @Disposition='PENDING' AND EXISTS(select * from lp_account..account_renewal where contract_nbr = @ContractNumber)
			EXEC lp_enrollment.dbo.usp_renewal_usage_upd @ContractNumber

		-- If usage is already on the contract, step is approved right away.
		IF @StepTypeID = 1 AND @Disposition='PENDING' AND EXISTS(select * from lp_account..account where contract_nbr = @ContractNumber)
		BEGIN
			IF NOT EXISTS (SELECT * FROM lp_account.dbo.account 
							WHERE contract_nbr = @ContractNumber AND status not in ('999998','999999') AND annual_usage=0)
			BEGIN
				EXEC lp_enrollment.dbo.usp_check_account_approval_reject @p_username = N'Usage Trigger', @p_check_request_id = 'ENROLLMENT', @p_contract_nbr = @ContractNumber, @p_account_id = N'NONE', @p_account_number = N' ', @p_check_type = N'USAGE ACQUIRE', @p_approval_status = N'APPROVED', @p_comment = N'All Usage Acquired'
			END
		END

		-- If a sales channel submits a contract and the account is currently in the retention queue, then we remove it from the queue.
		IF @StepTypeID = 8 AND @Disposition='PENDING'
		BEGIN
			IF LEN(RTRIM(LTRIM(@ContractNumber))) > 0
				BEGIN
					SELECT	@call_request_id = call_request_id 
					FROM	lp_enrollment.dbo.retention_header r
							JOIN lp_account.dbo.account a ON r.account_id = a.account_id 
					WHERE	r.call_status = 'O' and a.contract_nbr = @ContractNumber

					UPDATE lp_enrollment..retention_header
					SET call_status = 'S', call_reason_code = '1023'
					FROM lp_enrollment.dbo.retention_header r
					JOIN lp_account.dbo.account a ON r.account_id = a.account_id
					WHERE r.call_status = 'O' and a.contract_nbr = @ContractNumber
					
					IF @@ROWCOUNT > 0
						BEGIN
							INSERT INTO	lp_enrollment..retention_comment
										(call_request_id, date_comment, call_status, call_reason_code, 
										comment, nextcalldate, username, chgstamp)
							VALUES		(@call_request_id, GETDATE(), 'S', '1023', 
													'Contract Renewing', '', 'SYSTEM', 0 )
						END
				END
		END

		FETCH NEXT FROM DealScreening_inserted_cursor INTO @ContractNumber, @StepTypeID, @Disposition
	END

	CLOSE DealScreening_inserted_cursor
	DEALLOCATE DealScreening_inserted_cursor

END











GO
DISABLE TRIGGER [dbo].[tr_DealScreening_ins]
    ON [dbo].[DealScreening];


GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'DealScreening', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'DealScreening';

