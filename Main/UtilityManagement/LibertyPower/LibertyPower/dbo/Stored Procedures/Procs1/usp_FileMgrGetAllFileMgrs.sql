

/*******************************************************************************
 * usp_FileMgrGetAllFileMgrs
 *
 *
 ********************************************************************************/
CREATE PROCEDURE [dbo].[usp_FileMgrGetAllFileMgrs]  
AS
SELECT 
FileManager.ID,
FileManager.ContextKey,
FileManager.BusinessPurpose,
FileManager.CreationTime,
FileManager.UserID
FROM
FileManagert 
                                                                                                                                          
-- Copyright 2009 Liberty Power

