USE [LibertyPower]
GO

/****** Object:  StoredProcedure [dbo].[usp_TaskStatusSelect]    Script Date: 08/20/2012 17:01:08 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_TaskStatusSelect]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_TaskStatusSelect]
GO

/****** Object:  StoredProcedure [dbo].[usp_TaskTypeDelete]    Script Date: 08/20/2012 17:01:08 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_TaskTypeDelete]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_TaskTypeDelete]
GO

/****** Object:  StoredProcedure [dbo].[usp_TaskTypeInsertUpdate]    Script Date: 08/20/2012 17:01:08 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_TaskTypeInsertUpdate]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_TaskTypeInsertUpdate]
GO

/****** Object:  StoredProcedure [dbo].[usp_TaskTypeSelect]    Script Date: 08/20/2012 17:01:08 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_TaskTypeSelect]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_TaskTypeSelect]
GO

/****** Object:  StoredProcedure [dbo].[usp_WorkflowAssignmentDelete]    Script Date: 08/20/2012 17:01:08 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_WorkflowAssignmentDelete]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_WorkflowAssignmentDelete]
GO

/****** Object:  StoredProcedure [dbo].[usp_WorkflowAssignmentInsertUpdate]    Script Date: 08/20/2012 17:01:08 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_WorkflowAssignmentInsertUpdate]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_WorkflowAssignmentInsertUpdate]
GO

/****** Object:  StoredProcedure [dbo].[usp_WorkflowAssignmentsSelect]    Script Date: 08/20/2012 17:01:08 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_WorkflowAssignmentsSelect]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_WorkflowAssignmentsSelect]
GO

/****** Object:  StoredProcedure [dbo].[usp_WorkflowDelete]    Script Date: 08/20/2012 17:01:08 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_WorkflowDelete]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_WorkflowDelete]
GO

/****** Object:  StoredProcedure [dbo].[usp_WorkflowInsertUpdate]    Script Date: 08/20/2012 17:01:08 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_WorkflowInsertUpdate]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_WorkflowInsertUpdate]
GO

/****** Object:  StoredProcedure [dbo].[usp_WorkflowPathLogicDelete]    Script Date: 08/20/2012 17:01:08 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_WorkflowPathLogicDelete]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_WorkflowPathLogicDelete]
GO

/****** Object:  StoredProcedure [dbo].[usp_WorkflowPathLogicInsertUpdate]    Script Date: 08/20/2012 17:01:08 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_WorkflowPathLogicInsertUpdate]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_WorkflowPathLogicInsertUpdate]
GO

/****** Object:  StoredProcedure [dbo].[usp_WorkflowPathLogicSelect]    Script Date: 08/20/2012 17:01:08 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_WorkflowPathLogicSelect]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_WorkflowPathLogicSelect]
GO

/****** Object:  StoredProcedure [dbo].[usp_WorkflowSelect]    Script Date: 08/20/2012 17:01:08 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_WorkflowSelect]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_WorkflowSelect]
GO

/****** Object:  StoredProcedure [dbo].[usp_WorkflowStartItem]    Script Date: 08/20/2012 17:01:08 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_WorkflowStartItem]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_WorkflowStartItem]
GO

/****** Object:  StoredProcedure [dbo].[usp_WorkflowTaskDelete]    Script Date: 08/20/2012 17:01:08 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_WorkflowTaskDelete]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_WorkflowTaskDelete]
GO

/****** Object:  StoredProcedure [dbo].[usp_WorkflowTaskHasLogicCheck]    Script Date: 08/20/2012 17:01:08 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_WorkflowTaskHasLogicCheck]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_WorkflowTaskHasLogicCheck]
GO

/****** Object:  StoredProcedure [dbo].[usp_WorkflowTaskInsertUpdate]    Script Date: 08/20/2012 17:01:08 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_WorkflowTaskInsertUpdate]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_WorkflowTaskInsertUpdate]
GO

/****** Object:  StoredProcedure [dbo].[usp_WorkflowTaskLogicDelete]    Script Date: 08/20/2012 17:01:08 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_WorkflowTaskLogicDelete]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_WorkflowTaskLogicDelete]
GO

/****** Object:  StoredProcedure [dbo].[usp_WorkflowTaskLogicInsertUpdate]    Script Date: 08/20/2012 17:01:08 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_WorkflowTaskLogicInsertUpdate]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_WorkflowTaskLogicInsertUpdate]
GO

/****** Object:  StoredProcedure [dbo].[usp_WorkflowTaskLogicSelect]    Script Date: 08/20/2012 17:01:08 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_WorkflowTaskLogicSelect]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_WorkflowTaskLogicSelect]
GO

/****** Object:  StoredProcedure [dbo].[usp_WorkflowTaskSelect]    Script Date: 08/20/2012 17:01:08 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_WorkflowTaskSelect]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_WorkflowTaskSelect]
GO

USE [LibertyPower]
GO

/****** Object:  StoredProcedure [dbo].[usp_TaskStatusSelect]    Script Date: 08/20/2012 17:01:08 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Isabelle Tamanini
-- Create date: 2012-06-22
-- Description:	Returns the task statuses
-- =============================================

CREATE PROCEDURE [dbo].[usp_TaskStatusSelect] 
(
	@IsActive int = 1
)
AS
BEGIN
	
	SET NOCOUNT ON;

    SELECT [TaskStatusID]
		  ,[StatusName]
		  ,[IsActive]
		  ,[CreatedBy]
		  ,[DateCreated]
		  ,[UpdatedBy]
		  ,[DateUpdated]
	FROM [LibertyPower].[dbo].[TaskStatus]
	WHERE (IsDeleted is null OR IsDeleted = 0)
	  AND (@IsActive is null OR IsActive = @IsActive)
    
END

GO

/****** Object:  StoredProcedure [dbo].[usp_TaskTypeDelete]    Script Date: 08/20/2012 17:01:08 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Isabelle Tamanini
-- Create date: 2012-06-15
-- Description:	Sets the flag IsDeleted for a task type
-- =============================================

CREATE PROCEDURE [dbo].[usp_TaskTypeDelete] 
(
	@TaskTypeID         int,
	@IsDeleted			bit,
    @UpdatedBy			nvarchar(50),
    @DateUpdated		datetime
)
AS
BEGIN
	
	SET NOCOUNT ON;

	UPDATE [LibertyPower].[dbo].[TaskType]
	   SET [IsDeleted] = @IsDeleted
		  ,[UpdatedBy] = @UpdatedBy
		  ,[DateUpdated] = @DateUpdated
	 WHERE TaskTypeID = @TaskTypeID
		
END

GO

/****** Object:  StoredProcedure [dbo].[usp_TaskTypeInsertUpdate]    Script Date: 08/20/2012 17:01:08 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Isabelle Tamanini
-- Create date: 2012-06-15
-- Description:	Inserts or updates task types
-- =============================================

CREATE PROCEDURE [dbo].[usp_TaskTypeInsertUpdate] 
(
	@TaskTypeID         int = 0,
	@TaskName			nvarchar(25),
	@IsActive			bit,
    @CreatedBy			nvarchar(50) = null,
    @DateCreated		datetime = null,
    @UpdatedBy			nvarchar(50),
    @DateUpdated		datetime
)
AS
BEGIN
	
	SET NOCOUNT ON;
	
	IF (@TaskTypeID = 0)
	BEGIN
		INSERT INTO [LibertyPower].[dbo].[TaskType]
			   ([TaskName]
			   ,[IsActive]
			   ,[IsDeleted]
			   ,[CreatedBy]
			   ,[DateCreated]
			   ,[UpdatedBy]
			   ,[DateUpdated])
		 VALUES
			   (@TaskName
			   ,@IsActive
			   ,0
			   ,@CreatedBy
			   ,@DateCreated
			   ,@UpdatedBy
			   ,@DateUpdated)
			   
		SELECT @@IDENTITY
	END
	ELSE
	BEGIN
		UPDATE [LibertyPower].[dbo].[TaskType]
		   SET [TaskName] = @TaskName
			  ,[IsActive] = @IsActive
			  ,[UpdatedBy] = @UpdatedBy
			  ,[DateUpdated] = @DateUpdated
		 WHERE TaskTypeID = @TaskTypeID
	END
		
    
END

GO

/****** Object:  StoredProcedure [dbo].[usp_TaskTypeSelect]    Script Date: 08/20/2012 17:01:08 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




-- =============================================
-- Author:		Isabelle Tamanini
-- Create date: 2012-06-13
-- Description:	Returns the task types
-- =============================================

CREATE PROCEDURE [dbo].[usp_TaskTypeSelect] 
(
	@IsActive int = 1
)
AS
BEGIN
	
	SET NOCOUNT ON;

    SELECT [TaskTypeID]
		  ,[TaskName]
		  ,[IsActive]
		  ,[CreatedBy]
		  ,[DateCreated]
		  ,[UpdatedBy]
		  ,[DateUpdated]
	FROM [LibertyPower].[dbo].[TaskType] TT
	WHERE (@IsActive is null OR TT.IsActive = @IsActive)
	  AND (IsDeleted is null OR IsDeleted = 0)
    
END



GO

/****** Object:  StoredProcedure [dbo].[usp_WorkflowAssignmentDelete]    Script Date: 08/20/2012 17:01:08 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		Ryan Russon
-- Create date: 2012-08-10
-- Description:	Deletes a workflow assignment
-- =============================================
CREATE PROCEDURE [dbo].[usp_WorkflowAssignmentDelete] 
(
	@WorkflowAssignmentId	int
)

AS

BEGIN
	
	SET NOCOUNT ON;
	DELETE FROM [LibertyPower]..[WorkflowAssignment]
	WHERE WorkflowAssignmentID = @WorkflowAssignmentID
	
END



GO

/****** Object:  StoredProcedure [dbo].[usp_WorkflowAssignmentInsertUpdate]    Script Date: 08/20/2012 17:01:08 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



/*				NOTES:

Should we have some way for the user to move the workflow assignments from the previous version?
Yes, but only if the workflow version is not in use at all (see WIPTask tables).
A workflow assignment is considered locked once a contract is using it.  
We will be able to tell that condition by querying the WHIPTASKHEADER table.  
When a contract is in process, it will have its header record in this table.

Regarding conflicts, if the workflow has not been used in any transactions (see above), then any reassignments should not generate any conflicts.
As soon as a contract is started based on that assignment, it will follow the process sequence


--> Have user remove assignment on old WorkflowID before reassignment.  --Should be easy with master list of assignments.
*/



