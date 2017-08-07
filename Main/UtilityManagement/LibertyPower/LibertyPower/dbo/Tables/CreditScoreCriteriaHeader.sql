CREATE TABLE [dbo].[CreditScoreCriteriaHeader] (
    [CreditScoreCriteriaHeaderId] INT          IDENTITY (1, 1) NOT NULL,
    [CreditAgencyId]              INT          NOT NULL,
    [EffectiveDate]               DATETIME     NOT NULL,
    [ExpirationDate]              DATETIME     NULL,
    [CreatedBy]                   VARCHAR (50) NOT NULL,
    [ModifiedBy]                  VARCHAR (50) NULL,
    [CriteriaSetId]               INT          NOT NULL
);


GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'Credit', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CreditScoreCriteriaHeader';

