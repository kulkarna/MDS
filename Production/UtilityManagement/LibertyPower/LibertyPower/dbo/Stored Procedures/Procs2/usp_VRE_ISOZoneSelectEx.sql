
/********************************************************************************
* usp_VRE_ISOZoneSelectEx
* Procedure to search rows in the VREISOZone table

* History
********************************************************************************
* 09/07/2010  - SWCS / Leandro Paiva
* Created.
********************************************************************************/

CREATE procedure [dbo].[usp_VRE_ISOZoneSelectEx] ( 
	 @UtilityCode		varchar(50)
	,@ContextDate		datetime
	)
as

set nocount on 

select
	ID,
	UtilityCode,
	Zone,
	ISOZone,
	DateCreated,
	CreatedBy
	
from VREISOZone with (nolock)
where UtilityCode   = @UtilityCode
AND	  DateCreated	<= @ContextDate
ORDER BY DateCreated DESC

set nocount off






GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'VRE', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_VRE_ISOZoneSelectEx';

