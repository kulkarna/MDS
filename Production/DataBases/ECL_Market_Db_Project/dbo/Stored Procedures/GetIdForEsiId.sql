/*
******************************************************************************

 * PROCEDURE:	[Usp_RollbackdataOEEPICAEP]
 * PURPOSE:		Delete record from OfferEngineEPICAEP and Fileimport table on the basis of fieldId
 * HISTORY:		 
 *******************************************************************************
 * 11/07/2014 - Santosh Rao
 * Created.
 
 *******************************************************************************
  */

 CREATE PROCEDURE dbo.GetIdForEsiId
(
	@SheetName varchar(100),
	@FileImportId int,
	@AccountRecId AS INT OUTPUT
 )
AS
BEGIN TRY
	
	Set nocount on;
	Set @AccountRecId=0

-- Get Id field data from Account table
IF((CHARINDEX('-', @SheetName)>0) and ( CHARINDEX('$', @SheetName)>0))
	Begin

	SELECT @SheetName= SUBSTRING(@SheetName,CHARINDEX('-', @SheetName)+1,CHARINDEX('$', @SheetName)- (CHARINDEX('-', @SheetName)+1))

	Select @AccountRecId=Id from Staging.OEEPICTPENAccount with(nolock) where ESIID = @SheetName and FileImportID=@FileImportId

	End
--Else
--Begin

--	Set @AccountRecId=0

--end
 
END TRY
BEGIN CATCH


 
END CATCH
 
