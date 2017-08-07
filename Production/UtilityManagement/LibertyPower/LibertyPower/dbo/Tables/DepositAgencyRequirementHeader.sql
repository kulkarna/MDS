CREATE TABLE [dbo].[DepositAgencyRequirementHeader] (
    [DepositAgencyRequirementID] INT          IDENTITY (1, 1) NOT NULL,
    [AgencyID]                   INT          NOT NULL,
    [CreatedBy]                  VARCHAR (50) NOT NULL,
    [DateCreated]                DATETIME     NOT NULL,
    [ExpiredBy]                  VARCHAR (50) NULL,
    [DateExpired]                DATETIME     NULL
);


GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'Credit', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'DepositAgencyRequirementHeader';

