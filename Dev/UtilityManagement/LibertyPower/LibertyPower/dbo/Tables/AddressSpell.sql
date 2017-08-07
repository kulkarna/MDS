CREATE TABLE [dbo].[AddressSpell] (
    [AdressSpellId]    INT          IDENTITY (1, 1) NOT NULL,
    [Token]            VARCHAR (50) NOT NULL,
    [AlternativeToken] VARCHAR (50) NOT NULL
);

