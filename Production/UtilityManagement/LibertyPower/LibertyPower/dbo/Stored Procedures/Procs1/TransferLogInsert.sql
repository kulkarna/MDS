

CREATE PROCEDURE [dbo].[TransferLogInsert]
	-- Add the parameters for the stored procedure here
	@AccountID int,
	@TransferTopicID int,
	@TransferDispositionID int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	INSERT INTO [LibertyPower].[dbo].[TransferLog]
           ([AccountID]
           ,[TransferTopicID]
           ,[TransferDispositionID])
     VALUES
           (@AccountID
           ,@TransferTopicID
           ,@TransferDispositionID)
     
     DECLARE @Topic VARCHAR(50)
     SELECT @Topic = [description] FROM TransferTopic WHERE TransferTopicID = @TransferTopicID
     DECLARE @Disposition VARCHAR(50)
     SELECT @Disposition = [description] FROM TransferDisposition WHERE TransferDispositionID = @TransferDispositionID
          
     -- Insert comment for account
     INSERT INTO [lp_account].[dbo].[account_comments]
           ([account_id]
           ,[date_comment]
           ,[process_id]
           ,[comment]
           ,[username]
           ,[chgstamp])
     SELECT AccountIDLegacy
		, getdate()
		, 'ACCOUNT'
		, comment = 'Customer call was transferred to the sales channel in regards to a [' + @Topic + '].  Result was [' + @Disposition + ']'
		, 'SYSTEM'
		, 0
     FROM LibertyPower..Account (nolock)
     WHERE AccountID = @AccountID
     
     --Returns the date/time the entry was created 
     SELECT GETDATE()
     
END

