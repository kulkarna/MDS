CREATE TABLE [dbo].[AccountInfoSettlement_TEMP] (
    [ID]                 INT           IDENTITY (1, 1) NOT NULL,
    [FileLogID]          INT           NULL,
    [ElectricalBus]      VARCHAR (200) NULL,
    [NodeName]           VARCHAR (200) NULL,
    [PsseBusName]        VARCHAR (200) NULL,
    [VoltageLevel]       VARCHAR (200) NULL,
    [Substation]         VARCHAR (64)  NULL,
    [SettlementLoadZone] VARCHAR (200) NULL,
    [HubBusName]         VARCHAR (200) NULL,
    [Hub]                VARCHAR (200) NULL,
    [ResourceNode]       VARCHAR (200) NULL
);

