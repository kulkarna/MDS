



-- =============================================
-- Author:		<Sofia Melo>
-- Create date: <06/23/2010>
-- Description:	<Gets the types of tax>
-- =============================================

CREATE PROCEDURE [dbo].[usp_TaxTypeSelect]

AS
BEGIN
    SET NOCOUNT ON;
    
	SELECT	*
	FROM	[LibertyPower].[dbo].[TaxType]
    
    SET NOCOUNT OFF;
END
-- Copyright 2009 Liberty Power