-- =============================================
-- Author:		Ryan Russon
-- Create date: 2012-08-10
-- Description:	Inserts or updates a workflow assignment, just like EF does effortlessly
-- =============================================
CREATE PROCEDURE [dbo].[usp_WorkflowAssignmentInsertUpdate] 
(
	@WorkflowAssignmentId	int	= NULL,		--INSERT if this value is NULL
	@WorkflowId				int,
	@MarketId				int = NULL,
	@UtilityId				int = NULL,
	@ContractTypeId			int,
	@ContractDealTypeId		int,
	@ContractTemplateTypeId	int,
	--@DateCreated			datetime = NULL,
	--@DateUpdated			datetime = NULL,
	@CreatedBy				nvarchar(100) = NULL,
	@UpdatedBy				nvarchar(100) = NULL
)

AS

BEGIN
	
	SET NOCOUNT ON;
	
	IF (@WorkflowAssignmentId IS NULL)
	BEGIN
		INSERT INTO [LibertyPower]..[WorkflowAssignment] (
			[WorkflowId],
			[MarketId],
			[UtilityId],
			[ContractTypeId],
			[ContractDealTypeId],
			[ContractTemplateTypeId],
			[DateCreated],
			[DateUpdated],
			[CreatedBy]
			--[UpdatedBy]
		 ) VALUES (
			@WorkflowId,
			@MarketId,
			@UtilityId,
			@ContractTypeId,
			@ContractDealTypeId,
			@ContractTemplateTypeId,
			GETDATE(),
			GETDATE(),
			@CreatedBy
			--@UpdatedBy
)			   
		SELECT @@IDENTITY
	END
	
	ELSE
	
	BEGIN
		UPDATE [LibertyPower]..[WorkflowAssignment]
		SET 
			[WorkflowId] = @WorkflowId,
			[MarketId] = @MarketId,
			[UtilityId] = @UtilityId,
			[ContractTypeId] = @ContractTypeId,
			[ContractDealTypeId] = @ContractDealTypeId,
			[ContractTemplateTypeId] = @ContractTemplateTypeId,
			--[DateCreated] = @DateCreated,
			[DateUpdated] = GETDATE(),
			--[CreatedBy] = @CreatedBy,
			[UpdatedBy] = @UpdatedBy
		WHERE WorkflowAssignmentID = @WorkflowAssignmentID
		
		SELECT @WorkflowAssignmentId	--Return original ID to be updated, to keep return of stored proc consistent
	END

