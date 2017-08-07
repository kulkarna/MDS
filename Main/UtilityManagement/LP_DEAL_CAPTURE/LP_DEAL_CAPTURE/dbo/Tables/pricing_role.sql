CREATE TABLE [dbo].[pricing_role] (
    [pricing_id] INT CONSTRAINT [DF_pricing_file_role_pricing_id] DEFAULT ((0)) NOT NULL,
    [role_id]    INT CONSTRAINT [DF_pricing_file_role_role_id] DEFAULT ((0)) NOT NULL
);

