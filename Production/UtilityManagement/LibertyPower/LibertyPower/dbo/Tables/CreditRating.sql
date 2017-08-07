CREATE TABLE [dbo].[CreditRating] (
    [CreditRatingID]    INT       NOT NULL,
    [CreditAgencyID]    INT       NOT NULL,
    [Rating]            CHAR (10) NOT NULL,
    [Numeric]           INT       NULL,
    [IsInvestmentGrade] TINYINT   NULL
);


GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'Credit', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CreditRating';

