USE [LibertyPower]
GO

/****** Object:  StoredProcedure [dbo].[usp_LibertyEventInsert]    Script Date: 07/26/2012 16:32:45 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Ryan Russon
-- Create date: 2012-07-26
-- Description:	Inserts a Liberty Event (updates are only done through the processing service)
-- =============================================

ALTER PROCEDURE [dbo].[usp_LibertyEventInsert] 
(
	@ParentEventId		int = NULL			--DEFAULT: No Parent
	,@EventDomainId		tinyint				--Indicates AccountEvent (1), ContractEvent (2), or CustomerEvent (3)
	,@EventStatusId		tinyint = 1			--DEFAULT: Event Created
	,@EventTypeId		int					--May represent an AccountEvent, ContractEvent, or CustomerEvent type
	,@ScheduledTime		datetime = GETDATE	--DEFAULT: execute immediately
	,@LastUpdated		datetime
	,@Notes				nvarchar(500)
	,@CreatedBy			varchar(200)
	,@EntityId			int					--AccountId for Account events, ContractId for Contract events, CustomerId for Customer events
)

AS

BEGIN
	
	SET NOCOUNT ON;

	INSERT INTO [LibertyPower]..[EventInstance] (
           [ParentEventId]
           ,[EventDomainId]
           ,[EventStatusId]
           ,[ScheduledTime]
           ,[LastUpdated]
           ,[IsStarted]
           ,[IsSuspended]
           ,[IsCompleted]
           ,[Notes]
           ,[CreatedBy]
           ,[DateCreated]
     ) VALUES (
          @ParentEventId	
           ,@EventDomainId	
           ,@EventStatusId	
           ,@ScheduledTime	
           ,@LastUpdated	
           ,0					--@IsStarted		
           ,0					--@IsSuspended	
           ,0					--@IsCompleted	
           ,@Notes
           ,@CreatedBy
           ,GETDATE()			--@DateCreated
	)	

	DECLARE @EventInstanceId	INT
	SET @EventInstanceId = @@IDENTITY

	-----SET SUBCLASS

	IF @EventDomainId = 1
		INSERT INTO [LibertyPower]..[AccountEvent] (
			[EventInstanceId]
			,[AccountEventTypeId]
			,[AccountId]
		) VALUES (
			@EventInstanceId
			,@EventTypeId
			,@EntityId			--@AccountId
		)

	IF @EventDomainId = 2
	INSERT INTO [LibertyPower]..[ContractEvent] (
			[EventInstanceId]
			,[ContractEventTypeId]
			,[ContractId]
		) VALUES (
			@EventInstanceId
			,@EventTypeId
			,@EntityId			--@ContractId
		)

	IF @EventDomainId = 3
	INSERT INTO [LibertyPower]..[CustomerEvent] (
			[EventInstanceId]
			,[CustomerEventTypeId]
			,[CustomerId]
		) VALUES (
			@EventInstanceId
			,@EventTypeId
			,@EntityId			--@CustomerId
		)

END

GO


