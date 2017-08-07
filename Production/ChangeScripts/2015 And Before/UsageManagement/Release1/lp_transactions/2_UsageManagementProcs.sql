USE [Lp_transactions]
GO


PRINT N'Creating [dbo].[usp_GetUtilityCodeById]...';


GO
CREATE PROCEDURE [dbo].[usp_GetUtilityCodeById]
	@UtilityId int
AS
BEGIN
	SELECT	UtilityCode
	FROM	Utility
	WHERE	ID	= @UtilityId
END
GO
PRINT N'Creating [dbo].[usp_GetUtilityIdByCode]...';


GO
CREATE PROCEDURE [dbo].[usp_GetUtilityIdByCode]
	@UtilityCode varchar(255)
AS
BEGIN
	SELECT	ID
	FROM	Utility
	WHERE	UtilityCode	= @UtilityCode
END
GO

PRINT N'Creating [dbo].[usp_UsageEvents_GetAccountStatusMessageType]...';


GO
-- =============================================
-- Author:		Jay Barreto
-- Create date: 07/5/2013
-- Description:	Selects 814 account status message information
-- =============================================
CREATE PROCEDURE [dbo].[usp_UsageEvents_GetAccountStatusMessageType]
(
	@Message varchar(255)
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	select IsRejection, IsAcceptanceInformational, IsAcceptance, IsAcceptanceIdrAvailable, Description
	from dbo.UsageAccountStatusMessages
	where [Message] = @Message
    
END
GO
PRINT N'Creating [dbo].[usp_UsageEvents_GetEventMessages]...';


GO
-- =============================================
-- Author:		Jay Barreto
-- Create date: 06/12/2013
-- Description:	Selects all events that are not being processed
-- =============================================
CREATE PROCEDURE [dbo].[usp_UsageEvents_GetEventMessages]
(
	@MessageTypes dbo.UsageEvents_MessageType READONLY
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	declare @UnprocessedEventIds Table(Id bigint)
	insert into @UnprocessedEventIds
    select Id 
    from UsageEventsAggregate ea
    join @MessageTypes mt on mt.MessageType = ea.MessageType
    where ProcessedAt is null and Processing = 0 
	order by coalesce(CorrelationId, 9223372036854775807), id
    
    UPDATE UsageEventsAggregate
    set Processing = 1
    where id in (select Id from @UnprocessedEventIds)
    
    select ea.Id, CorrelationId, Body, TimeSent, MessageType
    from UsageEventsAggregate ea
    join @UnprocessedEventIds ue on ue.Id = ea.Id
    
END

GO
PRINT N'Creating [dbo].[usp_UsageEvents_GetTransactionById]...';


GO
-- =============================================
-- Author:		Jay Barreto
-- Create date: 06/12/2013
-- Description: Gets a transaction by id
-- =============================================
CREATE PROCEDURE [dbo].[usp_UsageEvents_GetTransactionById]
(
	@TransactionId bigint
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	select TransactionId, [TimeStamp], AccountNumber, UtilityCode,IsComplete, Error, Source
	from dbo.UsageEventsTransaction
	where TransactionId = @TransactionId

	
END
GO
PRINT N'Creating [dbo].[usp_UsageEvents_GetTransactionId]...';


GO
-- =============================================
-- Author:		Jay Barreto
-- Create date: 06/12/2013
-- Description: Gets a transaction id using account and utility code
-- =============================================
CREATE PROCEDURE [dbo].[usp_UsageEvents_GetTransactionId]
(
	@AccountNumber varchar(255),
	@UtilityCode varchar(255)
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	select TransactionId from dbo.UsageEventsTransaction
	where AccountNumber = @AccountNumber 
		and UtilityCode = @UtilityCode 
		and IsComplete = 0

	
END
GO
PRINT N'Creating [dbo].[usp_UsageEvents_MarkAsProcessed]...';


GO
-- =============================================
-- Author:		Jay Barreto
-- Create date: 06/12/2013
-- Description:	Marks event as processed
-- =============================================
CREATE PROCEDURE [dbo].[usp_UsageEvents_MarkAsProcessed]
(
	@EventMessageId bigint,
	@ErrorMessage varchar(max)
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	update UsageEventsAggregate
	set Processing = 0,
		ProcessedAt = GETDATE(),
		ErrorMessage = @ErrorMessage
	where id = @EventMessageId
END
GO
PRINT N'Creating [dbo].[usp_UsageEvents_SendEventMessage]...';


GO
-- =============================================
-- Author:		Jay Barreto
-- Create date: 06/12/2013
-- Description:	Marks event as processed
-- =============================================
CREATE PROCEDURE [dbo].[usp_UsageEvents_SendEventMessage]
(
	--@EventMessageId bigint out,
	@TimeSent datetime,
	@MessageType varchar(255),
	@CorrelationId bigint,
	@Body varchar(max)
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	insert into UsageEventsAggregate
	(TimeSent, MessageType, CorrelationId, Body)
	values
	(@TimeSent, @MessageType, @CorrelationId, @Body)
	
	--set @EventMessageId = @@IDENTITY
	
END
GO
PRINT N'Creating [dbo].[usp_UsageEvents_SetProcessingToFalse]...';


GO
-- =============================================
-- Author:		Jay Barreto
-- Create date: 06/12/2013
-- Description:	Marks event as no being processed
-- =============================================
CREATE PROCEDURE [dbo].[usp_UsageEvents_SetProcessingToFalse]
(
	@EventMessageId bigint
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	update UsageEventsAggregate
	set Processing = 0,
		ProcessedAt = null
	where id = @EventMessageId
END
GO
PRINT N'Creating [dbo].[usp_UsageEvents_SetTransactionAsComplete]...';


GO
-- =============================================
-- Author:		Jay Barreto
-- Create date: 06/12/2013
-- Description: Sets a transaction as completed
-- =============================================
CREATE PROCEDURE [dbo].[usp_UsageEvents_SetTransactionAsComplete]
(
	@TransactionId bigint,
	@Error varchar(max)
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	update dbo.UsageEventsTransaction
	set IsComplete = 1, Error = @Error
	where TransactionId = @TransactionId

	
END
GO
PRINT N'Creating [dbo].[usp_UsageEvents_StartTransaction]...';


GO
-- =============================================
-- Author:		Jay Barreto
-- Create date: 06/12/2013
-- Description: Starts a transaction and returns its id
-- =============================================
CREATE PROCEDURE [dbo].[usp_UsageEvents_StartTransaction]
(
	@TransactionId bigint out,
	@AccountNumber varchar(255),
	@UtilityCode varchar(255),
	@Source varchar(255)
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	insert dbo.UsageEventsTransaction
	([TimeStamp], AccountNumber, UtilityCode, Source)
	values
	(GETDATE(), @AccountNumber, @UtilityCode, @Source)
	
	set @TransactionId = @@IDENTITY
	
END
GO


CREATE PROCEDURE [dbo].[usp_EdiAccountsByFileLogId]
	@FileLogId int,
	@AccountNumber varchar(255),
	@UtilityCode varchar(255)
AS
BEGIN
    SET NOCOUNT ON;
    
	SELECT AccountNumber,UtilityCode, Icap, IcapEffectiveDate, Tcap, TcapEffectiveDate, ZoneCode, RateClass, LoadProfile, Voltage, EffectiveDate, BillGroup
 	FROM		lp_transactions..EdiAccount a WITH (NOLOCK)
	WHERE	a.AccountNumber		= @AccountNumber
	AND		a.UtilityCode		= @UtilityCode
	AND		a.EdiFileLogID = @FileLogId 

    SET NOCOUNT OFF;
END

PRINT N'Update complete.';


GO
