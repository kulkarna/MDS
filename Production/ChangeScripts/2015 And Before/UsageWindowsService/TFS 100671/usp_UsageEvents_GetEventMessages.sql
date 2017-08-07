USE [lp_transactions]
GO

/****** Object:  StoredProcedure [dbo].[usp_UsageEvents_GetEventMessages]    Script Date: 12/28/2015 10:28:39 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Jay Barreto
-- Create date: 06/12/2013
-- Description:	Selects all events that are not being processed
-- =============================================
ALTER PROCEDURE [dbo].[usp_UsageEvents_GetEventMessages]
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
    select top(100) Id 
    from UsageEventsAggregate ea
    join @MessageTypes mt on mt.MessageType = ea.MessageType
    where ProcessedAt is null and Processing = 0
    and Id > 30000000
    ORDER BY  ea.TimeSent Asc
    
    UPDATE UsageEventsAggregate
    set Processing = 1
    where id in (select Id from @UnprocessedEventIds)
    
    select ea.Id, CorrelationId, Body, TimeSent, MessageType
    from UsageEventsAggregate ea
    join @UnprocessedEventIds ue on ue.Id = ea.Id
    
END



GO


