/*
******************************************************************************

 * PROCEDURE:	[usp_RollbackdataNstar]
 * PURPOSE:		Delete record from Nstar 
 * HISTORY:		 
 *******************************************************************************
 * 11/12/2014 - Santosh Rao
 * Created.
 
 *******************************************************************************
  */
CREATE PROCEDURE usp_RollbackdataNstar

AS
BEGIN
 -- Delete the row from reference table[Nstar].

 Truncate table [Staging].[Nstar] 

END

