



/*******************************************************************************
 * usp_FileMgrInsertFileContext
 *
 *
 ******************************************************************************/
CREATE PROCEDURE [dbo].[usp_FileMgrInsertFileContext]  
	@ContextKey				varchar(50),   
	@FileGuid						uniqueidentifier,
	@RelativePath				varchar(1024),
	@OriginalFileName	varchar(256),
	@FileName					varchar(512),
	@UserID						INT 

AS
BEGIN TRANSACTION

	DECLARE @RootID INT
	SET @RootID = 
		(     
			SELECT ManagerRoot.ID  
			FROM ManagerRoot LEFT JOIN FileManager
			ON  ManagerRoot.FileManagerID = FileManager.ID
			WHERE  FileManager.ContextKey =  @ContextKey AND ManagerRoot.IsActive = 1 
		 )

	DECLARE @FileManagerID INT
	SET @FileManagerID = (SELECT ID FROM FileManager WHERE ContextKey = @ContextKey)

	DECLARE @ManagedBinID INT
	SET @ManagedBinID = (SELECT TOP 1 ID FROM ManagedBin WITH (NOLOCK) WHERE ManagerRootID = @RootID AND RelativePath = @RelativePath ORDER BY ItemCount DESC) 

	INSERT INTO FileContext(FileGuid, ManagedBinID, OriginalFilename, FileName, UserID)
	VALUES (@FileGuid, @ManagedBinID, @OriginalFileName, @FileName, @UserID)

	--UPDATE ManagedBin SET ItemCount =  ItemCount + 1 WHERE ID = @ManagedBinID		--Fails to increment the correct record if a dup ManagedBin was created
	UPDATE ManagedBin SET ItemCount = ItemCount + 1
	WHERE ManagerRootID = @RootID AND RelativePath = @RelativePath		--In the rare case that transactional problems in FileManager code created a duplidate ManagedBin, this should increment all records

	SELECT FileContext.FileGuid, ManagerRoot.Root, ManagedBin.RelativePath, FileContext.FileName, FileContext.OriginalFileName, FileContext.CreationTime, FileContext.UserID
	FROM FileContext  
	LEFT JOIN ManagedBin ON FileContext.ManagedBinID = ManagedBin.[ID]
	INNER JOIN ManagerRoot ON ManagedBin.ManagerRootID = ManagerRoot.[ID]
	WHERE FileContext.FileGuid = @FileGuid

IF @@ERROR = 0
	COMMIT
ELSE
	ROLLBACK                                                                                                                                          
-- Copyright 2009 Liberty Power



