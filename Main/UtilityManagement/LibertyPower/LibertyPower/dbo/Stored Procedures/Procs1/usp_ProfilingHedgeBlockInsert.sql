

CREATE PROCEDURE [dbo].[usp_ProfilingHedgeBlockInsert]  

@ProfilingQueueID int,
@HedgeBlockFileName varchar(128) = NULL,
@HedgeBlockContents varchar(MAX) = NULL

AS
BEGIN TRANSACTION

    DELETE FROM ProfilingHedgeBlock WHERE ProfilingQueueID = @ProfilingQueueID AND HedgeBlockFileName = @HedgeBlockFileName
    
    INSERT INTO ProfilingHedgeBlock (ProfilingQueueID, HedgeBlockFileName, HedgeBlockContents ) VALUES (@ProfilingQueueID, @HedgeBlockFileName, @HedgeBlockContents)

    SELECT ID, ProfilingQueueID, HedgeBlockFileName, HedgeBlockContents, DateCreated 
    FROM ProfilingHedgeBlock (NOLOCK)
    WHERE ProfilingQueueID = @ProfilingQueueID AND HedgeBlockFileName = @HedgeBlockFileName


IF @@ERROR = 0
	COMMIT
ELSE
	ROLLBACK