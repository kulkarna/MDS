--------------------------------------------------------------------
-- Remove any existing objects.
--------------------------------------------------------------------

IF EXISTS (SELECT *
           FROM sys.services
           WHERE name = 'UsageCollectorService')
BEGIN
    DROP SERVICE UsageCollectorService ;
END ;
GO

IF OBJECT_ID('[dbo].[UsageCollectorServiceQueue]') IS NOT NULL AND
   EXISTS(SELECT *
          FROM sys.objects
          WHERE object_id = OBJECT_ID('[dbo].[UsageCollectorServiceQueue]')
            AND type = 'SQ')
BEGIN
    DROP QUEUE [dbo].[UsageCollectorServiceQueue] ;
END ;
GO

IF EXISTS (SELECT *
           FROM sys.services
           WHERE name = 'ParserService')
BEGIN
    DROP SERVICE ParserService ;
END ;
GO

IF OBJECT_ID('[dbo].[ParserServiceQueue]') IS NOT NULL AND
   EXISTS(SELECT *
          FROM sys.objects
          WHERE object_id = OBJECT_ID('[dbo].[ParserServiceQueue]')
            AND type = 'SQ')
BEGIN
    DROP QUEUE [dbo].[ParserServiceQueue] ;
END ;
GO

IF EXISTS (SELECT *
           FROM sys.services
           WHERE name = 'ErrorService')
BEGIN
    DROP SERVICE ErrorService ;
END ;
GO

IF OBJECT_ID('[dbo].[ErrorServiceQueue]') IS NOT NULL AND
   EXISTS(SELECT *
          FROM sys.objects
          WHERE object_id = OBJECT_ID('[dbo].[ErrorServiceQueue]')
            AND type = 'SQ')
BEGIN
    DROP QUEUE [dbo].[ErrorServiceQueue] ;
END ;
GO

IF EXISTS (SELECT *
           FROM sys.service_contracts
           WHERE name = 'ServiceBusTransportMessageContract')
BEGIN
    DROP CONTRACT ServiceBusTransportMessageContract ;
END ;
GO

IF EXISTS (SELECT *
           FROM sys.service_message_types
           WHERE name = 'ServiceBusTransportMessage')
BEGIN
    DROP MESSAGE TYPE ServiceBusTransportMessage ;
END ;
GO

--------------------------------------------------------------------
-- Create objects for the sample.
--------------------------------------------------------------------

CREATE MESSAGE TYPE ServiceBusTransportMessage
    VALIDATION = NONE ;
GO

CREATE CONTRACT ServiceBusTransportMessageContract
    ( ServiceBusTransportMessage SENT BY ANY);
GO

-- Services

--CREATE QUEUE [dbo].[UsageCollectorServiceQueue] WITH
--	POISON_MESSAGE_HANDLING ( STATUS = OFF );
CREATE QUEUE [dbo].[UsageCollectorServiceQueue];
GO

CREATE SERVICE UsageCollectorService
    ON QUEUE [dbo].[UsageCollectorServiceQueue]
    (ServiceBusTransportMessageContract);
GO

--CREATE QUEUE [dbo].[ParserServiceQueue] WITH
--	POISON_MESSAGE_HANDLING ( STATUS = OFF );
CREATE QUEUE [dbo].[ParserServiceQueue];
GO

CREATE SERVICE ParserService
    ON QUEUE [dbo].[ParserServiceQueue]
    (ServiceBusTransportMessageContract);
GO

--CREATE QUEUE [dbo].[ErrorServiceQueue] WITH
--	POISON_MESSAGE_HANDLING ( STATUS = OFF );
CREATE QUEUE [dbo].[ErrorServiceQueue];
GO

CREATE SERVICE ErrorService
    ON QUEUE [dbo].[ErrorServiceQueue]
    (ServiceBusTransportMessageContract);
GO