END



GO

/****** Object:  StoredProcedure [dbo].[usp_WorkflowAssignmentsSelect]    Script Date: 08/23/2012 16:29:50 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		Isabelle Tamanini
-- Create date: 2012-06-11
-- Description:	Returns the workflow assignments by workflow id
-- Updated:		Ryan Russon [08-07-2012] - Add all columns from WorkflowAssignment for use in Workflow Assignment editor
-- Usage:		EXEC usp_WorkflowAssignmentsSelect @WorkflowID=2
-- =============================================
ALTER PROCEDURE [dbo].[usp_WorkflowAssignmentsSelect](
	@WorkflowId		int = NULL
)

AS

BEGIN

	SET NOCOUNT ON;

	SELECT
		WA.WorkflowAssignmentId,
		W.WorkflowId,
		W.WorkflowName,
		W.WorkflowDescription,
		--W.IsActive AS IsActiveWorkflow,
		W.IsActive,
		W.[Version],
		W.IsRevisionOfRecord,
		WA.MarketId,
		IsNull(M.RetailMktDescp, 'ALL')			AS MarketName,
		WA.UtilityId,
		IsNull(U.ShortName, 'ALL')				AS UtilityName,
		WA.ContractTypeId,
		WA.ContractDealTypeId,
		WA.ContractTemplateTypeId,
		WA.CreatedBy,
		WA.DateCreated,
		WA.UpdatedBy,
		WA.DateUpdated
	FROM
		LibertyPower..Workflow					W WITH (NOLOCK)
		JOIN LibertyPower..WorkflowAssignment	WA WITH (NOLOCK)
			ON W.WorkflowID = WA.WorkflowID
		LEFT JOIN LibertyPower..Market			M WITH (NOLOCK)
			ON M.ID = WA.MarketId
		LEFT JOIN LibertyPower..Utility			U WITH (NOLOCK)
			ON U.ID = WA.UtilityId
	WHERE (@WorkflowId IS NULL		OR		W.WorkflowId = @WorkflowId)

END


GO


/****** Object:  StoredProcedure [dbo].[usp_WorkflowDelete]    Script Date: 08/20/2012 17:01:08 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Isabelle Tamanini
-- Create date: 2012-06-20
-- Description:	Sets the flag IsDeleted for a workflow
-- =============================================

CREATE PROCEDURE [dbo].[usp_WorkflowDelete] 
(
	@WorkflowID         int,
	@IsDeleted			bit,
    @UpdatedBy			nvarchar(50),
    @DateUpdated		datetime
)
AS
BEGIN
	
	SET NOCOUNT ON;
	
	UPDATE [LibertyPower].[dbo].[Workflow]
	   SET [IsDeleted] = @IsDeleted
		  ,[UpdatedBy] = @UpdatedBy
		  ,[DateUpdated] = @DateUpdated
	 WHERE WorkflowID = @WorkflowID
		
    
END

GO

/****** Object:  StoredProcedure [dbo].[usp_WorkflowInsertUpdate]    Script Date: 08/20/2012 17:01:08 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


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

GO

/****** Object:  StoredProcedure [dbo].[usp_WorkflowPathLogicDelete]    Script Date: 08/20/2012 17:01:08 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Isabelle Tamanini
-- Create date: 2012-06-22
-- Description:	Sets the flag IsDeleted for a workflow path logic
-- =============================================

CREATE PROCEDURE [dbo].[usp_WorkflowPathLogicDelete] 
(
	@WorkflowPathLogicID     int,
	@IsDeleted	   		     bit,
    @UpdatedBy			     nvarchar(50),
    @DateUpdated		     datetime
)
AS
BEGIN
	
	SET NOCOUNT ON;
	
	UPDATE [LibertyPower].[dbo].[WorkflowPathLogic]
	   SET [IsDeleted] = @IsDeleted
		  ,[UpdatedBy] = @UpdatedBy
		  ,[DateUpdated] = @DateUpdated
	 WHERE WorkflowPathLogicID = @WorkflowPathLogicID
		
    
END

GO

/****** Object:  StoredProcedure [dbo].[usp_WorkflowPathLogicInsertUpdate]    Script Date: 08/20/2012 17:01:08 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Isabelle Tamanini
-- Create date: 2012-06-22
-- Description:	Inserts or updates workflow path logics
-- =============================================

CREATE PROCEDURE [dbo].[usp_WorkflowPathLogicInsertUpdate] 
(
	@WorkflowPathLogicID    int = 0,
	@WorkflowTaskID         int,
	@WorkflowTaskIDRequired int,
	@ConditionTaskStatusID  int,
    @CreatedBy			nvarchar(50) = null,
    @DateCreated		datetime = null,
    @UpdatedBy			nvarchar(50),
    @DateUpdated		datetime
)
AS
BEGIN
	
	SET NOCOUNT ON;
	
	IF (@WorkflowPathLogicID = 0)
	BEGIN
		INSERT INTO [LibertyPower].[dbo].[WorkflowPathLogic]
				   ([WorkflowTaskID]
				   ,[WorkflowTaskIDRequired]
				   ,[ConditionTaskStatusID]
				   ,[CreatedBy]
				   ,[DateCreated]
				   ,[UpdatedBy]
				   ,[DateUpdated]
				   ,[IsDeleted])
			 VALUES
				   (@WorkflowTaskID
				   ,@WorkflowTaskIDRequired
				   ,@ConditionTaskStatusID
				   ,@CreatedBy
				   ,@DateCreated
				   ,@UpdatedBy
				   ,@DateUpdated
				   ,0)
			   
		SELECT @@IDENTITY
	END
	ELSE
	BEGIN
		UPDATE [LibertyPower].[dbo].[WorkflowPathLogic]
		   SET [WorkflowTaskID] = @WorkflowTaskID
			  ,[WorkflowTaskIDRequired] = @WorkflowTaskIDRequired
			  ,[ConditionTaskStatusID] = @ConditionTaskStatusID
			  ,[UpdatedBy] = @UpdatedBy
			  ,[DateUpdated] = @DateUpdated
		WHERE WorkflowPathLogicID = @WorkflowPathLogicID
	END
		
    
END

GO

/****** Object:  StoredProcedure [dbo].[usp_WorkflowPathLogicSelect]    Script Date: 08/20/2012 17:01:08 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Isabelle Tamanini
-- Create date: 2012-06-22
-- Description:	Returns the path logics for a task
-- =============================================

CREATE PROCEDURE [dbo].[usp_WorkflowPathLogicSelect] 
(
	@WorkflowTaskID int
)
AS
BEGIN
	
	SET NOCOUNT ON;

    SELECT WPL.[WorkflowPathLogicID]
		  ,WPL.[WorkflowTaskID]
		  ,WPL.[WorkflowTaskIDRequired]
		  ,WPL.[ConditionTaskStatusID]
		  ,WPL.[CreatedBy]
		  ,WPL.[DateCreated]
		  ,WPL.[UpdatedBy]
		  ,WPL.[DateUpdated]
		  ,TS.[StatusName]
		  ,TS.[IsActive] AS IsActiveTaskStatus
	FROM [LibertyPower].[dbo].[WorkflowPathLogic] WPL (NOLOCK)
	JOIN [LibertyPower].[dbo].[TaskStatus] TS         (NOLOCK) ON WPL.ConditionTaskStatusID = TS.TaskStatusID
	WHERE (WPL.IsDeleted is null OR WPL.IsDeleted = 0)
	  AND WPL.WorkflowTaskID = @WorkflowTaskID
    
END

GO

/****** Object:  StoredProcedure [dbo].[usp_WorkflowSelect]    Script Date: 08/20/2012 17:01:08 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Isabelle Tamanini
-- Create date: 2012-06-11
-- Description:	Returns the workflow by id
-- =============================================

CREATE PROCEDURE [dbo].[usp_WorkflowSelect] 
(
	@WorkflowID int = null
)
AS
BEGIN
	
	SET NOCOUNT ON;

    SELECT W.[WorkflowID]
		  ,W.[WorkflowName]
		  ,W.[WorkflowDescription]
		  ,W.[IsActive] AS IsActiveWorkflow
		  ,W.[Version]
		  ,W.[IsRevisionOfRecord]
	FROM [LibertyPower].[dbo].[Workflow] W (NOLOCK)
	WHERE (@WorkflowID is null OR W.WorkflowID = @WorkflowID)
	  AND (IsDeleted is null OR IsDeleted = 0)
    
END

GO

/****** Object:  StoredProcedure [dbo].[usp_WorkflowStartItem]    Script Date: 08/20/2012 17:01:08 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




-- =============================================
-- Author:		Al Tafur
-- Create date: 2012-07-11
-- Description:	Master proc to perform the start transaction for a given item
-- Test:  exec [usp_WorkflowStartItem] '123456',1,'libertypower\atafur'
-- =============================================

CREATE PROCEDURE  [dbo].[usp_WorkflowStartItem] 
(
	@pItemId		        int,  -- ITEM NUMBER HAS TO MATCH THE ITEM TYPE FOR THE START TRANSACTION
	@ContractTypeID		    int,
    @pCreatedBy			nvarchar(50)	=	null,
    @pDateCreated		datetime		=	null,
    @pUpdatedBy			nvarchar(50)	=	null,
    @pDateUpdated		datetime		=	null
)
AS
BEGIN

/*DECLARE VARIABLES TO BE USED FOR THIS PROCESS*/	

