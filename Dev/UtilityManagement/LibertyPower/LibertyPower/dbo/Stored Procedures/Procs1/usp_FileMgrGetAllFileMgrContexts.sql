
/*******************************************************************************
 * usp_FileMgrGetAllFileManagerContexts
 *
 *
 ********************************************************************************/
CREATE PROCEDURE [usp_FileMgrGetAllFileMgrContexts]  
AS


SELECT 
FileManagerContext.ID,
FileManagerContext.ContextKey,
FileManagerContext.BusinessPurpose
FROM
FileManagerContext 
                                                                                                                                          
-- Copyright 2009 Liberty Power


