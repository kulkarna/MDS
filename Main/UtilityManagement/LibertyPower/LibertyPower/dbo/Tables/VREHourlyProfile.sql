CREATE TABLE [dbo].[VREHourlyProfile] (
    [ID]              INT              IDENTITY (1, 1) NOT NULL,
    [FileContextGUID] UNIQUEIDENTIFIER NOT NULL,
    [UtilityCode]     VARCHAR (50)     NOT NULL,
    [ZoneID]          VARCHAR (50)     NULL,
    [LoadShapeID]     VARCHAR (50)     NULL,
    [Date]            DATETIME         NOT NULL,
    [H1]              DECIMAL (18, 4)  CONSTRAINT [DF_VREHourlyProfile_H1] DEFAULT ((0)) NOT NULL,
    [H2]              DECIMAL (18, 4)  CONSTRAINT [DF_VREHourlyProfile_H2] DEFAULT ((0)) NOT NULL,
    [H3]              DECIMAL (18, 4)  CONSTRAINT [DF_VREHourlyProfile_H3] DEFAULT ((0)) NOT NULL,
    [H4]              DECIMAL (18, 4)  CONSTRAINT [DF_VREHourlyProfile_H4] DEFAULT ((0)) NOT NULL,
    [H5]              DECIMAL (18, 4)  CONSTRAINT [DF_VREHourlyProfile_H5] DEFAULT ((0)) NOT NULL,
    [H6]              DECIMAL (18, 4)  CONSTRAINT [DF_VREHourlyProfile_H6] DEFAULT ((0)) NOT NULL,
    [H7]              DECIMAL (18, 4)  CONSTRAINT [DF_VREHourlyProfile_H7] DEFAULT ((0)) NOT NULL,
    [H8]              DECIMAL (18, 4)  CONSTRAINT [DF_VREHourlyProfile_H8] DEFAULT ((0)) NOT NULL,
    [H9]              DECIMAL (18, 4)  CONSTRAINT [DF_VREHourlyProfile_H9] DEFAULT ((0)) NOT NULL,
    [H10]             DECIMAL (18, 4)  CONSTRAINT [DF_VREHourlyProfile_H10] DEFAULT ((0)) NOT NULL,
    [H11]             DECIMAL (18, 4)  CONSTRAINT [DF_VREHourlyProfile_H11] DEFAULT ((0)) NOT NULL,
    [H12]             DECIMAL (18, 4)  CONSTRAINT [DF_VREHourlyProfile_H12] DEFAULT ((0)) NOT NULL,
    [H13]             DECIMAL (18, 4)  CONSTRAINT [DF_VREHourlyProfile_H13] DEFAULT ((0)) NOT NULL,
    [H14]             DECIMAL (18, 4)  CONSTRAINT [DF_VREHourlyProfile_H14] DEFAULT ((0)) NOT NULL,
    [H15]             DECIMAL (18, 4)  CONSTRAINT [DF_VREHourlyProfile_H15] DEFAULT ((0)) NOT NULL,
    [H16]             DECIMAL (18, 4)  CONSTRAINT [DF_VREHourlyProfile_H16] DEFAULT ((0)) NOT NULL,
    [H17]             DECIMAL (18, 4)  CONSTRAINT [DF_VREHourlyProfile_H17] DEFAULT ((0)) NOT NULL,
    [H18]             DECIMAL (18, 4)  CONSTRAINT [DF_VREHourlyProfile_H18] DEFAULT ((0)) NOT NULL,
    [H19]             DECIMAL (18, 4)  CONSTRAINT [DF_VREHourlyProfile_H19] DEFAULT ((0)) NOT NULL,
    [H20]             DECIMAL (18, 4)  CONSTRAINT [DF_VREHourlyProfile_H20] DEFAULT ((0)) NOT NULL,
    [H21]             DECIMAL (18, 4)  CONSTRAINT [DF_VREHourlyProfile_H21] DEFAULT ((0)) NOT NULL,
    [H22]             DECIMAL (18, 4)  CONSTRAINT [DF_VREHourlyProfile_H22] DEFAULT ((0)) NOT NULL,
    [H23]             DECIMAL (18, 4)  CONSTRAINT [DF_VREHourlyProfile_H23] DEFAULT ((0)) NOT NULL,
    [H24]             DECIMAL (18, 4)  CONSTRAINT [DF_VREHourlyProfile_H24] DEFAULT ((0)) NOT NULL,
    [DateCreated]     DATETIME         CONSTRAINT [DF_VREHourlyProfile_DateCreated] DEFAULT (getdate()) NOT NULL,
    [CreatedBy]       INT              CONSTRAINT [DF_VREHourlyProfile_CreatedBy] DEFAULT ((1)) NOT NULL,
    [DateModified]    DATETIME         CONSTRAINT [DF_VREHourlyProfile_DateModified] DEFAULT (getdate()) NOT NULL,
    [ModifiedBy]      INT              CONSTRAINT [DF_VREHourlyProfile_ModifiedBy] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_VREHourlyProfile] PRIMARY KEY CLUSTERED ([ID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [VREHourlyProfile__Date_I]
    ON [dbo].[VREHourlyProfile]([Date] ASC)
    INCLUDE([ID], [FileContextGUID], [UtilityCode], [ZoneID], [LoadShapeID], [DateCreated]);


GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'VRE', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'VREHourlyProfile';