DECLARE @WorkflowId INT
DECLARE @ItemTypeId INT

	SET NOCOUNT ON;
	
	/*FIND THE WORKFLOWID ASSIGNED FOR THE GIVEN ITEM*/
	SELECT  @WorkflowId = W.WorkflowId,
			@ItemTypeId = IT.ItemTypeId
	FROM	Libertypower..WorkflowAssignment W  (NOLOCK)
	JOIN    LibertyPower..ItemType           IT (NOLOCK) ON W.ContractDealTypeId = IT.ContractTypeId
	WHERE	IT.ContractTypeId = @ContractTypeID
	
	/* INSERT THE WIP HEADER RECORD */
	DECLARE	@TransactionDate datetime
	SET		@TransactionDate = CURRENT_TIMESTAMP

	DECLARE	@vWIPTaskHeaderId int

	EXEC	@vWIPTaskHeaderId = [dbo].[usp_WIPTaskHeaderInsertUpdate]
			@WIPTaskHeaderId	=	0,  -- 0 SINCE WE ARE ONLY MAKING AN INSERT
			@ItemId				=	@pItemId,
			@ItemTypeId			=	@ItemTypeId,
			@WorkflowId			=	@WorkflowId,
			@CreatedBy			=	@pCreatedBy,
			@DateCreated		=	@TransactionDate
	
	/* DETERMINE THE WORKFLOWTASKS FOR THE FOUND WORKFLOW */
	
	SELECT	wt.workflowid, wt.workflowtaskid
	INTO	#tmpWorkflowTasks 
	FROM	libertypower..workflowtask wt (nolock)
	JOIN	libertypower..tasktype t (nolock)
	ON		wt.tasktypeid = t.tasktypeid
	WHERE	workflowid = @WorkflowId
	AND		wt.IsDeleted = 0
	
	/* INSERT THE WORKFLOWTASKS IN THE WORK IN PROCESS TASK TABLE */
	
	DECLARE @tmpWorkflowTaskId INT
	
	DECLARE cursorTaskId cursor for
		SELECT workflowtaskid from #tmpWorkflowTasks
		
	OPEN cursorTaskId
	
	FETCH NEXT FROM cursorTaskId INTO @tmpWorkflowTaskId
	WHILE @@FETCH_STATUS = 0
	BEGIN
		
		DECLARE @wTaskStatusId INT
		-- START STEP ON HOLD STATUS
		SET @wTaskStatusId = 6
		IF NOT EXISTS (SELECT 1 
				       FROM LibertyPower..WorkflowPathLogic
				       WHERE WorkflowTaskId = @tmpWorkflowTaskId
				         AND ConditionTaskStatusId <> 2)
	    BEGIN
			SET @wTaskStatusId = 2 --PENDING
	    END
				       
		/* EXECUTE THE INSERT PROC WITH THE GIVEN PARAMS */
		EXEC	[dbo].[usp_WIPTaskInsertUpdate]
				@WIPTaskId = 0,
				@WIPTaskHeaderId = @vWIPTaskHeaderId,
				@WorkflowTaskId = @tmpWorkflowTaskId,
				@TaskStatusId = @wTaskStatusId,  
				@IsAvailable = 1,
				@CreatedBy = @pCreatedBy
	  
		FETCH NEXT FROM cursorTaskId INTO @tmpWorkflowTaskId
		
	END
	
	CLOSE cursorTaskId
	
	DEALLOCATE cursorTaskId
	
	UPDATE WIPT
	SET TaskStatusId = 2 --PENDING
	FROM LibertyPower..WIPTask WIPT
	WHERE WIPT.WIPTaskHeaderId = @vWIPTaskHeaderId
	  AND NOT EXISTS (SELECT 1 
					   FROM LibertyPower..WorkflowPathLogic
				       WHERE WorkflowTaskId = @tmpWorkflowTaskId
				         AND ConditionTaskStatusId <> 2)
	
