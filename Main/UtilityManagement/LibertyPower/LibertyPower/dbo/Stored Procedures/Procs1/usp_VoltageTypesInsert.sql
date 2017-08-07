/*******************************************************************************
 * [usp_VoltageTypesInsert]
 * Inserts new VoltageCode
 *******************************************************************************/
 
CREATE PROCEDURE [dbo].[usp_VoltageTypesInsert](
@VoltageCode varchar(128)
)
AS
BEGIN
    SET NOCOUNT ON;
    
    INSERT INTO Voltage(VoltageCode) VALUES (@VoltageCode)
    
    SELECT ID, VoltageCode COLLATE sql_latin1_general_cp1_cs_as AS VoltageCode FROM Voltage (NOLOCK)
    WHERE ID = SCOPE_IDENTITY()
    
    SET NOCOUNT OFF;
END
-- Copyright 2010 Liberty Power


