use LibertyPower
go

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/************************************************************************************************
 Author:		Abhijeet Kulkarni
 Create date:	03/01/2013
 Description:	Inserts new record in IsoDeliveryPointMapping
************************************************************************************************/

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'usp_InsertIsoValue')
    BEGIN
    	DROP PROCEDURE usp_InsertIsoValue
    END
GO
 
CREATE PROCEDURE [dbo].[usp_InsertIsoValue](
	@IsoID int
	,@IsoValue varchar(50)
	,@UserID int
)
AS
BEGIN
    SET NOCOUNT ON;
    
    IF NOT EXISTS (SELECT 1 FROM LibertyPower.dbo.IsoDeliveryPointMapping 
				WHERE IsoID = @IsoID AND IsoValue = @IsoValue)
	BEGIN
		INSERT INTO LibertyPower.dbo.IsoDeliveryPointMapping (IsoID, IsoValue, DateCreated, CreatedBy)
		VALUES (@IsoID, @IsoValue, GETDATE(), @UserID)
	END
	    
    SELECT ID, IsoID, IsoValue FROM LibertyPower.dbo.IsoDeliveryPointMapping (NOLOCK)
    WHERE ID = SCOPE_IDENTITY()
    
    SET NOCOUNT OFF;
END

