
-- =============================================
-- Author:		Rick Deigsler
-- Create date: 7/24/2008
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[usp_pricing_role_ins]

@p_pricing_id	int,
@p_role_id		int

AS

INSERT INTO	pricing_role (pricing_id, role_id)
VALUES		(@p_pricing_id, @p_role_id)