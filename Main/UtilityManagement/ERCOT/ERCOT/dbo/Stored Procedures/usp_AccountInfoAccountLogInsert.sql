
/******************************  usp_AccountInfoAccountLogInsert *********************************/
Create Procedure dbo.usp_AccountInfoAccountLogInsert
	@FileLogID int,
	@Information varchar(500)

AS

BEGIN

INSERT INTO [ERCOT].[dbo].[AccountInfoAccountLog]
           ([FileLogID]
           ,[Information]
           ,[TimeInserted])
     VALUES(
			@FileLogID,
			@Information,
			GETDATE())
			 
END

