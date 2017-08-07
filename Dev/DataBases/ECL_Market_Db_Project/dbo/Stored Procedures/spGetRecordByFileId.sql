CREATE PROCEDURE spGetRecordByFileId
 @Fileid Int,
 @Filename  varchar(250)= ' ' Output,
 @SourceId  varchar(20)= ' ' Output
 AS
 BEGIN
 SELECT @Filename = FileName,
 @SourceId =SourceId
FROM FileImport_1 
WHERE Id = @Fileid

--SELECT @Filename ,@SourceId 

 END



