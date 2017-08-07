USE [Integration]
GO

DECLARE @RC int

DECLARE @blockedTransCount int = 1
DECLARE @fromDate datetime
DECLARE @toDate datetime
DECLARE @skipReason varchar(100)='PBI 78169:Ignored due to Clean up rules as provided by MC'

-- TODO: Set parameter values here.

EXECUTE @RC = [dbo].[usp_IgnoreBockedEDITransactions]    
   @blockedTransCount
  ,@fromDate
  ,@toDate
  ,@skipReason
GO


