
/******************************  usp_FileLogInsert *********************************/
Create Procedure dbo.usp_AccountInfoFileLogInsert
	@GUID varchar(100),
	@ZipfileName varchar(200),
	@FileName varchar(200),
	@Status int,
	@Information varchar(500),
	@TimeInserted DateTime

AS

BEGIN

INSERT INTO [ERCOT].[dbo].[AccountInfoFileLog]
           ([GUID]
           ,[ZipFileName]
           ,[FileName]
           ,[Status]
           ,[Information]
           ,[TimeInserted])
     VALUES(
			@GUID,
			@ZipfileName,
			@FileName,
			@Status,
			@Information,
			@TimeInserted)
			
Select @@IDENTITY
 
END

