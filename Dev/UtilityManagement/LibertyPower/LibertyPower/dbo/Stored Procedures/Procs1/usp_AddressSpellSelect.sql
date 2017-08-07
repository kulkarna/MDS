-- ========================================================================
-- Author:		Antonio Jr
-- Create date: 11/26/2009
-- Description:	Gets all the tokens and alternative tokens of AddressSpell
-- ========================================================================
CREATE PROCEDURE [dbo].[usp_AddressSpellSelect]
AS
BEGIN
	SET NOCOUNT ON;

	SELECT Token, AlternativeToken
	FROM AddressSpell
	
END
