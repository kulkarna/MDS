CREATE TABLE [dbo].[tbl_RegulatoryAuthorities] (
    [AuthorityID]            INT            NOT NULL,
    [AuthorityName]          NVARCHAR (100) NOT NULL,
    [AuthorityState]         NVARCHAR (50)  NULL,
    [WorkingDays]            INT            NULL,
    [CalendarType]           NVARCHAR (50)  NULL,
    [RecordCreationDate]     DATETIME       NOT NULL,
    [RecordCreatedBy]        NVARCHAR (50)  NOT NULL,
    [RecordModificationDate] DATETIME       NOT NULL,
    [RecordModifiedBy]       NVARCHAR (50)  NOT NULL
);

