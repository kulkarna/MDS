CREATE TABLE [dbo].[VRECapacityTransmissionFactor] (
    [ID]              INT              IDENTITY (1, 1) NOT NULL,
    [FileContextGUID] UNIQUEIDENTIFIER NOT NULL,
    [UtilityCode]     VARCHAR (50)     NOT NULL,
    [LoadShapeID]     VARCHAR (50)     NULL,
    [Month]           INT              NOT NULL,
    [Year]            INT              NOT NULL,
    [Capacity]        DECIMAL (18, 4)  NOT NULL,
    [Transmission]    DECIMAL (18, 4)  NOT NULL,
    [DateCreated]     DATETIME         CONSTRAINT [DF_VRECapacityTransmissionFactor_DateCreated] DEFAULT (getdate()) NOT NULL,
    [CreatedBy]       INT              CONSTRAINT [DF_VRECapacityTransmissionFactor_CreatedBy] DEFAULT ((1)) NOT NULL,
    [DateModified]    DATETIME         CONSTRAINT [DF_VRECapacityTransmissionFactor_DateModified] DEFAULT (getdate()) NOT NULL,
    [ModifiedBy]      INT              CONSTRAINT [DF_VRECapacityTransmissionFactor_ModifiedBy] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_VRECapacityTransmissionFactor] PRIMARY KEY CLUSTERED ([ID] ASC)
);


GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'VRE', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'VRECapacityTransmissionFactor';

