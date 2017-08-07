/*******************************************************************************
 * [usp_VoltageTypesUpdate]
 * Updates Voltage table based on OE_ACCOUNT voltages
 *******************************************************************************/
 
CREATE PROCEDURE [dbo].[usp_VoltageTypesUpdate]
AS
BEGIN
    SET NOCOUNT ON;
    
    INSERT INTO Voltage 
    SELECT DISTINCT LTRIM(RTRIM(VOLTAGE)) COLLATE sql_latin1_general_cp1_cs_as AS VoltageCode
    FROM OfferengineDB..OE_ACCOUNT (NOLOCK) 
    WHERE LTRIM(RTRIM(VOLTAGE))COLLATE sql_latin1_general_cp1_cs_as
    NOT IN (SELECT VoltageCode COLLATE sql_latin1_general_cp1_cs_as FROM Voltage (NOLOCK))
    
    SELECT ID, VoltageCode FROM Voltage (NOLOCK) ORDER BY VoltageCode    
    SET NOCOUNT OFF;
END
-- Copyright 2010 Liberty Power


