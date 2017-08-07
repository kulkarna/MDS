CREATE TABLE [dbo].[zTempAC] (
    [TempIDKey]    INT       IDENTITY (1, 1) NOT NULL,
    [contract_nbr] CHAR (12) NULL,
    [account_id]   CHAR (12) NULL,
    [AccountID]    INT       NULL,
    [ContractID]   INT       NULL,
    [IsRenewal]    BIT       CONSTRAINT [DF_zTempAC_IsRenewal] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_zTempAC] PRIMARY KEY CLUSTERED ([TempIDKey] ASC)
);

