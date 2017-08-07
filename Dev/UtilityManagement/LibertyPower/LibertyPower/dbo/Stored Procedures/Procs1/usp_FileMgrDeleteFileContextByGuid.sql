
/*******************************************************************************
 * usp_FileMgrDeleteFileContextByGuid
 *
 *
 ********************************************************************************/
CREATE PROCEDURE [dbo].[usp_FileMgrDeleteFileContextByGuid]  
	@FileGuid	UNIQUEIDENTIFIER
AS

DELETE FROM FileContext 
WHERE FileContext.FileGuid = @FileGuid

                                                                                                                                          
-- Copyright 2009 Liberty Power
