USE [LibertyPower]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/*
*******************************************************************************
*
* PROCEDURE:	[usp_GetPropertyList]
*
* DEFINITION:  Selects all records from DeliveryPointInternalRef and IsoDeliveryPointMapping
				
*
* RETURN CODE: 
*
* REVISIONS:	
* 03/21/2013 Abhi Kulkarni	Initial version.
* usp_GetPropertyList s
*******************************************************************************
*/

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'usp_GetPropertyList')
    BEGIN
    	DROP PROCEDURE usp_GetPropertyList
    END
GO

CREATE PROCEDURE [dbo].[usp_GetPropertyList]		
AS

BEGIN
	
	SET NOCOUNT ON
	
	SELECT	ID, Name
	FROM	LibertyPower.dbo.Property (nolock)	

	SET NOCOUNT OFF
END

GO
