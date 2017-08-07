USE [lp_MtM]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Felipe Medeiros
-- Create date: 10/28/2013
-- Description:	Procedure to return the sum of the load of one account, if it is 0, the etp process will be aborted
-- =============================================
CREATE PROCEDURE usp_CPEValidateDailyWholesaleLoadForecast
	@MtMAccountID as int
AS
BEGIN
	SET NOCOUNT ON;

	select 
		(SUM(l.Int1) + SUM(l.Int2) + SUM(l.Int3) + SUM(l.Int4) + SUM(l.Int5) + SUM(l.Int6) + SUM(l.Int7) + SUM(l.Int8) +   
		SUM(l.Int9) + SUM(l.Int10) + SUM(l.Int11) + SUM(l.Int12) + SUM(l.Int13) + SUM(l.Int14) + SUM(l.Int15) + SUM(l.Int16) +   
		SUM(l.Int17) + SUM(l.Int18) + SUM(l.Int19) + SUM(l.Int20) + SUM(l.Int21) + SUM(l.Int22) + SUM(l.Int23) + SUM(l.Int24)) as WhosaleLoad
	from 
		MtMDailyWholesaleLoadForecast l (nolock)
	where 
		MtMAccountID = @MtmAccountID

	SET NOCOUNT OFF;
END
GO
