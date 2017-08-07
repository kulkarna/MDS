
CREATE PROC [dbo].[InsertGenerator]
(@tableName varchar(100)) as
--Declare a cursor to retrieve column specific information 
--for the specified table
DECLARE cursCol CURSOR FAST_FORWARD FOR 
SELECT column_name,data_type FROM information_schema.columns 
    WHERE table_name = @tableName
OPEN cursCol
DECLARE @string nvarchar(3000) --for storing the first half 
                               --of INSERT statement
DECLARE @stringData nvarchar(4000) --for storing the data 
                                   --(VALUES) related statement
DECLARE @dataType nvarchar(4000) --data types returned 
                                 --for respective columns
SET @string='INSERT '+@tableName+'('
SET @stringData=''

DECLARE @colName nvarchar(50)

FETCH NEXT FROM cursCol INTO @colName,@dataType

IF @@fetch_status<>0
    begin
    print 'Table '+@tableName+' not found, processing skipped.'
    close curscol
    deallocate curscol
    return
END

WHILE @@FETCH_STATUS=0
BEGIN
IF @dataType in ('varchar','char','nchar','nvarchar')
BEGIN
    SET @stringData=@stringData+'''''''''+
            isnull('+@colName+','''')+'''''',''+'
END
ELSE
if @dataType in ('text','ntext') --if the datatype 
                                 --is text or something else 
BEGIN
    SET @stringData=@stringData+'''''''''+
          isnull(cast('+@colName+' as varchar(2000)),'''')+'''''',''+'
END
ELSE
IF @dataType = 'money' --because money doesn't get converted 
                       --from varchar implicitly
BEGIN
    SET @stringData=@stringData+'''convert(money,''''''+
        isnull(cast('+@colName+' as varchar(200)),''0.0000'')+''''''),''+'
END
ELSE 
IF @dataType='datetime'
BEGIN
    SET @stringData=@stringData+'''convert(datetime,''''''+
        isnull(cast('+@colName+' as varchar(200)),''0'')+''''''),''+'
END
ELSE 
IF @dataType='image' 
BEGIN
    SET @stringData=@stringData+'''''''''+
       isnull(cast(convert(varbinary,'+@colName+') 
       as varchar(6)),''0'')+'''''',''+'
END
ELSE --presuming the data type is int,bit,numeric,decimal 
BEGIN
    SET @stringData=@stringData+'''''''''+
          isnull(cast('+@colName+' as varchar(200)),''0'')+'''''',''+'
END

SET @string=@string+@colName+','

FETCH NEXT FROM cursCol INTO @colName,@dataType
END
DECLARE @Query nvarchar(4000) -- provide for the whole query, 
                              -- you may increase the size

SET @query ='SELECT '''+substring(@string,0,len(@string)) + ') 
    VALUES(''+ ' + substring(@stringData,0,len(@stringData)-2)+'''+'')'' 
    FROM '+@tableName
exec sp_executesql @query --load and run the built query
CLOSE cursCol
DEALLOCATE cursCol
