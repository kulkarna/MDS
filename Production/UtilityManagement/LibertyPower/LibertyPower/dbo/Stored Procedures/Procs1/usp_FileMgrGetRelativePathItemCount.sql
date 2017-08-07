
/*******************************************************************************
 * usp_FileMgrGetRelativePathItemCount
 *
 *
 ********************************************************************************/
CREATE PROCEDURE usp_FileMgrGetRelativePathItemCount
	@RelativePath   varchar(1024)                                                                             
AS

SELECT 
COUNT(RelativePath) 
FROM FileManagerRelativePaths 
WHERE RelativePath like @RelativePath + '%'
--

   
                                                                                                                                          
-- Copyright 2009 Liberty Power

