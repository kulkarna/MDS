CREATE TABLE [dbo].[EdiTransactionException] (
    [EdiTransactionExceptionID]         NUMERIC (18)   IDENTITY (1, 1) NOT NULL,
    [UtilityID]                         INT            NOT NULL,
    [EdiTransactionTypeID]              NUMERIC (18)   NOT NULL,
    [EdiExceptionID]                    NUMERIC (18)   NOT NULL,
    [EdiLpEnrollmentSpecialistActionID] NUMERIC (18)   NOT NULL,
    [EdiBillingServiceProviderActionID] NUMERIC (18)   NOT NULL,
    [DateCreated]                       DATETIME       NOT NULL,
    [UserCreated]                       NVARCHAR (100) NOT NULL,
    [DateModified]                      DATETIME       NOT NULL,
    [UserModified]                      NVARCHAR (100) NOT NULL,
    [InactiveInd]                       BIT            NOT NULL,
    CONSTRAINT [PK_EdiTransactionExceptionID] PRIMARY KEY CLUSTERED ([EdiTransactionExceptionID] ASC) WITH (FILLFACTOR = 90)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [UtilityIDEdiTransactionTypeIDEdiExceptionID]
    ON [dbo].[EdiTransactionException]([UtilityID] ASC, [EdiTransactionTypeID] ASC, [EdiExceptionID] ASC) WITH (FILLFACTOR = 90);


GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'EDI', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'EdiTransactionException';

