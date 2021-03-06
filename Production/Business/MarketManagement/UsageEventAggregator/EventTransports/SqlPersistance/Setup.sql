USE [Lp_common]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[UsageEventsAggregate](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[CorrelationId] [bigint] NULL,
	[TimeSent] [datetime] NOT NULL,
	[MessageType] [varchar](255) NOT NULL,
	[Body] [varchar](max) NOT NULL,
	[Processing] [bit] NOT NULL,
	[ProcessedAt] [datetime] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[UsageEventsAggregate] ADD  CONSTRAINT [DF_UsageEventsAggregate_Processing]  DEFAULT ((0)) FOR [Processing]
GO


CREATE TABLE [dbo].[UsageEventsTransaction](
	[TransactionId] [bigint] IDENTITY(1,1) NOT NULL,
	[TimeStamp] [datetime] NOT NULL,
	[AccountNumber] [char](12) NOT NULL,
	[UtilityCode] [char](15) NOT NULL,
	[IsComplete] [bit] NOT NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[UsageEventsTransaction] ADD  CONSTRAINT [DF_UsageEventsTransaction_IsComplete]  DEFAULT ((0)) FOR [IsComplete]
GO

-- =============================================
-- Author:		Jay Barreto
-- Create date: 06/13/2013
-- Description:	Converts a comma delimited list to a table
-- =============================================
CREATE FUNCTION [dbo].[ufn_list_to_tbl] (@list nvarchar(MAX))
   RETURNS @tbl TABLE (item nvarchar(255) NOT NULL) AS
BEGIN
   DECLARE @pos        int,
           @nextpos    int,
           @valuelen   int

   SELECT @pos = 0, @nextpos = 1

   WHILE @nextpos > 0
   BEGIN
      SELECT @nextpos = charindex(',', @list, @pos + 1)
      SELECT @valuelen = CASE WHEN @nextpos > 0
                              THEN @nextpos
                              ELSE len(@list) + 1
                         END - @pos - 1
      INSERT @tbl (item)
         VALUES (substring(@list, @pos + 1, @valuelen))
      SELECT @pos = @nextpos
   END
   RETURN
END
GO

-- =============================================
-- Author:		Jay Barreto
-- Create date: 06/12/2013
-- Description:	Selects all events that are not being processed
-- =============================================
CREATE PROCEDURE [dbo].[usp_UsageEvents_GetEventMessages]
(
	@MessageTypes varchar(255)
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
    join dbo.ufn_list_to_tbl(@MessageTypes) mt on mt.item = ea.MessageType
    where ProcessedAt is null and Processing = 0 
    
    UPDATE UsageEventsAggregate
    set Processing = 1
    where id in (select Id from @UnprocessedEventIds)
    
    select ea.Id, CorrelationId, Body, TimeSent, MessageType
    from UsageEventsAggregate ea
    join @UnprocessedEventIds ue on ue.Id = ea.Id
    
END

GO

-- =============================================
-- Author:		Jay Barreto
-- Create date: 06/12/2013
-- Description:	Marks event as processed
-- =============================================
CREATE PROCEDURE [dbo].[usp_UsageEvents_MarkAsProcessed]
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
		ProcessedAt = GETDATE()
	where id = @EventMessageId
END

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

-- =============================================
-- Author:		Jay Barreto
-- Create date: 06/12/2013
-- Description: Starts a transaction and returns its id
-- =============================================
CREATE PROCEDURE [dbo].[usp_UsageEvents_StartTransaction]
(
	@TransactionId bigint out,
	@AccountNumber varchar(255),
	@UtilityCode varchar(255)
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	insert dbo.UsageEventsTransaction
	([TimeStamp], AccountNumber, UtilityCode)
	values
	(GETDATE(), @AccountNumber, @UtilityCode)
	
	set @TransactionId = @@IDENTITY
	
END
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

-- =============================================
-- Author:		Jay Barreto
-- Create date: 06/12/2013
-- Description: Sets a transaction as completed
-- =============================================
CREATE PROCEDURE [dbo].[usp_UsageEvents_SetTransactionAsComplete]
(
	@TransactionId bigint
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	update dbo.UsageEventsTransaction
	set IsComplete = 1
	where TransactionId = @TransactionId

	
END
GO
