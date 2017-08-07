

/********************************************************************************
* usp_VRE_ISOZoneSelect
* Procedure to search rows in the VRECostComponents table

* History
********************************************************************************
* 06/09/2010  - SWCS / David Maia
* Created.
********************************************************************************/

CREATE procedure [dbo].[usp_VRE_ISOZoneSelect] ( 
	@ID varchar(50))
as

set nocount on 

select 
	ID,
	UtilityCode,
	Zone,
	ISOZone
from VREISOZone with (nolock)
where ID                = @ID

set nocount off




GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'VRE', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_VRE_ISOZoneSelect';

