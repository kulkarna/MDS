USE [LibertyPower]
Go
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS ( SELECT * FROM sys.objects WITH (NOLOCK) WHERE name = 'ufn_GetContractTypeId' AND type_desc = 'SQL_SCALAR_FUNCTION')
DROP Function [ufn_GetContractTypeId];
GO
-- =============================================
-- Author:		Jaime Forero
-- Create date: 8/19/2011
-- Description:	Get Contract Type based on string value, to be used for backward compatibility
-- Modified By:		Pradeep Katiyar
-- Create date: 7/17/2014
-- Description:	Get Contract Type Id based on string value other than Voice and Paper.
-- =============================================

Create FUNCTION [dbo].[ufn_GetContractTypeId]
(
	-- Add the parameters for the function here
	@p_StringContractType VARCHAR(50)
)
RETURNS INT
AS
BEGIN
	DECLARE @w_ContractTypeID INT;
	
	if exists(	SELECT CT.ContractTypeID FROM LibertyPower.dbo.ContractType CT (NOLOCK) 
			 WHERE LOWER(CT.[Type]) =  LOWER(LTRIM(RTRIM(@p_StringContractType))) )
			 
		SELECT @w_ContractTypeID = CT.ContractTypeID FROM LibertyPower.dbo.ContractType CT (NOLOCK) 
			 WHERE LOWER(CT.[Type]) =  LOWER(LTRIM(RTRIM(@p_StringContractType)))
	else
		SELECT @w_ContractTypeID = CT.ContractTypeID FROM LibertyPower.dbo.ContractType CT (NOLOCK) 
			 WHERE LOWER(CT.[Type]) =  'PAPER' 	
	-- Return the result of the function
	RETURN @w_ContractTypeID;

END


