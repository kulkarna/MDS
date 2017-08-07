

/********************************************************************************
* usp_VRE_ISOZoneSelect
* Procedure to delete a row in the VREISOZone table
*/

CREATE procedure [dbo].[usp_VRE_ISOZoneDelete] ( 
	@ID varchar(50))
as

set nocount on 

UPDATE
VREISOZone 
SET IsActive = 0, DateModified = GETDATE()
where ID                = @ID

set nocount off




GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'VRE', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_VRE_ISOZoneDelete';

