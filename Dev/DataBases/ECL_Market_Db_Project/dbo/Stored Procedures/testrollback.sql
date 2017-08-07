Create Procedure testrollback
(
	@TableName varchar(100),
	@Id Int
)
AS
Begin

Delete from TestEMp  where Empid=4
	Declare @SQLQuery varchar(max);
	Set @SQLQuery= 'Delete from ' + @TableName +' where Empid= '+Cast(@Id as varchar)
	EXEC (@SQLQuery)

End