
CREATE PROCEDURE [dbo].[usp_ProfilingHedgeBlockSelect]  

@ProfilingQueueID int

AS
  
	
    SELECT ID, ProfilingQueueID, HedgeBlockFileName, HedgeBlockContents, DateCreated 
    FROM ProfilingHedgeBlock (NOLOCK)
    WHERE ProfilingQueueID = @ProfilingQueueID
