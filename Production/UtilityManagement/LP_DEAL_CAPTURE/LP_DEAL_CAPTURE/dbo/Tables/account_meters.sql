CREATE TABLE [dbo].[account_meters] (
    [account_id]   CHAR (12)    CONSTRAINT [DF_account_meters_account_id] DEFAULT ('') NOT NULL,
    [meter_number] VARCHAR (50) CONSTRAINT [DF_account_meters_meter_number] DEFAULT ('') NOT NULL
);