END




GO

/****** Object:  StoredProcedure [dbo].[usp_WorkflowTaskDelete]    Script Date: 08/20/2012 17:01:08 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Isabelle Tamanini
-- Create date: 2012-06-11
-- Description:	Sets the flag IsDeleted for a workflow task
-- =============================================

CREATE PROCEDURE [dbo].[usp_WorkflowTaskDelete] 
(
	@WorkflowTaskID     int,
	@IsDeleted			bit,
    @UpdatedBy			nvarchar(50),
    @DateUpdated		datetime
)
AS
BEGIN
	
	SET NOCOUNT ON;
	
	UPDATE [LibertyPower].[dbo].[WorkflowTask]
	   SET [IsDeleted] = @IsDeleted
		  ,[UpdatedBy] = @UpdatedBy
		  ,[DateUpdated] = @DateUpdated
	 WHERE WorkflowTaskID = @WorkflowTaskID
		
    
END

GO

/****** Object:  StoredProcedure [dbo].[usp_WorkflowTaskHasLogicCheck]    Script Date: 08/20/2012 17:01:08 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




-- ==========================================================================================
-- Author:		Al Tafur
-- Create date: 2012-07-09
-- Description:	Checks if a specific workflowtask has logic assigned
-- test:  exec usp_workflowtaskhaslogiccheck 4
-- ==========================================================================================

CREATE PROCEDURE  [dbo].[usp_WorkflowTaskHasLogicCheck] 
(
	@WorkflowTaskID      int
)
AS
BEGIN
	
	SET NOCOUNT ON;
	
SELECT count(*)
  FROM [LibertyPower].[dbo].[WorkflowPathLogic]
  WHERE WorkflowTaskID = @WorkflowTaskID
	
    
END



GO

/****** Object:  StoredProcedure [dbo].[usp_WorkflowTaskInsertUpdate]    Script Date: 08/20/2012 17:01:08 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Isabelle Tamanini
-- Create date: 2012-06-11
-- Description:	Inserts or updates workflow tasks
-- =============================================

CREATE PROCEDURE [dbo].[usp_WorkflowTaskInsertUpdate] 
(
	@WorkflowID         int,
	@WorkflowTaskID     int = 0,
	@TaskSequence		int,
    @TaskTypeId int,
    @CreatedBy			nvarchar(50) = null,
    @DateCreated		datetime = null,
    @UpdatedBy			nvarchar(50),
    @DateUpdated		datetime
)
AS
BEGIN
	
	SET NOCOUNT ON;
	
	IF (@WorkflowTaskID = 0)
	BEGIN
		INSERT INTO [LibertyPower].[dbo].[WorkflowTask]
			   ([WorkflowID]
			   ,[TaskTypeID]
			   ,[TaskSequence]
			   ,[IsDeleted]
			   ,[CreatedBy]
			   ,[DateCreated]
			   ,[UpdatedBy]
			   ,[DateUpdated])
		 VALUES
			   (@WorkflowID
			   ,@TaskTypeId
			   ,@TaskSequence
			   ,0
			   ,@CreatedBy
			   ,@DateCreated
			   ,@UpdatedBy
			   ,@DateUpdated)
		
		SELECT @@IDENTITY
	END
	ELSE
	BEGIN
		UPDATE [LibertyPower].[dbo].[WorkflowTask]
		SET [TaskSequence] = @TaskSequence,
			[TaskTypeId] = @TaskTypeId,
			[UpdatedBy] = @UpdatedBy,
			[DateUpdated] = @DateUpdated
		WHERE WorkflowTaskID = @WorkflowTaskID
		AND WorkflowID = @WorkflowID
	END
		
    
END

GO

/****** Object:  StoredProcedure [dbo].[usp_WorkflowTaskLogicDelete]    Script Date: 08/20/2012 17:01:08 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Isabelle Tamanini
-- Create date: 2012-06-15
-- Description:	Sets the flag IsDeleted for a workflow
-- task logic
-- =============================================

CREATE PROCEDURE [dbo].[usp_WorkflowTaskLogicDelete] 
(
	@WorkflowTaskLogicID int,
	@IsDeleted			 bit,
    @UpdatedBy			 nvarchar(50),
    @DateUpdated		 datetime
)
AS
BEGIN
	
	SET NOCOUNT ON;

	UPDATE [LibertyPower].[dbo].[WorkflowTaskLogic]
	   SET [IsDeleted] = @IsDeleted
		  ,[UpdatedBy] = @UpdatedBy
		  ,[DateUpdated] = @DateUpdated
	 WHERE WorkflowTaskLogicID = @WorkflowTaskLogicID
		
END

GO

/****** Object:  StoredProcedure [dbo].[usp_WorkflowTaskLogicInsertUpdate]    Script Date: 08/20/2012 17:01:08 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Isabelle Tamanini
-- Create date: 2012-06-15
-- Description:	Inserts or updates workflow task logics
-- =============================================

CREATE PROCEDURE [dbo].[usp_WorkflowTaskLogicInsertUpdate] 
(
	@WorkflowTaskLogicID int = 0,
	@WorkflowTaskID      int,
	@LogicParam			 nvarchar(50),
    @LogicCondition		 int,
    @IsAutomated		 bit,
    @CreatedBy			 nvarchar(50) = null,
    @DateCreated		 datetime = null,
    @UpdatedBy			 nvarchar(50),
    @DateUpdated		 datetime
)
AS
BEGIN
	
	SET NOCOUNT ON;
	
	IF (@WorkFlowTaskLogicID = 0)
	BEGIN
		INSERT INTO [LibertyPower].[dbo].[WorkflowTaskLogic]
           ([WorkflowTaskID]
           ,[LogicParam]
           ,[LogicCondition]
           ,[IsAutomated]
           ,[IsDeleted]
           ,[CreatedBy]
           ,[DateCreated]
           ,[UpdatedBy]
           ,[DateUpdated])
		 VALUES
			   (@WorkflowTaskID
			   ,@LogicParam
			   ,@LogicCondition
			   ,@IsAutomated
			   ,0
			   ,@CreatedBy
			   ,@DateCreated
			   ,@UpdatedBy
			   ,@DateUpdated)
	           
		 SELECT @@IDENTITY
	END
	ELSE
	BEGIN
		UPDATE [LibertyPower].[dbo].[WorkflowTaskLogic]
		   SET [LogicParam] = @LogicParam
			  ,[LogicCondition] = @LogicCondition
			  ,[IsAutomated] = @IsAutomated
			  ,[CreatedBy] = @CreatedBy
			  ,[DateCreated] = @DateCreated
			  ,[UpdatedBy] = @UpdatedBy
			  ,[DateUpdated] = @DateUpdated
		WHERE WorkflowTaskLogicID = @WorkflowTaskLogicID
		  AND WorkflowTaskID = @WorkflowTaskID
	END
		
    
END

GO

/****** Object:  StoredProcedure [dbo].[usp_WorkflowTaskLogicSelect]    Script Date: 08/20/2012 17:01:08 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Isabelle Tamanini
-- Create date: 2012-06-15
-- Description:	Returns workflow task logics of a 
-- workflow task
-- =============================================

CREATE PROCEDURE [dbo].[usp_WorkflowTaskLogicSelect] 
(
	@WorkflowTaskLogicID int = null,
	@WorkflowTaskID      int
)
AS
BEGIN
	
	SET NOCOUNT ON;
	
	SELECT [WorkflowTaskLogicID]
		  ,[WorkflowTaskID]
		  ,[LogicParam]
		  ,[LogicCondition]
		  ,[IsAutomated]
		  ,[CreatedBy]
		  ,[DateCreated]
		  ,[UpdatedBy]
		  ,[DateUpdated]
	 FROM [LibertyPower].[dbo].[WorkflowTaskLogic]
	 WHERE WorkflowTaskID = @WorkflowTaskID
	   AND (@WorkflowTaskLogicID is null OR WorkflowTaskLogicID = @WorkflowTaskID) 
	   AND (IsDeleted is null OR IsDeleted = 0)
		
    
END

GO

/****** Object:  StoredProcedure [dbo].[usp_WorkflowTaskSelect]    Script Date: 08/20/2012 17:01:08 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Isabelle Tamanini
-- Create date: 2012-06-11
-- Description:	Returns the workflow tasks by workflow id
-- =============================================

CREATE PROCEDURE [dbo].[usp_WorkflowTaskSelect] 
(
	@WorkflowID		int = null,
	@WorkflowTaskID int = null
)
AS
BEGIN
	
	SET NOCOUNT ON;

    SELECT W.[WorkflowID]
		  ,W.[WorkflowName]
		  ,W.[WorkflowDescription]
		  ,W.[IsActive] AS IsActiveWorkflow
		  ,W.[Version]
		  ,W.[IsRevisionOfRecord] 
		  ,WT.[WorkflowTaskID]
		  ,WT.[TaskTypeID]
		  ,WT.[TaskSequence]
		  ,TT.[TaskName]
		  ,TT.[IsActive] AS IsActiveTaskType
	FROM [LibertyPower].[dbo].[Workflow]		 W   (NOLOCK)
	JOIN [LibertyPower].[dbo].[WorkflowTask]	 WT  (NOLOCK) ON W.WorkflowID = WT.WorkflowID
	JOIN [LibertyPower].[dbo].[TaskType]		 TT  (NOLOCK) ON WT.TaskTypeID = TT.TaskTypeID
	WHERE (@WorkflowID is null OR W.WorkflowID = @WorkflowID)
	  AND (@WorkflowTaskID is null OR WT.WorkflowTaskID = @WorkflowTaskID)
	  AND (WT.IsDeleted is null OR WT.IsDeleted = 0)
	ORDER BY WT.[TaskSequence]
    
END

GO


-------------------------------


USE [LibertyPower]
GO

/****** Object:  StoredProcedure [dbo].[usp_AutoApproveDocumentsConfigurationInsert]    Script Date: 08/21/2012 12:05:25 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_AutoApproveDocumentsConfigurationInsert]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_AutoApproveDocumentsConfigurationInsert]
GO

/****** Object:  StoredProcedure [dbo].[usp_AutoApproveDocumentsConfigurationSelect]    Script Date: 08/21/2012 12:05:25 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_AutoApproveDocumentsConfigurationSelect]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_AutoApproveDocumentsConfigurationSelect]
GO

/****** Object:  StoredProcedure [dbo].[usp_AutoApproveDocumentsConfigurationUpdate]    Script Date: 08/21/2012 12:05:25 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_AutoApproveDocumentsConfigurationUpdate]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_AutoApproveDocumentsConfigurationUpdate]
GO

/****** Object:  StoredProcedure [dbo].[usp_AutoApproveDocumentsConfigurationUserSelect]    Script Date: 08/21/2012 12:05:25 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_AutoApproveDocumentsConfigurationUserSelect]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_AutoApproveDocumentsConfigurationUserSelect]
GO

USE [LibertyPower]
GO

/****** Object:  StoredProcedure [dbo].[usp_AutoApproveDocumentsConfigurationInsert]    Script Date: 08/21/2012 12:05:25 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		José Rafael Vasconcelos Cavalcante
-- Create date: 5/17/2012
-- Description:	Inserts an "auto approval documents step" configuration for an user
-- =============================================
CREATE PROCEDURE [dbo].[usp_AutoApproveDocumentsConfigurationInsert]
	@UserID INT,
	@AutoApprove BIT
AS
BEGIN

	SET NOCOUNT ON;
	
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	
	INSERT INTO [LibertyPower]..[WorkflowAutoComplete]
		(UserID, AutoApproveDocument)
	VALUES
		(@UserID, @AutoApprove)
		
	SELECT SCOPE_IDENTITY() AS NewConfiguration

END

GO

/****** Object:  StoredProcedure [dbo].[usp_AutoApproveDocumentsConfigurationSelect]    Script Date: 08/21/2012 12:05:25 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		José Rafael Vasconcelos Cavalcante
-- Create date: 5/17/2012
-- Description:	Selects "auto approval documents step" configurations for all users
-- =============================================
CREATE PROCEDURE [dbo].[usp_AutoApproveDocumentsConfigurationSelect]
AS
BEGIN
	
	SET NOCOUNT ON;
	
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	
	DECLARE @Dummy AS BIT --Necessary to explicity declare a bit variable because Telerik Gridview needs this declaration to bind data correctly.
	SET @Dummy = 0
	
	SELECT 
		U.UserID, 
		U.FirstNAme + ' ' + U.LastName as Name,
		CASE WHEN WAC.AutoApproveDocument IS NULL THEN @Dummy ELSE WAC.AutoApproveDocument END AS AutoApprove
	FROM 
		[LibertyPower]..[User] U 
		JOIN [LibertyPower]..[UserRole] UR ON U.UserID = UR.UserID
		LEFT JOIN [LibertyPower]..[WorkflowAutoComplete] WAC ON U.UserID = WAC.UserID
	WHERE UR.RoleID = 24 --LibertyPowerEmployees
END

GO

/****** Object:  StoredProcedure [dbo].[usp_AutoApproveDocumentsConfigurationUpdate]    Script Date: 08/21/2012 12:05:25 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		José Rafael Vasconcelos Cavalcante
-- Create date: 5/17/2012
-- Description:	Updates an "auto approval documents step" configuration for one user
-- =============================================
CREATE PROCEDURE [dbo].[usp_AutoApproveDocumentsConfigurationUpdate]
	@UserID INT,
	@AutoApprove BIT
AS
BEGIN

	SET NOCOUNT ON;
	
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	
	UPDATE [LibertyPower]..[WorkflowAutoComplete]
		SET AutoApproveDocument = @AutoApprove
	WHERE
		UserID = @UserID
		
END

GO

/****** Object:  StoredProcedure [dbo].[usp_AutoApproveDocumentsConfigurationUserSelect]    Script Date: 08/21/2012 12:05:25 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		José Rafael Vasconcelos Cavalcante
-- Create date: 5/17/2012
-- Description:	Check if a Liberty Power Employee has "auto approval documents step" configured
-- =============================================
CREATE PROCEDURE [dbo].[usp_AutoApproveDocumentsConfigurationUserSelect]
	@UserID INT
AS
BEGIN

	SET NOCOUNT ON;
	
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	
	SELECT 
		*
	FROM 
		[LibertyPower]..[WorkflowAutoComplete] WAC
	WHERE 
		WAC.UserID = @UserID
END

GO


