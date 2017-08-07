
CREATE PROCEDURE [dbo].[usp_DealScreeningStepTypeSelect]
( @Description	varchar(50) = '')
AS
BEGIN
    SET NOCOUNT ON;
	--IF @Description = ''
	--	SELECT	[DealScreeningStepTypeID], [Description]
	--	FROM	DealScreeningStepType
	--	ORDER BY [DealScreeningStepTypeID]
 --   ELSE
	--	SELECT TOP 1 [DealScreeningStepTypeID], [Description]
	--	FROM	DealScreeningStepType
	--	WHERE [Description] LIKE @Description
	--	ORDER BY [DealScreeningStepTypeID]
	
    -- CHANGED FOR IT043
    
   	IF @Description = ''
		SELECT	TaskTypeId as [DealScreeningStepTypeID], TaskName as [Description]
		FROM	TaskType
		ORDER BY TaskTypeId
    ELSE
		SELECT	TaskTypeId as [DealScreeningStepTypeID], TaskName as [Description]
		FROM	TaskType
		WHERE TaskName LIKE @Description
		ORDER BY TaskTypeId
 
    SET NOCOUNT OFF;
END



GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'DealScreening', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_DealScreeningStepTypeSelect';

