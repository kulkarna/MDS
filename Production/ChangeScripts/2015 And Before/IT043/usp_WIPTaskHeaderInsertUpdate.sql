USE [Libertypower]
GO

/****** Object:  StoredProcedure [dbo].[usp_WIPTaskHeaderInsertUpdate]    Script Date: 08/13/2012 19:07:01 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Al Tafur
-- Create date: 2012-07-11
-- Description:	Inserts a record header for a given contract
-- =============================================

CREATE PROCEDURE [dbo].[usp_WIPTaskHeaderInsertUpdate] 
(
	@WIPTaskHeaderId	int = 0,
	@ContractId		        int,  -- ITEM NUMBER HAS TO MATCH THE ITEM TYPE FOR THE START TRANSACTION
	@ContractTypeId		    int,
	@WorkflowId		    int,
    @CreatedBy			nvarchar(50) = null,
    @DateCreated		datetime = null,
    @UpdatedBy			nvarchar(50) = null,
    @DateUpdated		datetime = null
)
AS
BEGIN
	
	SET NOCOUNT ON;
	
	IF (@WIPTaskHeaderId = 0)
	BEGIN
		INSERT INTO [LibertyPower].[dbo].[WIPTaskHeader]
				   ([ContractTypeId]
				   ,[ContractId]
				   ,[WorkflowId]
				   ,[CreatedBy]
				   ,[DateCreated]
				   ,[UpdatedBy]
				   ,[DateUpdated])
			 VALUES
				   (@ContractTypeId
				   ,@ContractId
				   ,@WorkflowId
				   ,@CreatedBy
				   ,ISNULL(@DateCreated,CURRENT_TIMESTAMP)
				   ,@UpdatedBy
				   ,@DateUpdated)
		   
		RETURN @@IDENTITY
	END
	ELSE
	BEGIN
		UPDATE [LibertyPower].[dbo].[WIPTaskHeader]
		   SET [ContractTypeId] = @ContractTypeId
			  ,[ContractId] = @ContractId
			  ,[WorkflowId] = @WorkflowId
			  ,[UpdatedBy] = @UpdatedBy
			  ,[DateUpdated] =  ISNULL(@DateUpdated,CURRENT_TIMESTAMP)
		 WHERE WIPTaskHeaderId = @WIPTaskHeaderId

	END
		    
END

GO


