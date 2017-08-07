
-- =============================================
-- Author:	Sofia Melo
-- Create date: 2010-07-26
-- Description:	Create the procedure to insert into LetterQueue
-- =============================================
CREATE PROCEDURE [dbo].[usp_LetterQueueInsert]
	
			@LetterStatus varchar(20)
           ,@ContractNumber varchar(12)
           ,@AccountID int
           ,@DocumentTypeID int
           ,@ScheduledDate datetime
           ,@PrintDate datetime
           ,@Username varchar(50)
AS
	
BEGIN
	SET NOCOUNT ON;
	
	-- Emergency solution to make sure duplicate TNL letters don't get printed.
	IF NOT EXISTS (select * from LetterQueue where AccountID = @AccountID and DocumentTypeID = @DocumentTypeID)
	
    INSERT INTO [LibertyPower].[dbo].[LetterQueue]
           ([Status]
           ,[ContractNumber]
           ,[AccountID]
           ,[DocumentTypeID]
           ,[DateCreated]
           ,[ScheduledDate]
           ,[PrintDate]
           ,[Username])
     VALUES
           (@LetterStatus
           ,@ContractNumber
           ,@AccountID
           ,@DocumentTypeID
           ,GETDATE()
           ,@ScheduledDate
           ,@PrintDate
           ,@Username)
	
	/*
	*/
	SET NOCOUNT OFF;
END



GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'LetterQueue', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_LetterQueueInsert';

