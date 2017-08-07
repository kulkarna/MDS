CREATE TABLE [dbo].[VRECaisoDayAhead] (
    [ID]              INT              IDENTITY (1, 1) NOT NULL,
    [FileContextGUID] UNIQUEIDENTIFIER NOT NULL,
    [Date]            DATETIME         NOT NULL,
    [NodeID]          VARCHAR (50)     NULL,
    [H1]              DECIMAL (18, 4)  NOT NULL,
    [H2]              DECIMAL (18, 4)  NOT NULL,
    [H3]              DECIMAL (18, 4)  NOT NULL,
    [H4]              DECIMAL (18, 4)  NOT NULL,
    [H5]              DECIMAL (18, 4)  NOT NULL,
    [H6]              DECIMAL (18, 4)  NOT NULL,
    [H7]              DECIMAL (18, 4)  NOT NULL,
    [H8]              DECIMAL (18, 4)  NOT NULL,
    [H9]              DECIMAL (18, 4)  NOT NULL,
    [H10]             DECIMAL (18, 4)  NOT NULL,
    [H11]             DECIMAL (18, 4)  NOT NULL,
    [H12]             DECIMAL (18, 4)  NOT NULL,
    [H13]             DECIMAL (18, 4)  NOT NULL,
    [H14]             DECIMAL (18, 4)  NOT NULL,
    [H15]             DECIMAL (18, 4)  NOT NULL,
    [H16]             DECIMAL (18, 4)  NOT NULL,
    [H17]             DECIMAL (18, 4)  NOT NULL,
    [H18]             DECIMAL (18, 4)  NOT NULL,
    [H19]             DECIMAL (18, 4)  NOT NULL,
    [H20]             DECIMAL (18, 4)  NOT NULL,
    [H21]             DECIMAL (18, 4)  NOT NULL,
    [H22]             DECIMAL (18, 4)  NOT NULL,
    [H23]             DECIMAL (18, 4)  NOT NULL,
    [H24]             DECIMAL (18, 4)  NOT NULL,
    [DateCreated]     DATETIME         CONSTRAINT [DF_VRECaisoDayAhead_DateCreated] DEFAULT (getdate()) NOT NULL,
    [CreatedBy]       INT              CONSTRAINT [DF_VRECaisoDayAhead_CreatedBy] DEFAULT ((1)) NOT NULL,
    [DateModified]    DATETIME         CONSTRAINT [DF_VRECaisoDayAhead_DateModified] DEFAULT (getdate()) NOT NULL,
    [ModifiedBy]      INT              CONSTRAINT [DF_VRECaisoDayAhead_ModifiedBy] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_VRECaisoDayAhead] PRIMARY KEY CLUSTERED ([ID] ASC)
);


GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'VRE', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'VRECaisoDayAhead';

