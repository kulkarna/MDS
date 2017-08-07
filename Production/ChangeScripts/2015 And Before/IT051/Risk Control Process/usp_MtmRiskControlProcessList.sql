USE [lp_MtM]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Felipe Medeiros
-- Create date: 10/31/2013
-- Description: Return all accounts' failures
-- =============================================
CREATE PROCEDURE usp_MtmRiskControlProcessList
AS
BEGIN
	
	SET NOCOUNT ON;

	select p.*, r.Description as ReasonDesc, i.ISO
	from MtmRiskControlProcess p (nolock)
	join MtMRiskControlReasons r (nolock) on (p.ReasonID = r.Id)
	join MtMAccount a (nolock) on (p.MtMAccountID = a.ID)
	join MtMZainetAccountInfo i (nolock) on (p.AccountID = i.AccountID and a.ContractID = i.ContractID)

	SET NOCOUNT OFF;
END
GO
