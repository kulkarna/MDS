CREATE PROCEDURE [dbo].[usp_LogServiceCall]
@p_description AS XML,
@p_message AS XML

AS
SET NOCOUNT ON;

DECLARE 
	@guid AS UNIQUEIDENTIFIER,
	@action AS VARCHAR(500),
	@ip VARCHAR(39),
	@timestamp DATETIME;
	
SELECT 
		 @guid = M.Item.query('./Guid').value('.','UNIQUEIDENTIFIER')
		,@action = M.Item.query('./Action').value('.','VARCHAR(500)')
		,@ip = M.Item.query('./Ip').value('.','VARCHAR(15)')
		,@timestamp = M.Item.query('./Timestamp').value('.','DATETIME')
FROM @p_description.nodes('/ServiceCallTrace') AS M(Item);

INSERT  INTO [dbo].[OE_SERVICE_LOG]
        ( [Guid] ,
          [Action] ,
          [Ip] ,
          [Timestamp] ,
          [Message]
        )
VALUES  ( @guid ,
          @action ,
          @ip ,
          @timestamp ,
          @p_message
        ) ;

