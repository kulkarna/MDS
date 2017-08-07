USE [ERCOT]
GO

-- =============================================
-- Author:		Felipe Medeiros	
-- Create date: 02/05/2014
-- Description:	Get Zone value from EDI file value
-- =============================================
CREATE PROCEDURE usp_ZoneValueBySubstationEDIValue
	@Substation varchar(100)
AS
BEGIN
	SET NOCOUNT ON;

    SELECT      
		top 1 
		m. DCZone
	FROM
		ERCOT..AccountInfoSettlement s (nolock)
		INNER JOIN ERCOT..AccountInfoZoneMapping m (nolock) ON s.SettlementLoadZone = m.ErcotZone
	WHERE
		s.Substation = @Substation
	
	SET NOCOUNT OFF;
END
GO


