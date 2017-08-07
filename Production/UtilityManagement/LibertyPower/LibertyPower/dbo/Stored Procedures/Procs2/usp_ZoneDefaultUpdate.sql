
/* **********************************************************************************************
 *	Author:		Cghazal																			*
 *	Created:	10/10/2011																		*
 *	Descp:		update default zone																*
 *	Modified:																					*
 ********************************************************************************************** */
CREATE PROCEDURE [dbo].[usp_ZoneDefaultUpdate]
				@ZoneID int,
				@ID int
AS
				
UPDATE	Utility
SET		ZoneDefault = @ZoneID
WHERE	ID =@ID
