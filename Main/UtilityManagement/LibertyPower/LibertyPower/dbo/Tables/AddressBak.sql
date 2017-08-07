CREATE TABLE [dbo].[AddressBak] (
    [AddressID]    INT            IDENTITY (1, 1) NOT NULL,
    [Address1]     NVARCHAR (150) NULL,
    [Address2]     NVARCHAR (150) NULL,
    [City]         NVARCHAR (100) NULL,
    [State]        CHAR (2)       NULL,
    [StateFips]    CHAR (2)       NULL,
    [Zip]          CHAR (10)      NULL,
    [County]       NVARCHAR (100) NULL,
    [CountyFips]   CHAR (3)       NULL,
    [Modified]     DATETIME       NOT NULL,
    [ModifiedBy]   INT            NOT NULL,
    [DateCreated]  DATETIME       NOT NULL,
    [CreatedBy]    INT            NOT NULL,
    [account_id]   CHAR (12)      NOT NULL,
    [address_link] INT            NOT NULL
);

