CREATE PROC Insert_Generator
(@tableName varchar(100)) AS
BEGIN
DECLARE @IdentityInfo int
 
SELECT @IdentityInfo = OBJECTPROPERTY( OBJECT_ID(@tablename), 'TableHasIdentity')
IF @IdentityInfo = 1
SELECT 'SET IDENTITY_INSERT '+@tableName+ ' ON'
--Cursor Declaration to retrieve column specific info for the specified table
DECLARE cur_ColumnInfo CURSOR FAST_FORWARD FOR 
SELECT column_name,data_type FROM information_schema.COLUMNS WHERE table_name = @tableName
 
OPEN cur_ColumnInfo
DECLARE @str nvarchar(3000) --Store columns of insert statement
DECLARE @strValue nvarchar(3000) --Store the Values related statement
DECLARE @dataType nvarchar(1000) --Store datatypes returned for columns
 
SET @str='INSERT '+@tableName+'('
SET @strValue=''
 
DECLARE @colName nvarchar(50)
 
FETCH NEXT FROM cur_ColumnInfo INTO @colName,@dataType
 
IF @@fetch_status<>0
    begin
    print 'Table '+@tableName+' does not exist.'
    close cur_ColumnInfo
    deallocate cur_ColumnInfo
    RETURN
END
 
WHILE @@FETCH_STATUS=0
BEGIN
IF @dataType IN ('varchar','char','nchar','nvarchar')
BEGIN
    SET @strValue=@strValue+'''''''''+
            isnull('+@colName+','''')+'''''',''+'
END
ELSE
IF @dataType IN ('text','ntext') 
 
BEGIN
    SET @strValue=@strValue+'''''''''+
          isnull(cast('+@colName+' as varchar(2000)),'''')+'''''',''+'
END
ELSE
IF @dataType = 'money' --money datatype does not convert to varchar implicitly
 
BEGIN
    SET @strValue=@strValue+'''convert(money,''''''+
        isnull(cast('+@colName+' as varchar(200)),''0.0000'')+''''''),''+'
END
ELSE 
IF @dataType='datetime'
BEGIN
    SET @strValue=@strValue+'''convert(datetime,''''''+
        isnull(cast('+@colName+' as varchar(200)),''0'')+''''''),''+'
END
ELSE 
IF @dataType='image' 
BEGIN
    SET @strValue=@strValue+'''''''''+
       isnull(cast(convert(varbinary,'+@colName+') 
       as varchar(6)),''0'')+'''''',''+'
END
ELSE 
BEGIN
    SET @strValue=@strValue+'''''''''+
          isnull(cast('+@colName+' as varchar(200)),''0'')+'''''',''+'
END
 
SET @str=@str+@colName+','
 
FETCH NEXT FROM cur_ColumnInfo INTO @colName,@dataType
END
DECLARE @query nvarchar(max) -- You can decrease or increase it accordingly e.g., nvarchar(4000) for SQL server 2000
 
SET @query ='SELECT '''+substring(@str,0,len(@str)) + ') 
    VALUES(''+ ' + substring(@strValue,0,len(@strValue)-2)+'''+'')'' 
    FROM '+@tableName
exec sp_executesql @query 
CLOSE cur_ColumnInfo
DEALLOCATE cur_ColumnInfo
END
IF @IdentityInfo = 1
SELECT 'SET IDENTITY_INSERT '+@tableName+ ' OFF'