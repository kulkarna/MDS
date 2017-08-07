

/*******************************************************************************
 * usp_FileMgrGetManagedBinSortedByItemCount
 *
 *
 ********************************************************************************/
CREATE PROCEDURE [dbo].[usp_FileMgrGetManagedBinSortedByItemCount]
	@ContextKey VARCHAR(50),
	@Root VARCHAR(512)
AS
DECLARE @FileManagerID INT
DECLARE @ManagerRootID INT

SET @FileManagerID = (SELECT ID FROM FileManager WHERE ContextKey = @ContextKey)
SET @ManagerRootID = ( SELECT ID FROM  ManagerRoot WHERE FileManagerID = @FileManagerID AND  Root = @Root)

--NOTE:	ItemCount relies on its value being incremented every time we add a file;  do not add FileContext items
--				other than through the provided stored procedures or ensure that any other mechanism also increments 
--				ItemCount for the appropriate ManagedBin

SELECT 
ManagedBin.ID,
FileManager.ContextKey,
ManagerRoot.Root,
ManagedBin.RelativePath,
ManagedBin.ItemCount,
ManagedBin.CreationTime,
ManagedBin.UserID
FROM ManagedBin LEFT JOIN ManagerRoot ON ManagedBin.ManagerRootID = ManagerRoot.ID
INNER JOIN FileManager ON ManagerRoot.FileManagerID = FileManager.ID
WHERE ManagerRoot.FileManagerID = @FileManagerID AND ManagedBin.ManagerRootID = @ManagerRootID
ORDER BY ManagedBin.ItemCount, ManagedBin.ID desc  

--- If null is returned, or the  top item has > allowed ItemCount, then the expected behavior of the caller is to create 
--  a new physical path as the active bin and call the procedure to add it to ManagedBisn and set it active


