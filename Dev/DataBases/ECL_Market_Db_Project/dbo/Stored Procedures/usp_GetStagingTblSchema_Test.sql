
/*
******************************************************************************

 * PROCEDURE:	[usp_GetStagingTblSchema]
 * PURPOSE:		Get staging Table Coulm Name on the basis of TableName
 * HISTORY:		 
 *******************************************************************************
 * 12/23/2014 - Santosh Rao
 * Created.
 
 *******************************************************************************
  */
Create Procedure usp_GetStagingTblSchema_Test
(
	@TableName varchar(100) = NULL
)
AS
Set noCount on;
SELECT COLUMN_NAME  FROM INFORMATION_SCHEMA.COLUMNS with(nolock) where TABLE_NAME= @TableName  and TABLE_SCHEMA='Staging'
and  COLUMN_NAME not in('ID','ContextDate','IsValid','DateCreated','FileImportID')

Set noCount Off;