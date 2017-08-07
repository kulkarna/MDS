
-- =============================================
-- Author:		Isabelle Tamanini
-- Create date: 2012-06-11
-- Description:	Inserts or updates workflows
-- =============================================

CREATE PROCEDURE [dbo].[usp_WorkflowInsertUpdate] 
(
	@WorkflowID         int = 0,
	@Name			    nvarchar(25),
	@Description		nvarchar(50),
    @IsActive			bit,
    @Version			nchar(5),
    @IsRevisionOfRecord bit,
    @CreatedBy			nvarchar(50) = null,
    @DateCreated		datetime = null,
    @UpdatedBy			nvarchar(50),
    @DateUpdated		datetime
)
AS
BEGIN
	
	SET NOCOUNT ON;
	
	IF (@WorkFlowID = 0)
	BEGIN
		DECLARE @p_Version NCHAR(5)
		
		SELECT @p_Version = ISNULL((CONVERT(DECIMAL(3,1), max([Version]))+0.1), 1.0)
        FROM [LibertyPower].[dbo].[Workflow]
        WHERE [WorkflowName] = @Name
		
		INSERT INTO [LibertyPower].[dbo].[Workflow]
			   ([WorkflowName]
			   ,[WorkflowDescription]
			   ,[IsActive]
			   ,[Version]
			   ,[IsRevisionOfRecord]
			   ,[CreatedBy]
			   ,[DateCreated]
			   ,[UpdatedBy]
			   ,[DateUpdated])
		 VALUES
			   (@Name
			   ,@Description
			   ,@IsActive
			   ,@p_Version
			   ,@IsRevisionOfRecord
			   ,@CreatedBy
			   ,@DateCreated
			   ,@UpdatedBy
			   ,@DateUpdated)
			   
		SELECT @@IDENTITY
	END
	ELSE
	BEGIN
		IF(@IsRevisionOfRecord = 1)
		BEGIN
		   UPDATE [LibertyPower].[dbo].[Workflow]
		      SET [IsRevisionOfRecord] = 0
			     ,[UpdatedBy] = @UpdatedBy
			     ,[DateUpdated] = @DateUpdated
		    WHERE WorkflowName = @Name
		      AND [Version] <> @Version
		END
		
		UPDATE [LibertyPower].[dbo].[Workflow]
		   SET [WorkflowName] = @Name
			  ,[WorkflowDescription] = @Description
			  ,[IsActive] = @IsActive
			  ,[Version] = @Version
			  ,[IsRevisionOfRecord] = @IsRevisionOfRecord
			  ,[UpdatedBy] = @UpdatedBy
			  ,[DateUpdated] = @DateUpdated
		 WHERE WorkflowID = @WorkflowID
	END
		
    
END

----------------------------------------------------------------------------------------------------------


