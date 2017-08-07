/*******************************************************************************
 * usp_IcapFactorMarketExemptionsSelect
 * Get the utilities that do not have icap factor calculations
 *
 * History
 *******************************************************************************
 * 2/12/2009 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_IcapFactorMarketExemptionsSelect]                                                                                    
	
AS
BEGIN
    SET NOCOUNT ON;

	SELECT	RetailMarketId, IcapException, TcapException, ZeroIcap, ZeroTcap
	FROM	IcapFactorMarketExemptions

    SET NOCOUNT OFF;
END                                                                                                                                              
-- Copyright 2009 Liberty Power
