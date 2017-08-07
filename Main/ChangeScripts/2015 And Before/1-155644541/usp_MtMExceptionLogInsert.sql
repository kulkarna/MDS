USE [lp_mtm]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_MtMExceptionLogInsert]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[usp_MtMExceptionLogInsert]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/* **********************************************************************************************
 *	Author:		gmangaroo																		*
 *	Created:	7/19/2013																		*
 *	Descp:		Insert exception																*
 *	Modified:																					*
 ********************************************************************************************** */
CREATE PROCEDURE [dbo].[usp_MtMExceptionLogInsert]
(
@Description varchar(1500) 
, @Dump varchar(max) = null 
, @Type int = 0 
, @Severity int = 0 
, @AccountID int  = 0 
, @Source varchar(max) = null 
, @BatchNumber varchar(max) = null 
, @Internal bit = 0 
, @AdditionalInfo varchar(max) = null 
, @ExpirationDate datetime = null 
, @UserID int
) 
AS 
BEGIN 
SET	NOCOUNT ON
	INSERT INTO [lp_mtm].[dbo].[MtMExceptionLog]
           ([ExceptionDescription]
           ,[ExceptionDump]
           ,[ExceptionTypeId]
           ,[Severity]
           ,[AccountId]
           ,[Source]
           ,[BatchNumber]
           ,[Internal]
           ,[AdditionalInfo]
           ,[ExpirationDate]
           ,[DateCreated]
           ,[CreatedBy]
)

     VALUES
           (@Description
           ,@Dump
           ,@Type
           ,@Severity
           ,@AccountID
           ,@Source
           ,@BatchNumber
           ,@Internal
           ,@AdditionalInfo
           ,@ExpirationDate
           ,GETDATE()
           ,@UserID
           )
		   END 
SET	NOCOUNT OFF
GO