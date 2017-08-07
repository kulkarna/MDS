USE [Libertypower]
GO
/****** Object:  ForeignKey [FK_AccountEvent_Account]    Script Date: 07/18/2013 14:03:21 ******/
ALTER TABLE [dbo].[AccountEvent] DROP CONSTRAINT [FK_AccountEvent_Account]
GO
/****** Object:  ForeignKey [FK_AccountEvent_AccountEventType]    Script Date: 07/18/2013 14:03:21 ******/
ALTER TABLE [dbo].[AccountEvent] DROP CONSTRAINT [FK_AccountEvent_AccountEventType]
GO
/****** Object:  ForeignKey [FK_AccountEvent_EventInstance]    Script Date: 07/18/2013 14:03:21 ******/
ALTER TABLE [dbo].[AccountEvent] DROP CONSTRAINT [FK_AccountEvent_EventInstance]
GO
/****** Object:  ForeignKey [FK_CustomerEvent_Customer]    Script Date: 07/18/2013 14:03:21 ******/
ALTER TABLE [dbo].[CustomerEvent] DROP CONSTRAINT [FK_CustomerEvent_Customer]
GO
/****** Object:  ForeignKey [FK_CustomerEvent_CustomerEventType]    Script Date: 07/18/2013 14:03:21 ******/
ALTER TABLE [dbo].[CustomerEvent] DROP CONSTRAINT [FK_CustomerEvent_CustomerEventType]
GO
/****** Object:  ForeignKey [FK_CustomerEvent_EventInstance]    Script Date: 07/18/2013 14:03:21 ******/
ALTER TABLE [dbo].[CustomerEvent] DROP CONSTRAINT [FK_CustomerEvent_EventInstance]
GO
/****** Object:  ForeignKey [FK_ContractEvent_Contract]    Script Date: 07/18/2013 14:03:22 ******/
ALTER TABLE [dbo].[ContractEvent] DROP CONSTRAINT [FK_ContractEvent_Contract]
GO
/****** Object:  ForeignKey [FK_ContractEvent_ContractEventType]    Script Date: 07/18/2013 14:03:22 ******/
ALTER TABLE [dbo].[ContractEvent] DROP CONSTRAINT [FK_ContractEvent_ContractEventType]
GO
/****** Object:  ForeignKey [FK_ContractEvent_EventInstance]    Script Date: 07/18/2013 14:03:22 ******/
ALTER TABLE [dbo].[ContractEvent] DROP CONSTRAINT [FK_ContractEvent_EventInstance]
GO
/****** Object:  ForeignKey [FK_EventError_EventInstance]    Script Date: 07/18/2013 14:03:22 ******/
ALTER TABLE [dbo].[EventError] DROP CONSTRAINT [FK_EventError_EventInstance]
GO
/****** Object:  ForeignKey [FK_EventInstance_EventDomain]    Script Date: 07/18/2013 14:03:22 ******/
ALTER TABLE [dbo].[EventInstance] DROP CONSTRAINT [FK_EventInstance_EventDomain]
GO
/****** Object:  ForeignKey [FK_EventInstance_EventStatus]    Script Date: 07/18/2013 14:03:22 ******/
ALTER TABLE [dbo].[EventInstance] DROP CONSTRAINT [FK_EventInstance_EventStatus]
GO
/****** Object:  ForeignKey [FK_ParentEventInstance_EventInstance]    Script Date: 07/18/2013 14:03:22 ******/
ALTER TABLE [dbo].[EventInstance] DROP CONSTRAINT [FK_ParentEventInstance_EventInstance]
GO
/****** Object:  Table [dbo].[ContractEvent]    Script Date: 07/18/2013 14:03:22 ******/
ALTER TABLE [dbo].[ContractEvent] DROP CONSTRAINT [FK_ContractEvent_Contract]
GO
ALTER TABLE [dbo].[ContractEvent] DROP CONSTRAINT [FK_ContractEvent_ContractEventType]
GO
ALTER TABLE [dbo].[ContractEvent] DROP CONSTRAINT [FK_ContractEvent_EventInstance]
GO
DROP TABLE [dbo].[ContractEvent]
GO
/****** Object:  Table [dbo].[EventError]    Script Date: 07/18/2013 14:03:22 ******/
ALTER TABLE [dbo].[EventError] DROP CONSTRAINT [FK_EventError_EventInstance]
GO
ALTER TABLE [dbo].[EventError] DROP CONSTRAINT [DF_EventError_ErrorDate]
GO
DROP TABLE [dbo].[EventError]
GO
/****** Object:  Table [dbo].[AccountEvent]    Script Date: 07/18/2013 14:03:21 ******/
ALTER TABLE [dbo].[AccountEvent] DROP CONSTRAINT [FK_AccountEvent_Account]
GO
ALTER TABLE [dbo].[AccountEvent] DROP CONSTRAINT [FK_AccountEvent_AccountEventType]
GO
ALTER TABLE [dbo].[AccountEvent] DROP CONSTRAINT [FK_AccountEvent_EventInstance]
GO
DROP TABLE [dbo].[AccountEvent]
GO
/****** Object:  Table [dbo].[CustomerEvent]    Script Date: 07/18/2013 14:03:21 ******/
ALTER TABLE [dbo].[CustomerEvent] DROP CONSTRAINT [FK_CustomerEvent_Customer]
GO
ALTER TABLE [dbo].[CustomerEvent] DROP CONSTRAINT [FK_CustomerEvent_CustomerEventType]
GO
ALTER TABLE [dbo].[CustomerEvent] DROP CONSTRAINT [FK_CustomerEvent_EventInstance]
GO
DROP TABLE [dbo].[CustomerEvent]
GO
/****** Object:  Table [dbo].[EventInstance]    Script Date: 07/18/2013 14:03:22 ******/
ALTER TABLE [dbo].[EventInstance] DROP CONSTRAINT [FK_EventInstance_EventDomain]
GO
ALTER TABLE [dbo].[EventInstance] DROP CONSTRAINT [FK_EventInstance_EventStatus]
GO
ALTER TABLE [dbo].[EventInstance] DROP CONSTRAINT [FK_ParentEventInstance_EventInstance]
GO
ALTER TABLE [dbo].[EventInstance] DROP CONSTRAINT [DF__EventInst__Statu__03317E3D]
GO
ALTER TABLE [dbo].[EventInstance] DROP CONSTRAINT [DF_EventInstance_ScheduledTime]
GO
ALTER TABLE [dbo].[EventInstance] DROP CONSTRAINT [DF__EventInst__LastU__7F60ED59]
GO
ALTER TABLE [dbo].[EventInstance] DROP CONSTRAINT [DF__EventInst__IsSta__00551192]
GO
ALTER TABLE [dbo].[EventInstance] DROP CONSTRAINT [DF__EventInst__IsSus__014935CB]
GO
ALTER TABLE [dbo].[EventInstance] DROP CONSTRAINT [DF__EventInst__IsCom__023D5A04]
GO
ALTER TABLE [dbo].[EventInstance] DROP CONSTRAINT [DF_EventInstance_CreatedBy]
GO
ALTER TABLE [dbo].[EventInstance] DROP CONSTRAINT [DF__EventInst__Creat__7E6CC920]
GO
DROP TABLE [dbo].[EventInstance]
GO
/****** Object:  Table [dbo].[EventDomain]    Script Date: 07/18/2013 14:03:22 ******/
ALTER TABLE [dbo].[EventDomain] DROP CONSTRAINT [DF_EventTypes_IsActive]
GO
ALTER TABLE [dbo].[EventDomain] DROP CONSTRAINT [DF_EventType_DateCreated]
GO
DROP TABLE [dbo].[EventDomain]
GO
/****** Object:  Table [dbo].[EventStatus]    Script Date: 07/18/2013 14:03:22 ******/
ALTER TABLE [dbo].[EventStatus] DROP CONSTRAINT [DF_EventStatus_IsActive]
GO
ALTER TABLE [dbo].[EventStatus] DROP CONSTRAINT [DF_EventStatus_DateCreated]
GO
DROP TABLE [dbo].[EventStatus]
GO
